import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/doctor_visit.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/doctor_visit_mapper.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class DoctorVisitsRepository implements Repository {
  Future<List<DoctorVisit>> forChild(String childId, {int? limit});
  Future<DoctorVisit?> latestForChild(String childId);
  Future<List<DoctorVisit>> upcomingFollowUps(String childId, {int? limit});
  Future<DoctorVisit?> getById(String id);
  Future<DoctorVisit> save({
    required DoctorVisit visit,
    List<AttachmentDraft> attachments = const [],
  });
  Future<void> softDelete(String id);
}

class DriftDoctorVisitsRepository extends RepositoryBase
    implements DoctorVisitsRepository {
  DriftDoctorVisitsRepository(super.db, {required this.attachments});

  final AttachmentRepository attachments;

  @override
  Future<List<DoctorVisit>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.doctorVisitsDao.forChild(childId, limit: limit);
      return rows.map(DoctorVisitMapper.toDomain).toList();
    }, operation: 'doctorVisits.forChild');
  }

  @override
  Future<DoctorVisit?> latestForChild(String childId) {
    return guard(() async {
      final row = await db.doctorVisitsDao.latestForChild(childId);
      return row == null ? null : DoctorVisitMapper.toDomain(row);
    }, operation: 'doctorVisits.latest');
  }

  @override
  Future<List<DoctorVisit>> upcomingFollowUps(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.doctorVisitsDao.upcomingFollowUps(
        childId,
        limit: limit,
      );
      return rows.map(DoctorVisitMapper.toDomain).toList();
    }, operation: 'doctorVisits.followUps');
  }

  @override
  Future<DoctorVisit?> getById(String id) {
    return guard(() async {
      final row = await db.doctorVisitsDao.getById(id);
      return row == null ? null : DoctorVisitMapper.toDomain(row);
    }, operation: 'doctorVisits.getById');
  }

  @override
  Future<DoctorVisit> save({
    required DoctorVisit visit,
    List<AttachmentDraft> attachments = const [],
  }) {
    return guard(() async {
      if (visit.doctorName.trim().isEmpty) {
        throw const ValidationFailure(message: 'Doctor name is required.');
      }
      final nowUtc = now();
      final id = visit.id.isEmpty ? ids.next() : visit.id;
      final existing = await db.doctorVisitsDao.getById(id);
      DateTime? dayOnly(DateTime? d) =>
          d == null ? null : DateTime(d.year, d.month, d.day);
      final visitDay = DateTime(
        visit.visitDate.year,
        visit.visitDate.month,
        visit.visitDate.day,
      );
      final toSave = visit.copyWith(
        id: id,
        doctorName: visit.doctorName.trim(),
        visitDate: visitDay,
        specialty: _trimOrNull(visit.specialty),
        clearSpecialty: _trimOrNull(visit.specialty) == null,
        hospitalOrChamber: _trimOrNull(visit.hospitalOrChamber),
        clearHospitalOrChamber: _trimOrNull(visit.hospitalOrChamber) == null,
        reason: _trimOrNull(visit.reason),
        clearReason: _trimOrNull(visit.reason) == null,
        symptoms: _trimOrNull(visit.symptoms),
        clearSymptoms: _trimOrNull(visit.symptoms) == null,
        diagnosis: _trimOrNull(visit.diagnosis),
        clearDiagnosis: _trimOrNull(visit.diagnosis) == null,
        testsAdvised: _trimOrNull(visit.testsAdvised),
        clearTestsAdvised: _trimOrNull(visit.testsAdvised) == null,
        followUpDate: dayOnly(visit.followUpDate),
        clearFollowUpDate: visit.followUpDate == null,
        notes: _trimOrNull(visit.notes),
        clearNotes: _trimOrNull(visit.notes) == null,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.doctorVisitsDao.upsert(DoctorVisitMapper.toCompanion(toSave));
        await this.attachments.syncForEntity(
          entityType: EntityTypes.doctorVisit,
          entityId: id,
          childId: toSave.childId,
          drafts: attachments,
        );
      });
      return toSave;
    }, operation: 'doctorVisits.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.runInTransaction(() async {
        await db.doctorVisitsDao.softDelete(id, now());
        await attachments.softDeleteForEntity(
          entityType: EntityTypes.doctorVisit,
          entityId: id,
        );
      });
    }, operation: 'doctorVisits.softDelete');
  }

  String? _trimOrNull(String? value) {
    final t = value?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }
}
