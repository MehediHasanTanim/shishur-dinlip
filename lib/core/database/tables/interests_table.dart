import 'package:drift/drift.dart';

@DataClassName('InterestRow')
@TableIndex(name: 'interests_child_name', columns: {#childId, #name})
class Interests extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get name => text()();
  DateTimeColumn get firstNoticed => dateTime().nullable()();
  /// 1..5 interest strength; null if unset.
  IntColumn get interestLevel => integer().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get coverAssetId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
