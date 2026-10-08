import 'package:drift/drift.dart';

@DataClassName('FamilyEventRow')
@TableIndex(
  name: 'family_events_child_date',
  columns: {#childId, #eventDate},
)
@TableIndex(name: 'family_events_type', columns: {#eventType})
class FamilyEvents extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get eventType => text()();
  TextColumn get title => text()();
  DateTimeColumn get eventDate => dateTime()();
  TextColumn get locationText => text().nullable()();
  TextColumn get story => text().nullable()();
  TextColumn get childReaction => text().nullable()();
  TextColumn get coverAssetId => text().nullable()();
  TextColumn get albumId => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
