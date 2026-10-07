import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/school_event.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/school_event_mapper.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class SchoolEventsRepository implements Repository {
  Future<List<SchoolEvent>> forChild(
    String childId, {
    String? eventType,
    String? schoolProfileId,
    int? limit,
  });
  Future<List<SchoolEvent>> upcomingForChild(String childId, {int? limit});
  Future<SchoolEvent?> getById(String id);
  Future<SchoolEvent> save({
    required SchoolEvent event,
    List<AttachmentDraft> attachments = const [],
  });
  Future<void> softDelete(String id);
}

class DriftSchoolEventsRepository extends RepositoryBase
    implements SchoolEventsRepository {
  DriftSchoolEventsRepository(super.db, {required this.attachments});

  final AttachmentRepository attachments;

  @override
  Future<List<SchoolEvent>> forChild(
    String childId, {
    String? eventType,
    String? schoolProfileId,
    int? limit,
  }) {
    return guard(() async {
      final rows = await db.schoolEventsDao.forChild(
        childId,
        eventType: eventType,
        schoolProfileId: schoolProfileId,
        limit: limit,
      );
      return rows.map(SchoolEventMapper.toDomain).toList();
    }, operation: 'schoolEvents.forChild');
  }

  @override
  Future<List<SchoolEvent>> upcomingForChild(String childId, {int? limit}) {
    return guard(() async {
      final today = DateTime.now();
      final from = DateTime(today.year, today.month, today.day);
      final rows = await db.schoolEventsDao.upcomingForChild(
        childId,
        from: from,
        limit: limit,
      );
      return rows.map(SchoolEventMapper.toDomain).toList();
    }, operation: 'schoolEvents.upcoming');
  }

  @override
  Future<SchoolEvent?> getById(String id) {
    return guard(() async {
      final row = await db.schoolEventsDao.getById(id);
      return row == null ? null : SchoolEventMapper.toDomain(row);
    }, operation: 'schoolEvents.getById');
  }

  @override
  Future<SchoolEvent> save({
    required SchoolEvent event,
    List<AttachmentDraft> attachments = const [],
  }) {
    return guard(() async {
      if (event.title.trim().isEmpty) {
        throw const ValidationFailure(message: 'Event title is required.');
      }
      final nowUtc = now();
      final id = event.id.isEmpty ? ids.next() : event.id;
      final existing = await db.schoolEventsDao.getById(id);
      final measured = DateTime(
        event.eventDate.year,
        event.eventDate.month,
        event.eventDate.day,
      );
      final toSave = event.copyWith(
        id: id,
        title: event.title.trim(),
        eventDate: measured,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.schoolEventsDao.upsert(SchoolEventMapper.toCompanion(toSave));
        await this.attachments.syncForEntity(
          entityType: EntityTypes.schoolEvent,
          entityId: id,
          childId: toSave.childId,
          drafts: attachments,
        );
      });
      return toSave;
    }, operation: 'schoolEvents.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.runInTransaction(() async {
        await db.schoolEventsDao.softDelete(id, now());
        await attachments.softDeleteForEntity(
          entityType: EntityTypes.schoolEvent,
          entityId: id,
        );
      });
    }, operation: 'schoolEvents.softDelete');
  }
}
