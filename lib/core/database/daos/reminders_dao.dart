import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/reminders_table.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [Reminders])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(super.db);

  Future<List<ReminderRow>> allEnabled() {
    return (select(reminders)
          ..where((t) => t.isEnabled.equals(true) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .get();
  }

  Future<List<ReminderRow>> getEnabledUpcoming(DateTime from, {int? limit}) {
    final query = select(reminders)
      ..where(
        (t) =>
            t.isEnabled.equals(true) &
            t.deletedAt.isNull() &
            t.scheduledAt.isBiggerOrEqualValue(from),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<List<ReminderRow>> forChild(String? childId, {int? limit}) {
    final query = select(reminders)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]);
    if (childId != null) {
      query.where(
        (t) => t.childId.equals(childId) | t.childId.isNull(),
      );
    }
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<ReminderRow?> getById(String id) {
    return (select(reminders)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<ReminderRow?> findByEntity({
    required String reminderType,
    required String entityType,
    required String entityId,
  }) {
    return (select(reminders)
          ..where(
            (t) =>
                t.reminderType.equals(reminderType) &
                t.entityType.equals(entityType) &
                t.entityId.equals(entityId) &
                t.deletedAt.isNull(),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<ReminderRow?> findByType({
    required String reminderType,
    String? childId,
  }) {
    final query = select(reminders)
      ..where(
        (t) => t.reminderType.equals(reminderType) & t.deletedAt.isNull(),
      )
      ..limit(1);
    if (childId != null) {
      query.where((t) => t.childId.equals(childId));
    } else {
      query.where((t) => t.childId.isNull());
    }
    return query.getSingleOrNull();
  }

  Future<void> upsert(RemindersCompanion companion) {
    return into(reminders).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
        isEnabled: const Value(false),
      ),
    );
  }
}
