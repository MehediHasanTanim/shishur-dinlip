import 'package:drift/drift.dart';

@DataClassName('BirthdayAnswerRow')
@TableIndex(
  name: 'birthday_answers_birthday',
  columns: {#birthdayId, #sortOrder},
)
class BirthdayAnswers extends Table {
  TextColumn get id => text()();
  TextColumn get birthdayId => text()();
  TextColumn get questionKey => text()();
  TextColumn get answer => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
