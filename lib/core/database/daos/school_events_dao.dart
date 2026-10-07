import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/school_events_table.dart';

part 'school_events_dao.g.dart';

@DriftAccessor(tables: [SchoolEvents])
class SchoolEventsDao extends DatabaseAccessor<AppDatabase>
    with _$SchoolEventsDaoMixin {
  SchoolEventsDao(super.db);

  Future<List<SchoolEventRow>> forChild(
    String childId, {
    String? eventType,
    String? schoolProfileId,
    int? limit,
  }) {
    final query = select(schoolEvents)
      ..where((t) {
        var expr = t.childId.equals(childId) & t.deletedAt.isNull();
        if (eventType != null) {
          expr = expr & t.eventType.equals(eventType);
        }
        if (schoolProfileId != null) {
          expr = expr & t.schoolProfileId.equals(schoolProfileId);
        }
        return expr;
      })
      ..orderBy([
        (t) => OrderingTerm.desc(t.eventDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<List<SchoolEventRow>> upcomingForChild(
    String childId, {
    required DateTime from,
    int? limit,
  }) {
    final query = select(schoolEvents)
      ..where(
        (t) =>
            t.childId.equals(childId) &
            t.deletedAt.isNull() &
            t.eventDate.isBiggerOrEqualValue(from),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.eventDate)]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<SchoolEventRow?> getById(String id) {
    return (select(schoolEvents)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(SchoolEventsCompanion companion) {
    return into(schoolEvents).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(schoolEvents)..where((t) => t.id.equals(id))).write(
      SchoolEventsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
