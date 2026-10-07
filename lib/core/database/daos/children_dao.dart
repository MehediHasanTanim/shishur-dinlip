import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/children_table.dart';

part 'children_dao.g.dart';

@DriftAccessor(tables: [Children])
class ChildrenDao extends DatabaseAccessor<AppDatabase>
    with _$ChildrenDaoMixin {
  ChildrenDao(super.db);

  Future<List<ChildRow>> getActive() {
    return (select(children)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<ChildRow?> getById(String id) {
    return (select(
      children,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  Future<void> upsert(ChildrenCompanion companion) {
    return into(children).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(children)..where((t) => t.id.equals(id))).write(
      ChildrenCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
