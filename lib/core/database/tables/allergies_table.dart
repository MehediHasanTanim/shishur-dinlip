import 'package:drift/drift.dart';

@DataClassName('AllergyRow')
@TableIndex(name: 'allergies_child_updated', columns: {#childId, #updatedAt})
class Allergies extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get allergen => text()();
  TextColumn get allergyType => text()();
  TextColumn get reaction => text().nullable()();
  TextColumn get severity => text()();
  DateTimeColumn get firstObserved => dateTime().nullable()();
  BoolColumn get doctorConfirmed =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
