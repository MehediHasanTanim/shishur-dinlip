import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/allergies_table.dart';

part 'allergies_dao.g.dart';

@DriftAccessor(tables: [Allergies])
class AllergiesDao extends DatabaseAccessor<AppDatabase>
    with _$AllergiesDaoMixin {
  AllergiesDao(super.db);

  Future<List<AllergyRow>> forChild(String childId, {int? limit}) {
    final query = select(allergies)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.updatedAt),
        (t) => OrderingTerm.asc(t.allergen),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<AllergyRow?> getById(String id) {
    return (select(allergies)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(AllergiesCompanion companion) {
    return into(allergies).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(allergies)..where((t) => t.id.equals(id))).write(
      AllergiesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
