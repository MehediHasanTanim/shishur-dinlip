import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/trips_table.dart';

part 'trips_dao.g.dart';

@DriftAccessor(tables: [Trips])
class TripsDao extends DatabaseAccessor<AppDatabase> with _$TripsDaoMixin {
  TripsDao(super.db);

  Future<List<TripRow>> forChild(
    String childId, {
    String? tripType,
    int? limit,
  }) {
    final query = select(trips)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.startDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (tripType != null) {
      query.where((t) => t.tripType.equals(tripType));
    }
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<TripRow?> getById(String id) {
    return (select(trips)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(TripsCompanion companion) {
    return into(trips).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(trips)..where((t) => t.id.equals(id))).write(
      TripsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
