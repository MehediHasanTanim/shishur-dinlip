import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';

abstract final class VaccinationMapper {
  static Vaccination toDomain(VaccinationRow row) {
    return Vaccination(
      id: row.id,
      childId: row.childId,
      vaccineName: row.vaccineName,
      doseLabel: row.doseLabel,
      scheduledDate: row.scheduledDate,
      givenDate: row.givenDate,
      status: row.status,
      providerName: row.providerName,
      clinicName: row.clinicName,
      batchNumber: row.batchNumber,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static VaccinationsCompanion toCompanion(Vaccination item) {
    return VaccinationsCompanion(
      id: Value(item.id),
      childId: Value(item.childId),
      vaccineName: Value(item.vaccineName),
      doseLabel: Value(item.doseLabel),
      scheduledDate: Value(item.scheduledDate),
      givenDate: Value(item.givenDate),
      status: Value(item.status),
      providerName: Value(item.providerName),
      clinicName: Value(item.clinicName),
      batchNumber: Value(item.batchNumber),
      notes: Value(item.notes),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }
}
