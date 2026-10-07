import 'package:drift/drift.dart';

@DataClassName('IllnessEpisodeRow')
@TableIndex(
  name: 'illness_episodes_child_start',
  columns: {#childId, #startDate},
)
class IllnessEpisodes extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get title => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get symptomsJson => text().nullable()();
  RealColumn get maxTemperatureC => real().nullable()();
  TextColumn get diagnosis => text().nullable()();
  TextColumn get doctorVisitId => text().nullable()();
  TextColumn get recoveryNote => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
