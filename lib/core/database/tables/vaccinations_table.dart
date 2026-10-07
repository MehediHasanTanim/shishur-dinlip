import 'package:drift/drift.dart';

@DataClassName('VaccinationRow')
class Vaccinations extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get vaccineName => text()();
  TextColumn get doseLabel => text().nullable()();
  DateTimeColumn get scheduledDate => dateTime().nullable()();
  DateTimeColumn get givenDate => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get providerName => text().nullable()();
  TextColumn get clinicName => text().nullable()();
  TextColumn get batchNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
