import 'package:drift/drift.dart';

@DataClassName('MilestoneRow')
class Milestones extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  DateTimeColumn get eventDate => dateTime().nullable()();
  TextColumn get datePrecision => text()();
  TextColumn get description => text().nullable()();
  TextColumn get locationText => text().nullable()();
  TextColumn get peoplePresent => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
