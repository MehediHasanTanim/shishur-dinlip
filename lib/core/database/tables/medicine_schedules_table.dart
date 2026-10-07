import 'package:drift/drift.dart';

@DataClassName('MedicineScheduleRow')
class MedicineSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get timeOfDay => text()();
  TextColumn get daysJson => text().nullable()();
  BoolColumn get notificationEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get notificationId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
