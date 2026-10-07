import 'dart:io';

import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/mappers/attachment_mapper.dart';
import 'package:shishur_dinlipi/core/mappers/media_asset_mapper.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class AttachmentRepository implements Repository {
  Future<List<Attachment>> forEntity({
    required String entityType,
    required String entityId,
  });

  Future<void> syncForEntity({
    required String entityType,
    required String entityId,
    required String? childId,
    required List<AttachmentDraft> drafts,
  });

  Future<void> softDeleteForEntity({
    required String entityType,
    required String entityId,
  });
}

class DriftAttachmentRepository extends RepositoryBase
    implements AttachmentRepository {
  DriftAttachmentRepository(
    super.db, {
    required this.mediaService,
    required this.storage,
  });

  final MediaService mediaService;
  final FileStorageService storage;

  @override
  Future<List<Attachment>> forEntity({
    required String entityType,
    required String entityId,
  }) {
    return guard(() async {
      final rows = await db.attachmentsDao.forEntity(
        entityType: entityType,
        entityId: entityId,
      );
      final result = <Attachment>[];
      for (final row in rows) {
        final mediaRow = await db.mediaAssetsDao.getById(row.mediaAssetId);
        final media = mediaRow == null
            ? null
            : MediaAssetMapper.toDomain(mediaRow);
        result.add(AttachmentMapper.toDomain(row, media: media));
      }
      return result;
    }, operation: 'attachments.forEntity');
  }

  @override
  Future<void> syncForEntity({
    required String entityType,
    required String entityId,
    required String? childId,
    required List<AttachmentDraft> drafts,
  }) {
    return guard(() async {
      final existing = await db.attachmentsDao.forEntity(
        entityType: entityType,
        entityId: entityId,
      );
      final keepIds = <String>{};
      final nowUtc = now();

      for (var i = 0; i < drafts.length; i++) {
        final draft = drafts[i];
        String mediaId = draft.mediaAssetId ?? '';

        if (draft.pendingPath != null) {
          final imported = await mediaService.importImage(
            sourceFile: File(draft.pendingPath!),
            childId: childId,
          );
          mediaId = imported.id;
        }

        if (mediaId.isEmpty) continue;

        final attachmentId = draft.attachmentId ?? ids.next();
        keepIds.add(attachmentId);
        DateTime? existingCreated;
        for (final row in existing) {
          if (row.id == attachmentId) {
            existingCreated = row.createdAt;
            break;
          }
        }

        await db.attachmentsDao.upsert(
          AttachmentMapper.toCompanion(
            Attachment(
              id: attachmentId,
              mediaAssetId: mediaId,
              entityType: entityType,
              entityId: entityId,
              sortOrder: i,
              caption: draft.caption,
              createdAt: existingCreated ?? nowUtc,
              updatedAt: nowUtc,
            ),
          ),
        );
      }

      for (final row in existing) {
        if (!keepIds.contains(row.id)) {
          await db.attachmentsDao.softDelete(row.id, nowUtc);
          await mediaService.deleteUnusedMediaSafely(row.mediaAssetId);
        }
      }
    }, operation: 'attachments.sync');
  }

  @override
  Future<void> softDeleteForEntity({
    required String entityType,
    required String entityId,
  }) {
    return guard(() async {
      final rows = await db.attachmentsDao.forEntity(
        entityType: entityType,
        entityId: entityId,
      );
      final deletedAt = now();
      await db.attachmentsDao.softDeleteForEntity(
        entityType: entityType,
        entityId: entityId,
        deletedAt: deletedAt,
      );
      for (final row in rows) {
        await mediaService.deleteUnusedMediaSafely(row.mediaAssetId);
      }
    }, operation: 'attachments.softDeleteForEntity');
  }
}
