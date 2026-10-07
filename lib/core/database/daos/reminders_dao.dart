import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/reminders_table.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [Reminders])
class RemindersDao extends DatabaseAccessor<AppDatabase>
    with _$RemindersDaoMixin {
  RemindersDao(super.db);

  Future<List<ReminderRow>> getEnabledUpcoming(DateTime from) {
    return (select(reminders)
          ..where(
            (t) =>
                t.isEnabled.equals(true) &
                t.deletedAt.isNull() &
                t.scheduledAt.isBiggerOrEqualValue(from),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .get();
  }

  Future<void> upsert(RemindersCompanion companion) {
    return into(reminders).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
