import 'package:shishur_dinlipi/core/database/app_database.dart';

/// Allocates unique local notification IDs persisted in settings.
class NotificationIdStore {
  NotificationIdStore(this._db);

  final AppDatabase _db;
  static const _key = 'notification.next_id';

  Future<int> nextId() async {
    return _db.runInTransaction(() async {
      final raw = await _db.settingsDao.getValue(_key);
      final current = int.tryParse(raw ?? '') ?? 1000;
      final next = current + 1;
      await _db.settingsDao.setValue(_key, '$next', DateTime.now().toUtc());
      return current;
    });
  }
}
