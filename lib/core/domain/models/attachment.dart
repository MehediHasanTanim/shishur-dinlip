import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';

@immutable
class Attachment {
  const Attachment({
    required this.id,
    required this.mediaAssetId,
    required this.entityType,
    required this.entityId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.caption,
    this.deletedAt,
    this.media,
  });

  final String id;
  final String mediaAssetId;
  final String entityType;
  final String entityId;
  final int sortOrder;
  final String? caption;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final MediaAsset? media;

  Attachment copyWith({
    String? id,
    String? mediaAssetId,
    String? entityType,
    String? entityId,
    int? sortOrder,
    String? caption,
    bool clearCaption = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    MediaAsset? media,
  }) {
    return Attachment(
      id: id ?? this.id,
      mediaAssetId: mediaAssetId ?? this.mediaAssetId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      sortOrder: sortOrder ?? this.sortOrder,
      caption: clearCaption ? null : (caption ?? this.caption),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      media: media ?? this.media,
    );
  }
}

/// In-editor attachment draft (persisted on save).
@immutable
class AttachmentDraft {
  const AttachmentDraft({
    required this.localKey,
    this.attachmentId,
    this.mediaAssetId,
    this.pendingPath,
    this.caption,
    this.displayName,
    this.isDocument = false,
  });

  final String localKey;
  final String? attachmentId;
  final String? mediaAssetId;
  final String? pendingPath;
  final String? caption;
  final String? displayName;
  final bool isDocument;

  bool get isPersisted => mediaAssetId != null;
}
