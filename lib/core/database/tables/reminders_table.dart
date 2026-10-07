import 'package:drift/drift.dart';

@DataClassName('ReminderRow')
@TableIndex(
  name: 'reminders_scheduled_enabled',
  columns: {#scheduledAt, #isEnabled},
)
@TableIndex(name: 'reminders_child_scheduled', columns: {#childId, #scheduledAt})
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text().nullable()();
  TextColumn get entityType => text().nullable()();
  TextColumn get entityId => text().nullable()();
  TextColumn get reminderType => text()();
  TextColumn get title => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get repeatRule => text().nullable()();
  IntColumn get notificationId => integer().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
