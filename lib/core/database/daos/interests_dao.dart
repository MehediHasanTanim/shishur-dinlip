import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/interests_table.dart';

part 'interests_dao.g.dart';

@DriftAccessor(tables: [Interests])
class InterestsDao extends DatabaseAccessor<AppDatabase>
    with _$InterestsDaoMixin {
  InterestsDao(super.db);

  Future<List<InterestRow>> forChild(String childId, {int? limit}) {
    final query = select(interests)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.interestLevel),
        (t) => OrderingTerm.desc(t.updatedAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<InterestRow?> getById(String id) {
    return (select(interests)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(InterestsCompanion companion) {
    return into(interests).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(interests)..where((t) => t.id.equals(id))).write(
      InterestsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
