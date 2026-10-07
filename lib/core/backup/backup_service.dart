import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/backup_crypto.dart';
import 'package:shishur_dinlipi/core/backup/backup_manifest.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';

typedef BackupProgressCallback = void Function(BackupProgress progress);

enum BackupStage {
  preparing,
  snapshotDatabase,
  collectingMedia,
  buildingArchive,
  encrypting,
  saving,
  complete,
  failed,
}

class BackupProgress {
  const BackupProgress({
    required this.stage,
    this.fraction = 0,
    this.message,
    this.error,
  });

  final BackupStage stage;
  final double fraction;
  final String? message;
  final Object? error;
}

class BackupResult {
  const BackupResult({
    required this.id,
    required this.absolutePath,
    required this.fileName,
    required this.byteSize,
    required this.manifest,
  });

  final String id;
  final String absolutePath;
  final String fileName;
  final int byteSize;
  final BackupManifest manifest;
}

/// Builds an encrypted `.sdjbackup` package (zip → AES-256-GCM).
class BackupService {
  BackupService({
    required this.db,
    required this.storage,
    IdGenerator? ids,
    AppLogger? logger,
  }) : _ids = ids ?? idGenerator,
       _logger = logger ?? AppLogger.instance;

  final AppDatabase db;
  final FileStorageService storage;
  final IdGenerator _ids;
  final AppLogger _logger;

  static const fileExtension = 'sdjbackup';
  static const historyIndexFile = 'backup_history.json';

  Future<BackupResult> createBackup({
    required String password,
    required String confirmPassword,
    BackupProgressCallback? onProgress,
  }) async {
    if (password != confirmPassword) {
      throw const BackupFailure(message: 'Passwords do not match.');
    }

    void report(BackupStage stage, double fraction, [String? message]) {
      onProgress?.call(
        BackupProgress(stage: stage, fraction: fraction, message: message),
      );
    }

    final tempRoot = await storage.tempDir();
    final workDir = Directory(
      p.join(tempRoot.path, 'backup_${_ids.next()}'),
    );
    try {
      report(BackupStage.preparing, 0.05);
      await workDir.create(recursive: true);
      final payloadDir = Directory(p.join(workDir.path, 'payload'));
      await payloadDir.create();

      report(BackupStage.snapshotDatabase, 0.15);
      final dbCopy = await _snapshotDatabase(payloadDir);

      report(BackupStage.collectingMedia, 0.35);
      final mediaEntries = await _copyMediaTree(payloadDir);

      report(BackupStage.buildingArchive, 0.55);
      final files = <BackupFileEntry>[
        await _entryFor(dbCopy, 'database.sqlite'),
        ...mediaEntries,
      ];

      final children = await db.childrenDao.getActive();
      final mediaCount = await db.customSelect(
        'SELECT COUNT(*) AS c FROM media_assets WHERE deleted_at IS NULL',
      ).getSingle();
      final assetCount = mediaCount.data['c'] as int? ?? 0;

      final manifest = BackupManifest(
        formatVersion: 1,
        appVersion: '${AppConfig.versionName}+${AppConfig.versionCode}',
        databaseSchemaVersion: AppDatabase.currentSchemaVersion,
        createdAt: DateTime.now().toUtc(),
        childCount: children.length,
        assetCount: assetCount,
        childNames: children.map((c) => c.name).toList(),
        files: files,
      );
      final manifestFile = File(p.join(payloadDir.path, 'manifest.json'));
      await manifestFile.writeAsString(manifest.encode());
      files.add(await _entryFor(manifestFile, 'manifest.json'));

      final checksums = {
        for (final f in files)
          f.path: {'size': f.size, 'checksumSha256': f.checksumSha256},
      };
      final checksumsFile = File(p.join(payloadDir.path, 'checksums.json'));
      await checksumsFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(checksums),
      );

      final archive = Archive();
      await for (final entity in payloadDir.list(recursive: true)) {
        if (entity is! File) continue;
        final relative = p.relative(entity.path, from: payloadDir.path);
        final bytes = await entity.readAsBytes();
        archive.addFile(
          ArchiveFile(relative.replaceAll('\\', '/'), bytes.length, bytes),
        );
      }
      final zipBytes = ZipEncoder().encodeBytes(archive);
      if (zipBytes.isEmpty) {
        throw const BackupFailure(message: 'Failed to build backup archive.');
      }

      report(BackupStage.encrypting, 0.75);
      final encrypted = await BackupCrypto.encrypt(
        plaintext: Uint8List.fromList(zipBytes),
        password: password,
      );

      report(BackupStage.saving, 0.9);
      final backupsDir = await storage.backupsDir();
      final id = _ids.next();
      final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
      final fileName = 'shishur-dinlipi-$stamp.$fileExtension';
      final outFile = await storage.writeBytesAtomic(
        directory: backupsDir,
        fileName: fileName,
        bytes: encrypted,
      );

      final result = BackupResult(
        id: id,
        absolutePath: outFile.path,
        fileName: fileName,
        byteSize: encrypted.length,
        manifest: manifest,
      );
      await _appendHistory(result);
      report(BackupStage.complete, 1.0);
      _logger.info('Backup created', {
        'bytes': result.byteSize,
        'children': manifest.childCount,
      });
      return result;
    } on AppFailure catch (e) {
      onProgress?.call(
        BackupProgress(
          stage: BackupStage.failed,
          fraction: 0,
          message: e.message,
          error: e,
        ),
      );
      rethrow;
    } catch (error, stackTrace) {
      _logger.error(
        'Backup failed',
        error: error,
        stackTrace: stackTrace,
      );
      final failure = BackupFailure(
        message: 'Could not create backup.',
        cause: error,
      );
      onProgress?.call(
        BackupProgress(
          stage: BackupStage.failed,
          fraction: 0,
          message: failure.message,
          error: failure,
        ),
      );
      throw failure;
    } finally {
      if (await workDir.exists()) {
        await workDir.delete(recursive: true);
      }
    }
  }

  Future<List<BackupHistoryEntry>> listLocalHistory() async {
    final dir = await storage.backupsDir();
    final indexFile = File(p.join(dir.path, historyIndexFile));
    if (!await indexFile.exists()) {
      // Fall back to scanning files.
      final entries = <BackupHistoryEntry>[];
      await for (final entity in dir.list()) {
        if (entity is! File) continue;
        if (!entity.path.endsWith('.$fileExtension')) continue;
        final stat = await entity.stat();
        entries.add(
          BackupHistoryEntry(
            id: p.basenameWithoutExtension(entity.path),
            fileName: p.basename(entity.path),
            absolutePath: entity.path,
            createdAt: stat.modified.toUtc(),
            byteSize: stat.size,
          ),
        );
      }
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entries;
    }
    try {
      final decoded = jsonDecode(await indexFile.readAsString());
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((e) {
            final m = Map<String, dynamic>.from(e);
            return BackupHistoryEntry(
              id: m['id'] as String? ?? '',
              fileName: m['fileName'] as String? ?? '',
              absolutePath: m['absolutePath'] as String? ?? '',
              createdAt:
                  DateTime.tryParse(m['createdAt'] as String? ?? '')?.toUtc() ??
                  DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
              byteSize: m['byteSize'] as int? ?? 0,
              childCount: m['childCount'] as int?,
              schemaVersion: m['schemaVersion'] as int?,
            );
          })
          .where((e) => e.absolutePath.isNotEmpty)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {
      return const [];
    }
  }

  Future<File> _snapshotDatabase(Directory payloadDir) async {
    // Checkpoint WAL so the main file is consistent.
    try {
      await db.customStatement('PRAGMA wal_checkpoint(FULL)');
    } catch (_) {}

    // DB lives in application support (parent of shishur_files root).
    final dbPath = p.join(
      (await _applicationSupportDir()).path,
      'shishur_dinlipi.sqlite',
    );
    final source = File(dbPath);
    if (!await source.exists()) {
      throw const BackupFailure(message: 'Database file was not found.');
    }
    final target = File(p.join(payloadDir.path, 'database.sqlite'));
    await source.copy(target.path);
    return target;
  }

  Future<Directory> _applicationSupportDir() async {
    // Mirror path_provider usage from native_connection without importing it.
    final root = await storage.ensureBootstrapped();
    return root.parent;
  }

  Future<List<BackupFileEntry>> _copyMediaTree(Directory payloadDir) async {
    final entries = <BackupFileEntry>[];
    final root = await storage.ensureBootstrapped();
    for (final relative in ['media/images', 'media/thumbnails', 'media/documents']) {
      final src = Directory(p.join(root.path, relative));
      if (!await src.exists()) continue;
      await for (final entity in src.list(recursive: true, followLinks: false)) {
        if (entity is! File) continue;
        final relFromRoot = p.relative(entity.path, from: root.path);
        final dest = File(p.join(payloadDir.path, relFromRoot));
        await dest.parent.create(recursive: true);
        try {
          await entity.copy(dest.path);
          entries.add(await _entryFor(dest, relFromRoot.replaceAll('\\', '/')));
        } catch (_) {
          // Missing/unreadable asset: record in log, continue (QA: missing asset).
          _logger.warn('Skipped missing backup asset', {'path': relFromRoot});
        }
      }
    }
    return entries;
  }

  Future<BackupFileEntry> _entryFor(File file, String relativePath) async {
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes).toString();
    return BackupFileEntry(
      path: relativePath.replaceAll('\\', '/'),
      size: bytes.length,
      checksumSha256: digest,
    );
  }

  Future<void> _appendHistory(BackupResult result) async {
    final dir = await storage.backupsDir();
    final indexFile = File(p.join(dir.path, historyIndexFile));
    final existing = await listLocalHistory();
    final next = [
      {
        'id': result.id,
        'fileName': result.fileName,
        'absolutePath': result.absolutePath,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
        'byteSize': result.byteSize,
        'childCount': result.manifest.childCount,
        'schemaVersion': result.manifest.databaseSchemaVersion,
      },
      ...existing.map(
        (e) => {
          'id': e.id,
          'fileName': e.fileName,
          'absolutePath': e.absolutePath,
          'createdAt': e.createdAt.toIso8601String(),
          'byteSize': e.byteSize,
          'childCount': e.childCount,
          'schemaVersion': e.schemaVersion,
        },
      ),
    ].take(20).toList();
    await indexFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(next),
    );
  }
}
