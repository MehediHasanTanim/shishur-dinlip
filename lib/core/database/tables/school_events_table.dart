import 'package:drift/drift.dart';

@DataClassName('SchoolEventRow')
class SchoolEvents extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get schoolProfileId => text().nullable()();
  TextColumn get eventType => text()();
  TextColumn get title => text()();
  DateTimeColumn get eventDate => dateTime()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
