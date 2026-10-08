import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/family_events_table.dart';

part 'family_events_dao.g.dart';

@DriftAccessor(tables: [FamilyEvents])
class FamilyEventsDao extends DatabaseAccessor<AppDatabase>
    with _$FamilyEventsDaoMixin {
  FamilyEventsDao(super.db);

  Future<List<FamilyEventRow>> forChild(
    String childId, {
    String? eventType,
    int? limit,
  }) {
    final query = select(familyEvents)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.eventDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (eventType != null) {
      query.where((t) => t.eventType.equals(eventType));
    }
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<FamilyEventRow?> getById(String id) {
    return (select(familyEvents)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(FamilyEventsCompanion companion) {
    return into(familyEvents).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(familyEvents)..where((t) => t.id.equals(id))).write(
      FamilyEventsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
