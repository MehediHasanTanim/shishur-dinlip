import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/doctor_visit.dart';

abstract final class DoctorVisitMapper {
  static DoctorVisit toDomain(DoctorVisitRow row) {
    return DoctorVisit(
      id: row.id,
      childId: row.childId,
      visitDate: row.visitDate,
      doctorName: row.doctorName,
      specialty: row.specialty,
      hospitalOrChamber: row.hospitalOrChamber,
      reason: row.reason,
      symptoms: row.symptoms,
      diagnosis: row.diagnosis,
      testsAdvised: row.testsAdvised,
      followUpDate: row.followUpDate,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static DoctorVisitsCompanion toCompanion(DoctorVisit item) {
    return DoctorVisitsCompanion(
      id: Value(item.id),
      childId: Value(item.childId),
      visitDate: Value(item.visitDate),
      doctorName: Value(item.doctorName),
      specialty: Value(item.specialty),
      hospitalOrChamber: Value(item.hospitalOrChamber),
      reason: Value(item.reason),
      symptoms: Value(item.symptoms),
      diagnosis: Value(item.diagnosis),
      testsAdvised: Value(item.testsAdvised),
      followUpDate: Value(item.followUpDate),
      notes: Value(item.notes),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }
}
