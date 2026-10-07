import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/mappers/media_asset_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

class MediaService extends RepositoryBase {
  MediaService(
    super.db, {
    required this.storage,
    super.ids,
    super.logger,
  });

  final FileStorageService storage;

  static const _thumbnailMaxEdge = 512;

  /// Imports an image into app-private storage and creates a [MediaAsset] row.
  Future<MediaAsset> importImage({
    required File sourceFile,
    String? childId,
    String? originalFilename,
    DateTime? capturedAt,
  }) {
    return guard(() async {
      if (!await sourceFile.exists()) {
        throw const FileFailure(message: 'Source image file was not found.');
      }

      await storage.ensureBootstrapped();
      final bytes = await sourceFile.readAsBytes();
      if (bytes.isEmpty) {
        throw const FileFailure(message: 'Source image file is empty.');
      }

      img.Image? decoded;
      try {
        decoded = img.decodeImage(bytes);
      } catch (_) {
        decoded = null;
      }
      if (decoded == null) {
        throw const FileFailure(message: 'Could not decode the image file.');
      }

      final checksum = sha256.convert(bytes).toString();
      final fileName = storage.buildFileName(
        originalName: originalFilename ?? p.basename(sourceFile.path),
      );
      final imagesDir = await storage.imagesDir();
      final saved = await storage.writeBytesAtomic(
        directory: imagesDir,
        fileName: fileName,
        bytes: bytes,
      );

      String? thumbnailRelative;
      try {
        final thumbBytes = _encodeThumbnail(decoded);
        final thumbName = storage.buildFileName(preferredExtension: '.jpg');
        final thumbsDir = await storage.thumbnailsDir();
        final thumbFile = await storage.writeBytesAtomic(
          directory: thumbsDir,
          fileName: thumbName,
          bytes: thumbBytes,
        );
        thumbnailRelative = storage.toRelativePath(thumbFile.path);
      } catch (error, stackTrace) {
        logger.warn('Thumbnail generation failed', {
          'errorType': error.runtimeType.toString(),
        });
        logger.error(
          'Thumbnail generation error detail',
          error: error,
          stackTrace: stackTrace,
        );
      }

      final nowUtc = now();
      final asset = MediaAsset(
        id: ids.next(),
        childId: childId,
        assetType: MediaAssetType.image,
        localPath: storage.toRelativePath(saved.path),
        thumbnailPath: thumbnailRelative,
        mimeType: _mimeForExtension(p.extension(fileName)),
        originalFilename: originalFilename ?? p.basename(sourceFile.path),
        fileSizeBytes: bytes.length,
        width: decoded.width,
        height: decoded.height,
        capturedAt: capturedAt,
        importedAt: nowUtc,
        checksum: checksum,
        createdAt: nowUtc,
        updatedAt: nowUtc,
      );

      await db.mediaAssetsDao.upsert(MediaAssetMapper.toCompanion(asset));
      logger.info('Media imported', {
        'mediaId': asset.id,
        'bytes': asset.fileSizeBytes,
        'width': asset.width,
        'height': asset.height,
      });
      return asset;
    }, operation: 'media.importImage');
  }

  /// Imports a PDF/document into app-private document storage.
  Future<MediaAsset> importDocument({
    required File sourceFile,
    String? childId,
    String? originalFilename,
  }) {
    return guard(() async {
      if (!await sourceFile.exists()) {
        throw const FileFailure(message: 'Source document was not found.');
      }
      await storage.ensureBootstrapped();
      final bytes = await sourceFile.readAsBytes();
      if (bytes.isEmpty) {
        throw const FileFailure(message: 'Source document is empty.');
      }

      final checksum = sha256.convert(bytes).toString();
      final name = originalFilename ?? p.basename(sourceFile.path);
      final fileName = storage.buildFileName(originalName: name);
      final docsDir = await storage.documentsDir();
      final saved = await storage.writeBytesAtomic(
        directory: docsDir,
        fileName: fileName,
        bytes: bytes,
      );

      final ext = p.extension(name).toLowerCase();
      final isPdf = ext == '.pdf';
      final nowUtc = now();
      final asset = MediaAsset(
        id: ids.next(),
        childId: childId,
        assetType: isPdf ? MediaAssetType.pdf : MediaAssetType.document,
        localPath: storage.toRelativePath(saved.path),
        mimeType: isPdf ? 'application/pdf' : 'application/octet-stream',
        originalFilename: name,
        fileSizeBytes: bytes.length,
        importedAt: nowUtc,
        checksum: checksum,
        createdAt: nowUtc,
        updatedAt: nowUtc,
      );

      await db.mediaAssetsDao.upsert(MediaAssetMapper.toCompanion(asset));
      logger.info('Document imported', {
        'mediaId': asset.id,
        'bytes': asset.fileSizeBytes,
        'type': asset.assetType.name,
      });
      return asset;
    }, operation: 'media.importDocument');
  }

  /// Soft-deletes media and removes files only when no attachments remain.
  Future<void> deleteUnusedMediaSafely(String mediaAssetId) {
    return guard(() async {
      final refs = await db.mediaAssetsDao.countActiveAttachments(mediaAssetId);
      if (refs > 0) {
        logger.info('Skip media delete; still referenced', {
          'mediaId': mediaAssetId,
          'refs': refs,
        });
        return;
      }

      final row = await db.mediaAssetsDao.getById(mediaAssetId);
      if (row == null) return;

      await db.mediaAssetsDao.softDelete(mediaAssetId, now());
      await storage.deleteIfExists(row.localPath);
      await storage.deleteIfExists(row.thumbnailPath);
      logger.info('Unused media deleted', {'mediaId': mediaAssetId});
    }, operation: 'media.deleteUnused');
  }

  Future<MediaAsset?> getById(String id) {
    return guard(() async {
      final row = await db.mediaAssetsDao.getById(id);
      return row == null ? null : MediaAssetMapper.toDomain(row);
    }, operation: 'media.getById');
  }

  Future<String> checksumForFile(File file) async {
    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  Uint8List _encodeThumbnail(img.Image source) {
    final resized = img.copyResize(
      source,
      width: source.width >= source.height ? _thumbnailMaxEdge : null,
      height: source.height > source.width ? _thumbnailMaxEdge : null,
      interpolation: img.Interpolation.average,
    );
    return Uint8List.fromList(img.encodeJpg(resized, quality: 82));
  }

  String _mimeForExtension(String extension) {
    switch (extension.toLowerCase()) {
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.gif':
        return 'image/gif';
      case '.heic':
      case '.heif':
        return 'image/heic';
      case '.jpg':
      case '.jpeg':
      default:
        return 'image/jpeg';
    }
  }
}
