import 'package:flutter/foundation.dart';

enum MediaAssetType { image, video, audio, pdf, document }

@immutable
class MediaAsset {
  const MediaAsset({
    required this.id,
    required this.assetType,
    required this.localPath,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.importedAt,
    required this.createdAt,
    required this.updatedAt,
    this.childId,
    this.thumbnailPath,
    this.originalFilename,
    this.width,
    this.height,
    this.durationMs,
    this.capturedAt,
    this.checksum,
    this.isFavorite = false,
    this.deletedAt,
  });

  final String id;
  final String? childId;
  final MediaAssetType assetType;
  final String localPath;
  final String? thumbnailPath;
  final String mimeType;
  final String? originalFilename;
  final int fileSizeBytes;
  final int? width;
  final int? height;
  final int? durationMs;
  final DateTime? capturedAt;
  final DateTime importedAt;
  final String? checksum;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
