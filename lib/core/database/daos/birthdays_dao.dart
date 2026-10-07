import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/birthday_answers_table.dart';
import 'package:shishur_dinlipi/core/database/tables/birthdays_table.dart';

part 'birthdays_dao.g.dart';

@DriftAccessor(tables: [Birthdays, BirthdayAnswers])
class BirthdaysDao extends DatabaseAccessor<AppDatabase>
    with _$BirthdaysDaoMixin {
  BirthdaysDao(super.db);

  Future<List<BirthdayRow>> forChild(String childId) {
    return (select(birthdays)
          ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.age),
            (t) => OrderingTerm.desc(t.birthdayDate),
          ]))
        .get();
  }

  Future<BirthdayRow?> getById(String id) {
    return (select(birthdays)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<BirthdayRow?> forChildAge(String childId, int age) {
    return (select(birthdays)..where(
          (t) =>
              t.childId.equals(childId) &
              t.age.equals(age) &
              t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(BirthdaysCompanion companion) {
    return into(birthdays).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(birthdays)..where((t) => t.id.equals(id))).write(
      BirthdaysCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<List<BirthdayAnswerRow>> answersForBirthday(String birthdayId) {
    return (select(birthdayAnswers)
          ..where(
            (t) => t.birthdayId.equals(birthdayId) & t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<List<BirthdayAnswerRow>> answersForChild(String childId) async {
    final rows = await customSelect(
      '''
      SELECT a.* FROM birthday_answers a
      INNER JOIN birthdays b ON b.id = a.birthday_id
      WHERE b.child_id = ? AND b.deleted_at IS NULL AND a.deleted_at IS NULL
      ORDER BY b.age ASC, a.sort_order ASC
      ''',
      variables: [Variable.withString(childId)],
      readsFrom: {birthdayAnswers, birthdays},
    ).get();
    return rows.map((r) => birthdayAnswers.map(r.data)).toList();
  }

  Future<void> upsertAnswer(BirthdayAnswersCompanion companion) {
    return into(birthdayAnswers).insertOnConflictUpdate(companion);
  }

  Future<void> softDeleteAnswersForBirthday(
    String birthdayId,
    DateTime deletedAt,
  ) {
    return (update(birthdayAnswers)
          ..where((t) => t.birthdayId.equals(birthdayId)))
        .write(
          BirthdayAnswersCompanion(
            deletedAt: Value(deletedAt),
            updatedAt: Value(deletedAt),
          ),
        );
  }

  Future<void> softDeleteAnswer(String id, DateTime deletedAt) {
    return (update(birthdayAnswers)..where((t) => t.id.equals(id))).write(
      BirthdayAnswersCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
