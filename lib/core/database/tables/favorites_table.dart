import 'package:drift/drift.dart';

@DataClassName('FavoriteRow')
@TableIndex(name: 'favorites_child_category', columns: {#childId, #category})
class Favorites extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get category => text()();
  TextColumn get value => text()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  /// Optional link to the birthday interview that set this value.
  TextColumn get sourceBirthdayId => text().nullable()();
  IntColumn get recordedAge => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
