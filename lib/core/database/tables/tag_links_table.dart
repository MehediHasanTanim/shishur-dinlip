import 'package:drift/drift.dart';

@DataClassName('TagLinkRow')
class TagLinks extends Table {
  TextColumn get id => text()();
  TextColumn get tagId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
