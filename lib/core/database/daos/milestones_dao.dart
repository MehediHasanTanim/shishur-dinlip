import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/milestones_table.dart';

part 'milestones_dao.g.dart';

@DriftAccessor(tables: [Milestones])
class MilestonesDao extends DatabaseAccessor<AppDatabase>
    with _$MilestonesDaoMixin {
  MilestonesDao(super.db);

  Future<List<MilestoneRow>> forChild(
    String childId, {
    String? category,
    int? limit,
  }) {
    final query = select(milestones)
      ..where((t) {
        var expr = t.childId.equals(childId) & t.deletedAt.isNull();
        if (category != null) {
          expr = expr & t.category.equals(category);
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

  Future<MilestoneRow?> getById(String id) {
    return (select(milestones)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(MilestonesCompanion companion) {
    return into(milestones).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(milestones)..where((t) => t.id.equals(id))).write(
      MilestonesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
