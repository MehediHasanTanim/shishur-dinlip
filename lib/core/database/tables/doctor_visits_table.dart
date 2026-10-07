import 'package:drift/drift.dart';

@DataClassName('DoctorVisitRow')
@TableIndex(
  name: 'doctor_visits_child_visit',
  columns: {#childId, #visitDate},
)
class DoctorVisits extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  DateTimeColumn get visitDate => dateTime()();
  TextColumn get doctorName => text()();
  TextColumn get specialty => text().nullable()();
  TextColumn get hospitalOrChamber => text().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get symptoms => text().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get testsAdvised => text().nullable()();
  DateTimeColumn get followUpDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
