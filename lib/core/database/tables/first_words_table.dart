import 'package:drift/drift.dart';

@DataClassName('FirstWordRow')
@TableIndex(
  name: 'first_words_child_event',
  columns: {#childId, #eventDate},
)
class FirstWords extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get word => text()();
  TextColumn get languageCode => text().nullable()();
  DateTimeColumn get eventDate => dateTime().nullable()();
  TextColumn get datePrecision => text()();
  TextColumn get contextNote => text().nullable()();
  TextColumn get audioAssetId => text().nullable()();
  BoolColumn get audioPlaceholder =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
