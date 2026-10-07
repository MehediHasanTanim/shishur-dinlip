import 'package:drift/drift.dart';

@DataClassName('AlbumItemRow')
class AlbumItems extends Table {
  TextColumn get id => text()();
  TextColumn get albumId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isIncluded => boolean().withDefault(const Constant(true))();
  TextColumn get customCaption => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
