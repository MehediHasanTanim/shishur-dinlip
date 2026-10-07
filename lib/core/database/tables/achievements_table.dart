import 'package:drift/drift.dart';

@DataClassName('AchievementRow')
@TableIndex(
  name: 'achievements_child_event',
  columns: {#childId, #eventDate},
)
@TableIndex(name: 'achievements_title', columns: {#title})
class Achievements extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  DateTimeColumn get eventDate => dateTime()();
  TextColumn get description => text().nullable()();
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
