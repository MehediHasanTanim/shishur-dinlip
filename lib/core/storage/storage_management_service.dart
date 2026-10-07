import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';

class StorageCategoryUsage {
  const StorageCategoryUsage({
    required this.key,
    required this.bytes,
    required this.fileCount,
  });

  final String key;
  final int bytes;
  final int fileCount;
}

class StorageUsageSummary {
  const StorageUsageSummary({
    required this.categories,
    required this.totalBytes,
    required this.orphanCount,
    required this.exportCount,
    required this.tempBytes,
  });

  final List<StorageCategoryUsage> categories;
  final int totalBytes;
  final int orphanCount;
  final int exportCount;
  final int tempBytes;

  bool get isAlmostFull => totalBytes > 800 * 1024 * 1024; // ~800 MB soft warn
}

class OrphanMediaItem {
  const OrphanMediaItem({
    required this.mediaId,
    required this.relativePath,
    required this.reason,
  });

  final String mediaId;
  final String relativePath;
  final String reason;
}

class StorageManagementService {
  StorageManagementService({
    required this.db,
    required this.storage,
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger.instance;

  final AppDatabase db;
  final FileStorageService storage;
  final AppLogger _logger;

  Future<StorageUsageSummary> summarize() async {
    final root = await storage.ensureBootstrapped();
    final categories = <StorageCategoryUsage>[];
    var total = 0;

    for (final key in [
      'media/images',
      'media/thumbnails',
      'media/documents',
      'exports/pdf',
      'exports/album_images',
      'backups',
      'temp',
    ]) {
      final usage = await _dirUsage(Directory(p.join(root.path, key)));
      categories.add(
        StorageCategoryUsage(
          key: key,
          bytes: usage.$1,
          fileCount: usage.$2,
        ),
      );
      total += usage.$1;
    }

    final support = await getApplicationSupportDirectory();
    final dbFile = File(p.join(support.path, 'shishur_dinlipi.sqlite'));
    var dbBytes = 0;
    if (await dbFile.exists()) {
      dbBytes = await dbFile.length();
      total += dbBytes;
    }
    categories.insert(
      0,
      StorageCategoryUsage(key: 'database', bytes: dbBytes, fileCount: 1),
    );

    final orphans = await findOrphanMedia();
    final exportCountRow = await db.customSelect(
      'SELECT COUNT(*) AS c FROM generated_exports WHERE deleted_at IS NULL',
    ).getSingle();
    final exportCount = exportCountRow.data['c'] as int? ?? 0;
    final temp = categories.firstWhere((c) => c.key == 'temp');

    return StorageUsageSummary(
      categories: categories,
      totalBytes: total,
      orphanCount: orphans.length,
      exportCount: exportCount,
      tempBytes: temp.bytes,
    );
  }

  Future<List<OrphanMediaItem>> findOrphanMedia() async {
    final rows = await db.customSelect(
      '''
      SELECT m.id, m.local_path, m.thumbnail_path
      FROM media_assets m
      WHERE m.deleted_at IS NULL
        AND NOT EXISTS (
          SELECT 1 FROM attachments a
          WHERE a.media_asset_id = m.id AND a.deleted_at IS NULL
        )
        AND (m.child_id IS NULL OR m.child_id = '')
      ''',
    ).get();

    final orphans = <OrphanMediaItem>[];
    for (final row in rows) {
      orphans.add(
        OrphanMediaItem(
          mediaId: row.data['id'] as String,
          relativePath: row.data['local_path'] as String? ?? '',
          reason: 'unlinked',
        ),
      );
    }

    // Also flag DB rows whose files are missing.
    final allMedia = await db.customSelect(
      'SELECT id, local_path, thumbnail_path FROM media_assets WHERE deleted_at IS NULL',
    ).get();
    for (final row in allMedia) {
      final id = row.data['id'] as String;
      final path = row.data['local_path'] as String? ?? '';
      if (path.isEmpty) continue;
      final file = await storage.absoluteFile(path);
      if (!await file.exists()) {
        orphans.add(
          OrphanMediaItem(
            mediaId: id,
            relativePath: path,
            reason: 'missing_file',
          ),
        );
      }
    }
    return orphans;
  }

  Future<int> cleanupTemp({Duration maxAge = const Duration(hours: 1)}) async {
    await storage.cleanupTemp(maxAge: maxAge);
    final root = await storage.ensureBootstrapped();
    final temp = Directory(p.join(root.path, 'temp'));
    final usage = await _dirUsage(temp);
    _logger.info('Temp cleanup requested', {'remainingBytes': usage.$1});
    return usage.$1;
  }

  Future<int> cleanupOrphanMedia() async {
    final orphans = await findOrphanMedia();
    var removed = 0;
    final now = DateTime.now().toUtc();
    final seen = <String>{};
    for (final orphan in orphans) {
      if (!seen.add(orphan.mediaId)) continue;
      final row = await db.customSelect(
        'SELECT local_path, thumbnail_path FROM media_assets WHERE id = ?',
        variables: [Variable.withString(orphan.mediaId)],
      ).getSingleOrNull();
      if (row != null) {
        await storage.deleteIfExists(row.data['local_path'] as String?);
        await storage.deleteIfExists(row.data['thumbnail_path'] as String?);
      }
      await db.mediaAssetsDao.softDelete(orphan.mediaId, now);
      removed++;
    }
    _logger.info('Orphan media cleanup', {'removed': removed});
    return removed;
  }

  Future<int> cleanupGeneratedExports({int keepNewest = 5}) async {
    final rows = await db.customSelect(
      '''
      SELECT id, file_path FROM generated_exports
      WHERE deleted_at IS NULL
      ORDER BY created_at DESC
      ''',
    ).get();
    if (rows.length <= keepNewest) return 0;
    final toRemove = rows.skip(keepNewest);
    var removed = 0;
    final now = DateTime.now().toUtc();
    for (final row in toRemove) {
      final id = row.data['id'] as String;
      final path = row.data['file_path'] as String?;
      await storage.deleteIfExists(path);
      await db.generatedExportsDao.softDelete(id, now);
      removed++;
    }
    _logger.info('Export cleanup complete', {'removed': removed});
    return removed;
  }

  Future<(int, int)> _dirUsage(Directory dir) async {
    if (!await dir.exists()) return (0, 0);
    var bytes = 0;
    var count = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      try {
        bytes += await entity.length();
        count++;
      } catch (_) {}
    }
    return (bytes, count);
  }
}
