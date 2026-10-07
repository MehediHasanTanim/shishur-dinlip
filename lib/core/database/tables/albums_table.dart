import 'package:drift/drift.dart';

@DataClassName('AlbumRow')
class Albums extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get albumType => text()();
  TextColumn get title => text()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get coverAssetId => text().nullable()();
  TextColumn get theme => text().nullable()();
  TextColumn get languageCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
