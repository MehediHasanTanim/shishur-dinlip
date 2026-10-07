import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/achievement.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/mappers/achievement_mapper.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class AchievementsRepository implements Repository {
  Future<List<Achievement>> forChild(String childId, {int? limit});
  Future<Achievement?> getById(String id);
  Future<Achievement> save({
    required Achievement achievement,
    required List<AttachmentDraft> attachments,
  });
  Future<void> softDelete(String id);
  Future<void> setFavorite(String id, bool isFavorite);
}

class DriftAchievementsRepository extends RepositoryBase
    implements AchievementsRepository {
  DriftAchievementsRepository(super.db, {required this.attachments});

  final AttachmentRepository attachments;

  @override
  Future<List<Achievement>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.achievementsDao.forChild(childId, limit: limit);
      return rows.map(AchievementMapper.toDomain).toList();
    }, operation: 'achievements.forChild');
  }

  @override
  Future<Achievement?> getById(String id) {
    return guard(() async {
      final row = await db.achievementsDao.getById(id);
      return row == null ? null : AchievementMapper.toDomain(row);
    }, operation: 'achievements.getById');
  }

  @override
  Future<Achievement> save({
    required Achievement achievement,
    required List<AttachmentDraft> attachments,
  }) {
    return guard(() async {
      final nowUtc = now();
      final id = achievement.id.isEmpty ? ids.next() : achievement.id;
      final existing = await db.achievementsDao.getById(id);
      final toSave = achievement.copyWith(
        id: id,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.achievementsDao.upsert(AchievementMapper.toCompanion(toSave));
        await this.attachments.syncForEntity(
          entityType: EntityTypes.achievement,
          entityId: id,
          childId: toSave.childId,
          drafts: attachments,
        );
      });

      return toSave;
    }, operation: 'achievements.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.runInTransaction(() async {
        await db.achievementsDao.softDelete(id, now());
        await attachments.softDeleteForEntity(
          entityType: EntityTypes.achievement,
          entityId: id,
        );
      });
    }, operation: 'achievements.softDelete');
  }

  @override
  Future<void> setFavorite(String id, bool isFavorite) {
    return guard(() async {
      await db.achievementsDao.setFavorite(id, isFavorite, now());
    }, operation: 'achievements.setFavorite');
  }
}
