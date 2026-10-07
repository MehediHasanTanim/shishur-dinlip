import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/reminder.dart';

abstract final class ReminderMapper {
  static Reminder toDomain(ReminderRow row) {
    return Reminder(
      id: row.id,
      childId: row.childId,
      entityType: row.entityType,
      entityId: row.entityId,
      reminderType: row.reminderType,
      title: row.title,
      notes: row.notes,
      scheduledAt: row.scheduledAt,
      repeatRule: row.repeatRule,
      notificationId: row.notificationId,
      isEnabled: row.isEnabled,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static RemindersCompanion toCompanion(Reminder item) {
    return RemindersCompanion(
      id: Value(item.id),
      childId: Value(item.childId),
      entityType: Value(item.entityType),
      entityId: Value(item.entityId),
      reminderType: Value(item.reminderType),
      title: Value(item.title),
      notes: Value(item.notes),
      scheduledAt: Value(item.scheduledAt),
      repeatRule: Value(item.repeatRule),
      notificationId: Value(item.notificationId),
      isEnabled: Value(item.isEnabled),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }
}
