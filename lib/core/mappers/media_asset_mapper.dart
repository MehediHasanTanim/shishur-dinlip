import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';

abstract final class MediaAssetMapper {
  static MediaAsset toDomain(MediaAssetRow row) {
    return MediaAsset(
      id: row.id,
      childId: row.childId,
      assetType: _typeFromStorage(row.assetType),
      localPath: row.localPath,
      thumbnailPath: row.thumbnailPath,
      mimeType: row.mimeType,
      originalFilename: row.originalFilename,
      fileSizeBytes: row.fileSizeBytes,
      width: row.width,
      height: row.height,
      durationMs: row.durationMs,
      capturedAt: row.capturedAt,
      importedAt: row.importedAt,
      checksum: row.checksum,
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static MediaAssetsCompanion toCompanion(MediaAsset asset) {
    return MediaAssetsCompanion(
      id: Value(asset.id),
      childId: Value(asset.childId),
      assetType: Value(asset.assetType.name),
      localPath: Value(asset.localPath),
      thumbnailPath: Value(asset.thumbnailPath),
      mimeType: Value(asset.mimeType),
      originalFilename: Value(asset.originalFilename),
      fileSizeBytes: Value(asset.fileSizeBytes),
      width: Value(asset.width),
      height: Value(asset.height),
      durationMs: Value(asset.durationMs),
      capturedAt: Value(asset.capturedAt),
      importedAt: Value(asset.importedAt),
      checksum: Value(asset.checksum),
      isFavorite: Value(asset.isFavorite),
      createdAt: Value(asset.createdAt),
      updatedAt: Value(asset.updatedAt),
      deletedAt: Value(asset.deletedAt),
    );
  }

  static MediaAssetType _typeFromStorage(String value) {
    return MediaAssetType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => MediaAssetType.document,
    );
  }
}
