import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/medicine_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class MedicinesRepository implements Repository {
  Future<List<Medicine>> forChild(
    String childId, {
    String? status,
    String? illnessId,
    int? limit,
  });
  Future<List<Medicine>> activeForChild(String childId);
  Future<Medicine?> getById(String id);
  Future<Medicine> save(Medicine medicine);
  Future<void> softDelete(String id);
}

class DriftMedicinesRepository extends RepositoryBase
    implements MedicinesRepository {
  DriftMedicinesRepository(super.db);

  @override
  Future<List<Medicine>> forChild(
    String childId, {
    String? status,
    String? illnessId,
    int? limit,
  }) {
    return guard(() async {
      final rows = await db.medicinesDao.forChild(
        childId,
        status: status,
        illnessId: illnessId,
        limit: limit,
      );
      final result = <Medicine>[];
      for (final row in rows) {
        final schedules = await db.medicineSchedulesDao.forMedicine(row.id);
        result.add(
          MedicineMapper.toDomain(
            row,
            schedules: schedules.map(MedicineMapper.scheduleToDomain).toList(),
          ),
        );
      }
      return result;
    }, operation: 'medicines.forChild');
  }

  @override
  Future<List<Medicine>> activeForChild(String childId) {
    return forChild(childId, status: MedicineStatuses.active);
  }

  @override
  Future<Medicine?> getById(String id) {
    return guard(() async {
      final row = await db.medicinesDao.getById(id);
      if (row == null) return null;
      final schedules = await db.medicineSchedulesDao.forMedicine(id);
      return MedicineMapper.toDomain(
        row,
        schedules: schedules.map(MedicineMapper.scheduleToDomain).toList(),
      );
    }, operation: 'medicines.getById');
  }

  @override
  Future<Medicine> save(Medicine medicine) {
    return guard(() async {
      if (medicine.name.trim().isEmpty) {
        throw const ValidationFailure(message: 'Medicine name is required.');
      }
      if (!MedicineStatuses.all.contains(medicine.status)) {
        throw const ValidationFailure(message: 'Invalid medicine status.');
      }
      if (medicine.endDate != null &&
          medicine.startDate != null &&
          medicine.endDate!.isBefore(
            DateTime(
              medicine.startDate!.year,
              medicine.startDate!.month,
              medicine.startDate!.day,
            ),
          )) {
        throw const ValidationFailure(
          message: 'End date cannot be before start date.',
        );
      }
      final nowUtc = now();
      final id = medicine.id.isEmpty ? ids.next() : medicine.id;
      final existing = await db.medicinesDao.getById(id);
      DateTime? dayOnly(DateTime? d) =>
          d == null ? null : DateTime(d.year, d.month, d.day);

      final scheduleIds = <String>[];
      final schedules = medicine.schedules.map((s) {
        final sid = s.id.isEmpty ? ids.next() : s.id;
        scheduleIds.add(sid);
        return MedicineSchedule(
          id: sid,
          medicineId: id,
          timeOfDay: s.timeOfDay.trim(),
          days: s.days,
          notificationEnabled: s.notificationEnabled,
          notificationId: s.notificationId,
          createdAt: s.createdAt.isAfter(DateTime.fromMillisecondsSinceEpoch(0))
              ? s.createdAt
              : nowUtc,
          updatedAt: nowUtc,
        );
      }).toList();

      final toSave = medicine.copyWith(
        id: id,
        name: medicine.name.trim(),
        strength: _trimOrNull(medicine.strength),
        clearStrength: _trimOrNull(medicine.strength) == null,
        dosage: _trimOrNull(medicine.dosage),
        clearDosage: _trimOrNull(medicine.dosage) == null,
        frequencyText: _trimOrNull(medicine.frequencyText),
        clearFrequencyText: _trimOrNull(medicine.frequencyText) == null,
        startDate: dayOnly(medicine.startDate),
        clearStartDate: medicine.startDate == null,
        endDate: dayOnly(medicine.endDate),
        clearEndDate: medicine.endDate == null,
        reason: _trimOrNull(medicine.reason),
        clearReason: _trimOrNull(medicine.reason) == null,
        prescribedBy: _trimOrNull(medicine.prescribedBy),
        clearPrescribedBy: _trimOrNull(medicine.prescribedBy) == null,
        notes: _trimOrNull(medicine.notes),
        clearNotes: _trimOrNull(medicine.notes) == null,
        illnessId: _trimOrNull(medicine.illnessId),
        clearIllnessId: _trimOrNull(medicine.illnessId) == null,
        doctorVisitId: _trimOrNull(medicine.doctorVisitId),
        clearDoctorVisitId: _trimOrNull(medicine.doctorVisitId) == null,
        schedules: schedules,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.medicinesDao.upsert(MedicineMapper.toCompanion(toSave));
        final existingSchedules = await db.medicineSchedulesDao.forMedicine(id);
        for (final old in existingSchedules) {
          if (!scheduleIds.contains(old.id)) {
            await db.medicineSchedulesDao.softDelete(old.id, nowUtc);
          }
        }
        for (final schedule in schedules) {
          await db.medicineSchedulesDao.upsert(
            MedicineMapper.scheduleToCompanion(schedule),
          );
        }
      });
      return toSave;
    }, operation: 'medicines.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      final deletedAt = now();
      await db.runInTransaction(() async {
        await db.medicinesDao.softDelete(id, deletedAt);
        await db.medicineSchedulesDao.softDeleteForMedicine(id, deletedAt);
      });
    }, operation: 'medicines.softDelete');
  }

  String? _trimOrNull(String? value) {
    final t = value?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }
}
