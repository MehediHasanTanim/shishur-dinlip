import 'package:drift/drift.dart';

@DataClassName('AttachmentRow')
@TableIndex(
  name: 'attachments_entity',
  columns: {#entityType, #entityId},
)
@TableIndex(name: 'attachments_media', columns: {#mediaAssetId})
class Attachments extends Table {
  TextColumn get id => text()();
  TextColumn get mediaAssetId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get caption => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
