import 'package:drift/drift.dart';

@DataClassName('SchoolProfileRow')
class SchoolProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get schoolName => text()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get className => text().nullable()();
  TextColumn get teacherName => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
