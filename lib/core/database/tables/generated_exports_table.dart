import 'package:drift/drift.dart';

@DataClassName('GeneratedExportRow')
class GeneratedExports extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text().nullable()();
  TextColumn get albumId => text().nullable()();
  TextColumn get exportType => text()();
  TextColumn get title => text()();
  TextColumn get filePath => text()();
  DateTimeColumn get dateRangeStart => dateTime().nullable()();
  DateTimeColumn get dateRangeEnd => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
