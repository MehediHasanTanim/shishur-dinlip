import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/growth_records_table.dart';

part 'growth_records_dao.g.dart';

@DriftAccessor(tables: [GrowthRecords])
class GrowthRecordsDao extends DatabaseAccessor<AppDatabase>
    with _$GrowthRecordsDaoMixin {
  GrowthRecordsDao(super.db);

  Future<List<GrowthRecordRow>> forChild(String childId, {int? limit}) {
    final query = select(growthRecords)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.measuredAt),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<GrowthRecordRow?> getById(String id) {
    return (select(growthRecords)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<GrowthRecordRow?> latestForChild(String childId) {
    return (select(growthRecords)
          ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.measuredAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsert(GrowthRecordsCompanion companion) {
    return into(growthRecords).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(growthRecords)..where((t) => t.id.equals(id))).write(
      GrowthRecordsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
