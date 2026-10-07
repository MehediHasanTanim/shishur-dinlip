import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/funny_moment.dart';
import 'package:shishur_dinlipi/core/mappers/funny_moment_mapper.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class FunnyMomentsRepository implements Repository {
  Future<List<FunnyMoment>> forChild(String childId, {int? limit});
  Future<FunnyMoment?> getById(String id);
  Future<FunnyMoment> save({
    required FunnyMoment moment,
    required List<AttachmentDraft> attachments,
  });
  Future<void> softDelete(String id);
  Future<void> setFavorite(String id, bool isFavorite);
}

class DriftFunnyMomentsRepository extends RepositoryBase
    implements FunnyMomentsRepository {
  DriftFunnyMomentsRepository(super.db, {required this.attachments});

  final AttachmentRepository attachments;

  @override
  Future<List<FunnyMoment>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.funnyMomentsDao.forChild(childId, limit: limit);
      return rows.map(FunnyMomentMapper.toDomain).toList();
    }, operation: 'funny.forChild');
  }

  @override
  Future<FunnyMoment?> getById(String id) {
    return guard(() async {
      final row = await db.funnyMomentsDao.getById(id);
      return row == null ? null : FunnyMomentMapper.toDomain(row);
    }, operation: 'funny.getById');
  }

  @override
  Future<FunnyMoment> save({
    required FunnyMoment moment,
    required List<AttachmentDraft> attachments,
  }) {
    return guard(() async {
      final nowUtc = now();
      final id = moment.id.isEmpty ? ids.next() : moment.id;
      final existing = await db.funnyMomentsDao.getById(id);
      final toSave = moment.copyWith(
        id: id,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.funnyMomentsDao.upsert(FunnyMomentMapper.toCompanion(toSave));
        await this.attachments.syncForEntity(
          entityType: EntityTypes.funnyMoment,
          entityId: id,
          childId: toSave.childId,
          drafts: attachments,
        );
      });

      return toSave;
    }, operation: 'funny.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.runInTransaction(() async {
        await db.funnyMomentsDao.softDelete(id, now());
        await attachments.softDeleteForEntity(
          entityType: EntityTypes.funnyMoment,
          entityId: id,
        );
      });
    }, operation: 'funny.softDelete');
  }

  @override
  Future<void> setFavorite(String id, bool isFavorite) {
    return guard(() async {
      await db.funnyMomentsDao.setFavorite(id, isFavorite, now());
    }, operation: 'funny.setFavorite');
  }
}
