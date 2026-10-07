import 'package:drift/drift.dart';

@DataClassName('ChildRow')
class Children extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nickname => text().nullable()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get gender => text().nullable()();
  TextColumn get bloodGroup => text().nullable()();
  RealColumn get birthWeightKg => real().nullable()();
  RealColumn get birthHeightCm => real().nullable()();
  TextColumn get birthplace => text().nullable()();
  TextColumn get schoolName => text().nullable()();
  TextColumn get className => text().nullable()();
  TextColumn get profilePhotoId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
