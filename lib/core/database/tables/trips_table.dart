import 'package:drift/drift.dart';

@DataClassName('TripRow')
@TableIndex(name: 'trips_child_date', columns: {#childId, #startDate})
@TableIndex(name: 'trips_type', columns: {#tripType})
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  /// vacation | first_flight | first_beach | place_visit | other
  TextColumn get tripType => text()();
  TextColumn get title => text()();
  TextColumn get placeName => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get story => text().nullable()();
  TextColumn get childReaction => text().nullable()();
  TextColumn get coverAssetId => text().nullable()();
  TextColumn get albumId => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
