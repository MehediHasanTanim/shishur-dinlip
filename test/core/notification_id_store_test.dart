import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/notifications/notification_id_store.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  test('allocates increasing notification ids', () async {
    final store = NotificationIdStore(db);
    final first = await store.nextId();
    final second = await store.nextId();
    expect(second, first + 1);
  });
}
