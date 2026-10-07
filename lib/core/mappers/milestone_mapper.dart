import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';
import 'package:shishur_dinlipi/core/domain/models/milestone.dart';

abstract final class MilestoneMapper {
  static Milestone toDomain(MilestoneRow row) {
    return Milestone(
      id: row.id,
      childId: row.childId,
      category: row.category,
      title: row.title,
      eventDate: row.eventDate,
      datePrecision: DatePrecision.fromStorage(row.datePrecision),
      description: row.description,
      locationText: row.locationText,
      peoplePresent: row.peoplePresent,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static MilestonesCompanion toCompanion(Milestone milestone) {
    return MilestonesCompanion(
      id: Value(milestone.id),
      childId: Value(milestone.childId),
      category: Value(milestone.category),
      title: Value(milestone.title),
      eventDate: Value(milestone.eventDate),
      datePrecision: Value(milestone.datePrecision.name),
      description: Value(milestone.description),
      locationText: Value(milestone.locationText),
      peoplePresent: Value(milestone.peoplePresent),
      createdAt: Value(milestone.createdAt),
      updatedAt: Value(milestone.updatedAt),
      deletedAt: Value(milestone.deletedAt),
    );
  }
}
