import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';

void main() {
  test('fresh database opens at schema version 1', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    final row = await db.customSelect('PRAGMA user_version').getSingle();
    expect(row.data['user_version'], 1);
    expect(AppDatabase.currentSchemaVersion, 1);

    // Touch each base table to prove onCreate built them.
    await db.customSelect('SELECT COUNT(*) AS c FROM children').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM settings').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM media_assets').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM attachments').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM reminders').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM tags').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM tag_links').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM audit_events').getSingle();
  });
}
