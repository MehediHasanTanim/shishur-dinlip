import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/vaccination_mapper.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class VaccinationsRepository implements Repository {
  Future<List<Vaccination>> forChild(
    String childId, {
    String? status,
    int? limit,
  });
  Future<List<Vaccination>> upcomingForChild(String childId, {int? limit});
  Future<Vaccination?> getById(String id);
  Future<Vaccination> save({
    required Vaccination vaccination,
    List<AttachmentDraft> attachments = const [],
  });
  Future<void> softDelete(String id);
}

class DriftVaccinationsRepository extends RepositoryBase
    implements VaccinationsRepository {
  DriftVaccinationsRepository(super.db, {required this.attachments});

  final AttachmentRepository attachments;

  @override
  Future<List<Vaccination>> forChild(
    String childId, {
    String? status,
    int? limit,
  }) {
    return guard(() async {
      final rows = await db.vaccinationsDao.forChild(
        childId,
        status: status,
        limit: limit,
      );
      return rows.map(VaccinationMapper.toDomain).toList();
    }, operation: 'vaccinations.forChild');
  }

  @override
  Future<List<Vaccination>> upcomingForChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.vaccinationsDao.upcomingForChild(
        childId,
        limit: limit,
      );
      return rows.map(VaccinationMapper.toDomain).toList();
    }, operation: 'vaccinations.upcoming');
  }

  @override
  Future<Vaccination?> getById(String id) {
    return guard(() async {
      final row = await db.vaccinationsDao.getById(id);
      return row == null ? null : VaccinationMapper.toDomain(row);
    }, operation: 'vaccinations.getById');
  }

  @override
  Future<Vaccination> save({
    required Vaccination vaccination,
    List<AttachmentDraft> attachments = const [],
  }) {
    return guard(() async {
      if (vaccination.vaccineName.trim().isEmpty) {
        throw const ValidationFailure(message: 'Vaccine name is required.');
      }
      if (!VaccinationStatuses.all.contains(vaccination.status)) {
        throw const ValidationFailure(message: 'Invalid vaccination status.');
      }
      final nowUtc = now();
      final id = vaccination.id.isEmpty ? ids.next() : vaccination.id;
      final existing = await db.vaccinationsDao.getById(id);
      DateTime? dayOnly(DateTime? d) =>
          d == null ? null : DateTime(d.year, d.month, d.day);
      final toSave = vaccination.copyWith(
        id: id,
        vaccineName: vaccination.vaccineName.trim(),
        doseLabel: _trimOrNull(vaccination.doseLabel),
        clearDoseLabel: _trimOrNull(vaccination.doseLabel) == null,
        scheduledDate: dayOnly(vaccination.scheduledDate),
        clearScheduledDate: vaccination.scheduledDate == null,
        givenDate: dayOnly(vaccination.givenDate),
        clearGivenDate: vaccination.givenDate == null,
        providerName: _trimOrNull(vaccination.providerName),
        clearProviderName: _trimOrNull(vaccination.providerName) == null,
        clinicName: _trimOrNull(vaccination.clinicName),
        clearClinicName: _trimOrNull(vaccination.clinicName) == null,
        batchNumber: _trimOrNull(vaccination.batchNumber),
        clearBatchNumber: _trimOrNull(vaccination.batchNumber) == null,
        notes: _trimOrNull(vaccination.notes),
        clearNotes: _trimOrNull(vaccination.notes) == null,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.vaccinationsDao.upsert(VaccinationMapper.toCompanion(toSave));
        await this.attachments.syncForEntity(
          entityType: EntityTypes.vaccination,
          entityId: id,
          childId: toSave.childId,
          drafts: attachments,
        );
      });
      return toSave;
    }, operation: 'vaccinations.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.runInTransaction(() async {
        await db.vaccinationsDao.softDelete(id, now());
        await attachments.softDeleteForEntity(
          entityType: EntityTypes.vaccination,
          entityId: id,
        );
      });
    }, operation: 'vaccinations.softDelete');
  }

  String? _trimOrNull(String? value) {
    final t = value?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }
}
