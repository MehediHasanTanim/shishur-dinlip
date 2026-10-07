import 'package:drift/drift.dart';

@DataClassName('MedicineRow')
class Medicines extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get illnessId => text().nullable()();
  TextColumn get doctorVisitId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get strength => text().nullable()();
  TextColumn get dosage => text().nullable()();
  TextColumn get frequencyText => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get prescribedBy => text().nullable()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
