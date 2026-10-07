import 'package:drift/drift.dart';

@DataClassName('AuditEventRow')
class AuditEvents extends Table {
  TextColumn get id => text()();
  TextColumn get eventType => text()();
  TextColumn get entityType => text().nullable()();
  TextColumn get entityId => text().nullable()();
  TextColumn get payloadJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
