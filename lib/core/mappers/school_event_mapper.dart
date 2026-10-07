import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/school_event.dart';

abstract final class SchoolEventMapper {
  static SchoolEvent toDomain(SchoolEventRow row) {
    return SchoolEvent(
      id: row.id,
      childId: row.childId,
      schoolProfileId: row.schoolProfileId,
      eventType: row.eventType,
      title: row.title,
      eventDate: row.eventDate,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static SchoolEventsCompanion toCompanion(SchoolEvent event) {
    return SchoolEventsCompanion(
      id: Value(event.id),
      childId: Value(event.childId),
      schoolProfileId: Value(event.schoolProfileId),
      eventType: Value(event.eventType),
      title: Value(event.title),
      eventDate: Value(event.eventDate),
      description: Value(event.description),
      createdAt: Value(event.createdAt),
      updatedAt: Value(event.updatedAt),
      deletedAt: Value(event.deletedAt),
    );
  }
}
