import 'package:drift/drift.dart';

@DataClassName('TagLinkRow')
@TableIndex(name: 'tag_links_tag', columns: {#tagId})
@TableIndex(
  name: 'tag_links_entity',
  columns: {#entityType, #entityId},
)
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
