import 'package:drift/drift.dart';

@DataClassName('BirthdayRow')
@TableIndex(name: 'birthdays_child_age', columns: {#childId, #age})
@TableIndex(name: 'birthdays_child_date', columns: {#childId, #birthdayDate})
class Birthdays extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  IntColumn get age => integer()();
  DateTimeColumn get birthdayDate => dateTime()();
  TextColumn get locationText => text().nullable()();
  TextColumn get theme => text().nullable()();
  TextColumn get favoriteGift => text().nullable()();
  TextColumn get guestsText => text().nullable()();
  TextColumn get parentMessage => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get coverAssetId => text().nullable()();
  TextColumn get albumId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
