import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/school_profile.dart';

abstract final class SchoolProfileMapper {
  static SchoolProfile toDomain(SchoolProfileRow row) {
    return SchoolProfile(
      id: row.id,
      childId: row.childId,
      schoolName: row.schoolName,
      startDate: row.startDate,
      endDate: row.endDate,
      className: row.className,
      teacherName: row.teacherName,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static SchoolProfilesCompanion toCompanion(SchoolProfile profile) {
    return SchoolProfilesCompanion(
      id: Value(profile.id),
      childId: Value(profile.childId),
      schoolName: Value(profile.schoolName),
      startDate: Value(profile.startDate),
      endDate: Value(profile.endDate),
      className: Value(profile.className),
      teacherName: Value(profile.teacherName),
      notes: Value(profile.notes),
      createdAt: Value(profile.createdAt),
      updatedAt: Value(profile.updatedAt),
      deletedAt: Value(profile.deletedAt),
    );
  }
}
