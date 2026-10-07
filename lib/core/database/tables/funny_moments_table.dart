import 'package:drift/drift.dart';

@DataClassName('FunnyMomentRow')
class FunnyMoments extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  DateTimeColumn get eventDate => dateTime()();
  TextColumn get title => text().nullable()();
  TextColumn get story => text().nullable()();
  TextColumn get quoteText => text().nullable()();
  TextColumn get peoplePresent => text().nullable()();
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
