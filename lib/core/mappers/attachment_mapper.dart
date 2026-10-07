import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';

abstract final class AttachmentMapper {
  static Attachment toDomain(AttachmentRow row, {MediaAsset? media}) {
    return Attachment(
      id: row.id,
      mediaAssetId: row.mediaAssetId,
      entityType: row.entityType,
      entityId: row.entityId,
      sortOrder: row.sortOrder,
      caption: row.caption,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      media: media,
    );
  }

  static AttachmentsCompanion toCompanion(Attachment attachment) {
    return AttachmentsCompanion(
      id: Value(attachment.id),
      mediaAssetId: Value(attachment.mediaAssetId),
      entityType: Value(attachment.entityType),
      entityId: Value(attachment.entityId),
      sortOrder: Value(attachment.sortOrder),
      caption: Value(attachment.caption),
      createdAt: Value(attachment.createdAt),
      updatedAt: Value(attachment.updatedAt),
      deletedAt: Value(attachment.deletedAt),
    );
  }
}
