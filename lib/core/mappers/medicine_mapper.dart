import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';

abstract final class MedicineMapper {
  static Medicine toDomain(
    MedicineRow row, {
    List<MedicineSchedule> schedules = const [],
  }) {
    return Medicine(
      id: row.id,
      childId: row.childId,
      illnessId: row.illnessId,
      doctorVisitId: row.doctorVisitId,
      name: row.name,
      strength: row.strength,
      dosage: row.dosage,
      frequencyText: row.frequencyText,
      startDate: row.startDate,
      endDate: row.endDate,
      reason: row.reason,
      prescribedBy: row.prescribedBy,
      status: row.status,
      notes: row.notes,
      schedules: schedules,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static MedicinesCompanion toCompanion(Medicine item) {
    return MedicinesCompanion(
      id: Value(item.id),
      childId: Value(item.childId),
      illnessId: Value(item.illnessId),
      doctorVisitId: Value(item.doctorVisitId),
      name: Value(item.name),
      strength: Value(item.strength),
      dosage: Value(item.dosage),
      frequencyText: Value(item.frequencyText),
      startDate: Value(item.startDate),
      endDate: Value(item.endDate),
      reason: Value(item.reason),
      prescribedBy: Value(item.prescribedBy),
      status: Value(item.status),
      notes: Value(item.notes),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }

  static MedicineSchedule scheduleToDomain(MedicineScheduleRow row) {
    return MedicineSchedule(
      id: row.id,
      medicineId: row.medicineId,
      timeOfDay: row.timeOfDay,
      days: MedicineSchedule.decodeDays(row.daysJson),
      notificationEnabled: row.notificationEnabled,
      notificationId: row.notificationId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static MedicineSchedulesCompanion scheduleToCompanion(MedicineSchedule item) {
    return MedicineSchedulesCompanion(
      id: Value(item.id),
      medicineId: Value(item.medicineId),
      timeOfDay: Value(item.timeOfDay),
      daysJson: Value(MedicineSchedule.encodeDays(item.days)),
      notificationEnabled: Value(item.notificationEnabled),
      notificationId: Value(item.notificationId),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }
}
