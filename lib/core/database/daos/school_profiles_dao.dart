import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/school_profiles_table.dart';

part 'school_profiles_dao.g.dart';

@DriftAccessor(tables: [SchoolProfiles])
class SchoolProfilesDao extends DatabaseAccessor<AppDatabase>
    with _$SchoolProfilesDaoMixin {
  SchoolProfilesDao(super.db);

  Future<List<SchoolProfileRow>> forChild(String childId) {
    return (select(schoolProfiles)
          ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.startDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  Future<SchoolProfileRow?> getById(String id) {
    return (select(schoolProfiles)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<SchoolProfileRow?> currentForChild(String childId) {
    return (select(schoolProfiles)
          ..where(
            (t) =>
                t.childId.equals(childId) &
                t.deletedAt.isNull() &
                t.endDate.isNull(),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.startDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsert(SchoolProfilesCompanion companion) {
    return into(schoolProfiles).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(schoolProfiles)..where((t) => t.id.equals(id))).write(
      SchoolProfilesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
