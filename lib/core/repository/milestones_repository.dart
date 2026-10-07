import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/milestone.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/milestone_mapper.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class MilestonesRepository implements Repository {
  Future<List<Milestone>> forChild(
    String childId, {
    String? category,
    int? limit,
  });
  Future<Milestone?> getById(String id);
  Future<Milestone> save({
    required Milestone milestone,
    List<AttachmentDraft> attachments = const [],
  });
  Future<void> softDelete(String id);
}

class DriftMilestonesRepository extends RepositoryBase
    implements MilestonesRepository {
  DriftMilestonesRepository(super.db, {required this.attachments});

  final AttachmentRepository attachments;

  @override
  Future<List<Milestone>> forChild(
    String childId, {
    String? category,
    int? limit,
  }) {
    return guard(() async {
      final rows = await db.milestonesDao.forChild(
        childId,
        category: category,
        limit: limit,
      );
      return rows.map(MilestoneMapper.toDomain).toList();
    }, operation: 'milestones.forChild');
  }

  @override
  Future<Milestone?> getById(String id) {
    return guard(() async {
      final row = await db.milestonesDao.getById(id);
      return row == null ? null : MilestoneMapper.toDomain(row);
    }, operation: 'milestones.getById');
  }

  @override
  Future<Milestone> save({
    required Milestone milestone,
    List<AttachmentDraft> attachments = const [],
  }) {
    return guard(() async {
      if (milestone.title.trim().isEmpty) {
        throw const ValidationFailure(message: 'Milestone title is required.');
      }
      final nowUtc = now();
      final id = milestone.id.isEmpty ? ids.next() : milestone.id;
      final existing = await db.milestonesDao.getById(id);
      final normalizedDate = milestone.datePrecision.normalize(
        milestone.eventDate,
      );
      final toSave = milestone.copyWith(
        id: id,
        title: milestone.title.trim(),
        eventDate: normalizedDate,
        clearEventDate: normalizedDate == null,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.milestonesDao.upsert(MilestoneMapper.toCompanion(toSave));
        await this.attachments.syncForEntity(
          entityType: EntityTypes.milestone,
          entityId: id,
          childId: toSave.childId,
          drafts: attachments,
        );
      });
      return toSave;
    }, operation: 'milestones.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.runInTransaction(() async {
        await db.milestonesDao.softDelete(id, now());
        await attachments.softDeleteForEntity(
          entityType: EntityTypes.milestone,
          entityId: id,
        );
      });
    }, operation: 'milestones.softDelete');
  }
}
