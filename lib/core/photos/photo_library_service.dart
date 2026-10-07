import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';
import 'package:shishur_dinlipi/core/domain/models/photo_library_item.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/mappers/media_asset_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

class PhotoLibraryService extends RepositoryBase {
  PhotoLibraryService(super.db, {required this.storage});

  final FileStorageService storage;

  Future<List<PhotoLibraryItem>> photosForChild(
    String childId, {
    bool favoritesOnly = false,
  }) {
    return guard(() async {
      final rows = favoritesOnly
          ? await db.mediaAssetsDao.favoritesForChild(childId)
          : await db.mediaAssetsDao.imagesForChild(childId);
      final items = <PhotoLibraryItem>[];
      for (final row in rows) {
        final media = MediaAssetMapper.toDomain(row);
        if (media.assetType != MediaAssetType.image) continue;
        final link = await _primaryLink(media.id);
        final missing = await _isMissing(media);
        items.add(
          PhotoLibraryItem(
            media: media,
            displayDate: media.capturedAt ?? media.importedAt,
            linkedEntityType: link?.$1,
            linkedEntityId: link?.$2,
            categoryKey: _categoryFor(link?.$1),
            fileMissing: missing,
          ),
        );
      }
      items.sort((a, b) => b.displayDate.compareTo(a.displayDate));
      return items;
    }, operation: 'photos.forChild');
  }

  Future<Map<String, List<PhotoLibraryItem>>> group({
    required String childId,
    required PhotoLibraryGroupBy groupBy,
    DateTime? dateOfBirth,
  }) async {
    final all = await photosForChild(
      childId,
      favoritesOnly: groupBy == PhotoLibraryGroupBy.favorites,
    );
    if (groupBy == PhotoLibraryGroupBy.all ||
        groupBy == PhotoLibraryGroupBy.favorites) {
      return {'all': all};
    }

    final map = <String, List<PhotoLibraryItem>>{};
    for (final item in all) {
      final key = switch (groupBy) {
        PhotoLibraryGroupBy.year => '${item.displayDate.year}',
        PhotoLibraryGroupBy.age => dateOfBirth == null
            ? 'unknown'
            : _ageKey(dateOfBirth, item.displayDate),
        PhotoLibraryGroupBy.category => item.categoryKey,
        _ => 'all',
      };
      map.putIfAbsent(key, () => []).add(item);
    }
    final keys = map.keys.toList()
      ..sort((a, b) {
        final ai = int.tryParse(a);
        final bi = int.tryParse(b);
        if (ai != null && bi != null) return bi.compareTo(ai);
        return a.compareTo(b);
      });
    return {for (final k in keys) k: map[k]!};
  }

  Future<MediaAsset> setFavorite(String mediaId, bool favorite) {
    return guard(() async {
      final row = await db.mediaAssetsDao.getById(mediaId);
      if (row == null) {
        throw const FileFailure(message: 'Photo not found.');
      }
      final updated = MediaAssetMapper.toDomain(row);
      final nowUtc = now();
      await db.mediaAssetsDao.setFavorite(mediaId, favorite, nowUtc);
      return MediaAsset(
        id: updated.id,
        childId: updated.childId,
        assetType: updated.assetType,
        localPath: updated.localPath,
        thumbnailPath: updated.thumbnailPath,
        mimeType: updated.mimeType,
        originalFilename: updated.originalFilename,
        fileSizeBytes: updated.fileSizeBytes,
        width: updated.width,
        height: updated.height,
        durationMs: updated.durationMs,
        capturedAt: updated.capturedAt,
        importedAt: updated.importedAt,
        checksum: updated.checksum,
        isFavorite: favorite,
        createdAt: updated.createdAt,
        updatedAt: nowUtc,
        deletedAt: updated.deletedAt,
      );
    }, operation: 'photos.setFavorite');
  }

  Future<(String, String)?> _primaryLink(String mediaId) async {
    final attachments = await db.customSelect(
      '''
      SELECT entity_type, entity_id FROM attachments
      WHERE media_asset_id = ? AND deleted_at IS NULL
      ORDER BY sort_order ASC LIMIT 1
      ''',
      variables: [Variable.withString(mediaId)],
      readsFrom: {db.attachments},
    ).get();
    if (attachments.isEmpty) return null;
    final row = attachments.first.data;
    return (row['entity_type'] as String, row['entity_id'] as String);
  }

  Future<bool> _isMissing(MediaAsset media) async {
    try {
      final file = await storage.absoluteFile(media.localPath);
      return !await file.exists();
    } catch (_) {
      return true;
    }
  }

  String _categoryFor(String? entityType) {
    return switch (entityType) {
      'journal_entry' => 'memories',
      'funny_moment' => 'funny',
      'achievement' => 'achievements',
      'milestone' => 'milestones',
      'school_event' || 'school_profile' => 'school',
      'vaccination' ||
      'illness_episode' ||
      'doctor_visit' ||
      'medical_document' => 'health',
      'growth_record' => 'growth',
      _ => 'other',
    };
  }

  String _ageKey(DateTime dob, DateTime at) {
    final age = AgeCalculator.atEvent(dateOfBirth: dob, eventDate: at);
    return '${age.years}';
  }
}
