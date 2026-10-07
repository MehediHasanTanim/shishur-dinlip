import 'package:drift/drift.dart';

@DataClassName('JournalEntryRow')
class JournalEntries extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get entryType => text()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text()();
  DateTimeColumn get eventDate => dateTime()();
  TextColumn get mood => text().nullable()();
  TextColumn get locationText => text().nullable()();
  BoolColumn get isPrivate =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
