import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/generated_exports_table.dart';

part 'generated_exports_dao.g.dart';

@DriftAccessor(tables: [GeneratedExports])
class GeneratedExportsDao extends DatabaseAccessor<AppDatabase>
    with _$GeneratedExportsDaoMixin {
  GeneratedExportsDao(super.db);

  Future<List<GeneratedExportRow>> forChild(String childId) {
    return (select(generatedExports)
          ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<GeneratedExportRow?> getById(String id) {
    return (select(generatedExports)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(GeneratedExportsCompanion companion) {
    return into(generatedExports).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(generatedExports)..where((t) => t.id.equals(id))).write(
      GeneratedExportsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
