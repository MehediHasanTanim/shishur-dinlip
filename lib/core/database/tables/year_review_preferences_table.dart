import 'package:drift/drift.dart';

@DataClassName('YearReviewPreferenceRow')
class YearReviewPreferences extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  IntColumn get year => integer()();
  TextColumn get parentLetter => text().nullable()();
  TextColumn get coverAssetId => text().nullable()();
  TextColumn get theme => text().withDefault(const Constant('minimal'))();
  BoolColumn get includeHealth =>
      boolean().withDefault(const Constant(false))();
  TextColumn get languageCode => text().withDefault(const Constant('en'))();
  /// JSON map of section -> ordered item drafts (include/caption/order).
  TextColumn get selectionJson => text().nullable()();
  TextColumn get titleOverride => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
