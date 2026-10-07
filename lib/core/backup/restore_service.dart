import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shishur_dinlipi/core/backup/backup_crypto.dart';
import 'package:shishur_dinlipi/core/backup/backup_manifest.dart';
import 'package:shishur_dinlipi/core/backup/backup_service.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';
import 'package:shishur_dinlipi/core/repository/reminders_repository.dart';

typedef RestoreProgressCallback = void Function(RestoreProgress progress);

enum RestoreStage {
  reading,
  decrypting,
  validating,
  preview,
  safetyBackup,
  restoring,
  migrating,
  rebuilding,
  complete,
  failed,
}

class RestoreProgress {
  const RestoreProgress({
    required this.stage,
    this.fraction = 0,
    this.message,
    this.error,
  });

  final RestoreStage stage;
  final double fraction;
  final String? message;
  final Object? error;
}

class RestorePreview {
  const RestorePreview({
    required this.manifest,
    required this.sourcePath,
    required this.workDir,
  });

  final BackupManifest manifest;
  final String sourcePath;
  final Directory workDir;
}

class RestoreResult {
  const RestoreResult({
    required this.manifest,
    required this.safetyBackupPath,
  });

  final BackupManifest manifest;
  final String? safetyBackupPath;
}

/// Validates and restores an encrypted `.sdjbackup` onto this device.
class RestoreService {
  RestoreService({
    required this.db,
    required this.storage,
    required this.backupService,
    this.reminders,
    IdGenerator? ids,
    AppLogger? logger,
  }) : _ids = ids ?? idGenerator,
       _logger = logger ?? AppLogger.instance;

  final AppDatabase db;
  final FileStorageService storage;
  final BackupService backupService;
  final RemindersRepository? reminders;
  final IdGenerator _ids;
  final AppLogger _logger;

  /// Decrypt + integrity check; returns preview without mutating live data.
  Future<RestorePreview> prepare({
    required File backupFile,
    required String password,
    RestoreProgressCallback? onProgress,
  }) async {
    void report(RestoreStage stage, double fraction, [String? message]) {
      onProgress?.call(
        RestoreProgress(stage: stage, fraction: fraction, message: message),
      );
    }

    report(RestoreStage.reading, 0.05);
    if (!await backupFile.exists()) {
      throw const RestoreFailure(message: 'Backup file was not found.');
    }
    final package = await backupFile.readAsBytes();

    report(RestoreStage.decrypting, 0.2);
    final zipBytes = await BackupCrypto.decrypt(
      package: Uint8List.fromList(package),
      password: password,
    );

    report(RestoreStage.validating, 0.4);
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final temp = await storage.tempDir();
    final workDir = Directory(p.join(temp.path, 'restore_${_ids.next()}'));
    await workDir.create(recursive: true);

    for (final file in archive.files) {
      if (!file.isFile) continue;
      final out = File(p.join(workDir.path, file.name));
      await out.parent.create(recursive: true);
      final content = file.content;
      final bytes = Uint8List.fromList(List<int>.from(content));
      await out.writeAsBytes(bytes, flush: true);
    }

    final manifestFile = File(p.join(workDir.path, 'manifest.json'));
    if (!await manifestFile.exists()) {
      throw const RestoreFailure(message: 'Backup is missing manifest.json.');
    }
    final manifest = BackupManifest.decode(await manifestFile.readAsString());

    // Integrity: verify checksums for listed files that exist.
    for (final entry in manifest.files) {
      if (entry.path == 'manifest.json') continue;
      final file = File(p.join(workDir.path, entry.path));
      if (!await file.exists()) {
        _logger.warn('Restore missing asset', {'path': entry.path});
        continue;
      }
      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes).toString();
      if (entry.checksumSha256.isNotEmpty && digest != entry.checksumSha256) {
        throw RestoreFailure(
          message: 'Checksum mismatch for ${entry.path}. Backup may be corrupt.',
        );
      }
    }

    // Prefer checksums.json when present.
    final checksumsFile = File(p.join(workDir.path, 'checksums.json'));
    if (await checksumsFile.exists()) {
      try {
        final map = jsonDecode(await checksumsFile.readAsString());
        if (map is Map) {
          for (final e in map.entries) {
            final path = e.key as String;
            final meta = e.value;
            if (meta is! Map) continue;
            final expected = meta['checksumSha256'] as String?;
            if (expected == null || expected.isEmpty) continue;
            final file = File(p.join(workDir.path, path));
            if (!await file.exists()) continue;
            final digest = sha256.convert(await file.readAsBytes()).toString();
            if (digest != expected) {
              throw RestoreFailure(
                message: 'Checksum mismatch for $path. Backup may be corrupt.',
              );
            }
          }
        }
      } catch (e) {
        if (e is RestoreFailure) rethrow;
        throw RestoreFailure(
          message: 'Could not validate backup checksums.',
          cause: e,
        );
      }
    }

    final dbSnap = File(p.join(workDir.path, 'database.sqlite'));
    if (!await dbSnap.exists()) {
      throw const RestoreFailure(message: 'Backup is missing database.sqlite.');
    }

    report(RestoreStage.preview, 0.55);
    return RestorePreview(
      manifest: manifest,
      sourcePath: backupFile.path,
      workDir: workDir,
    );
  }

  /// Applies a prepared restore: safety backup → replace files → reopen path.
  Future<RestoreResult> commit({
    required RestorePreview preview,
    String? safetyPassword,
    RestoreProgressCallback? onProgress,
  }) async {
    void report(RestoreStage stage, double fraction, [String? message]) {
      onProgress?.call(
        RestoreProgress(stage: stage, fraction: fraction, message: message),
      );
    }

    String? safetyPath;
    try {
      report(RestoreStage.safetyBackup, 0.6);
      if (safetyPassword != null && safetyPassword.length >= 8) {
        try {
          final safety = await backupService.createBackup(
            password: safetyPassword,
            confirmPassword: safetyPassword,
          );
          safetyPath = safety.absolutePath;
        } catch (error) {
          _logger.warn('Safety backup skipped', {
            'errorType': error.runtimeType.toString(),
          });
        }
      }

      report(RestoreStage.restoring, 0.75);
      await db.close();

      final support = await getApplicationSupportDirectory();
      final liveDb = File(p.join(support.path, 'shishur_dinlipi.sqlite'));
      final incomingDb = File(p.join(preview.workDir.path, 'database.sqlite'));
      if (await liveDb.exists()) {
        await liveDb.delete();
      }
      // Also clear WAL/SHM sidecars.
      for (final suffix in ['-wal', '-shm']) {
        final side = File('${liveDb.path}$suffix');
        if (await side.exists()) await side.delete();
      }
      await incomingDb.copy(liveDb.path);

      final fileRoot = await storage.ensureBootstrapped();
      for (final relative in [
        'media/images',
        'media/thumbnails',
        'media/documents',
      ]) {
        final src = Directory(p.join(preview.workDir.path, relative));
        if (!await src.exists()) continue;
        final destRoot = Directory(p.join(fileRoot.path, relative));
        await destRoot.create(recursive: true);
        await for (final entity in src.list(recursive: true, followLinks: false)) {
          if (entity is! File) continue;
          final rel = p.relative(entity.path, from: src.path);
          final dest = File(p.join(destRoot.path, rel));
          await dest.parent.create(recursive: true);
          await entity.copy(dest.path);
        }
      }

      report(RestoreStage.migrating, 0.88);
      // Re-open triggers Drift migrations automatically on next access.
      // Caller should recreate AppDatabase and override provider.

      report(RestoreStage.rebuilding, 0.95);
      try {
        await reminders?.rescheduleAll();
      } catch (_) {}

      report(RestoreStage.complete, 1.0);
      return RestoreResult(
        manifest: preview.manifest,
        safetyBackupPath: safetyPath,
      );
    } on AppFailure catch (e) {
      onProgress?.call(
        RestoreProgress(
          stage: RestoreStage.failed,
          fraction: 0,
          message: e.message,
          error: e,
        ),
      );
      rethrow;
    } catch (error, stackTrace) {
      _logger.error('Restore failed', error: error, stackTrace: stackTrace);
      final failure = RestoreFailure(
        message: 'Could not restore backup.',
        cause: error,
      );
      onProgress?.call(
        RestoreProgress(
          stage: RestoreStage.failed,
          fraction: 0,
          message: failure.message,
          error: failure,
        ),
      );
      throw failure;
    } finally {
      if (await preview.workDir.exists()) {
        await preview.workDir.delete(recursive: true);
      }
    }
  }
}
