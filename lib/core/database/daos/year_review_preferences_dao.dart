import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/year_review_preferences_table.dart';

part 'year_review_preferences_dao.g.dart';

@DriftAccessor(tables: [YearReviewPreferences])
class YearReviewPreferencesDao extends DatabaseAccessor<AppDatabase>
    with _$YearReviewPreferencesDaoMixin {
  YearReviewPreferencesDao(super.db);

  Future<YearReviewPreferenceRow?> forChildYear(String childId, int year) {
    return (select(yearReviewPreferences)
          ..where(
            (t) =>
                t.childId.equals(childId) &
                t.year.equals(year) &
                t.deletedAt.isNull(),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<YearReviewPreferenceRow>> forChild(String childId) {
    return (select(yearReviewPreferences)
          ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.year)]))
        .get();
  }

  Future<YearReviewPreferenceRow?> getById(String id) {
    return (select(yearReviewPreferences)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(YearReviewPreferencesCompanion companion) {
    return into(yearReviewPreferences).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(yearReviewPreferences)..where((t) => t.id.equals(id))).write(
      YearReviewPreferencesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
