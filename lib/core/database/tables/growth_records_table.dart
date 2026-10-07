import 'package:drift/drift.dart';

@DataClassName('GrowthRecordRow')
@TableIndex(
  name: 'growth_records_child_measured',
  columns: {#childId, #measuredAt},
)
class GrowthRecords extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  DateTimeColumn get measuredAt => dateTime()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  TextColumn get measurementLocation => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
