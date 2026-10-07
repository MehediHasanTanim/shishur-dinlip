import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';

void main() {
  test('fresh database opens at schema version 6', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    final row = await db.customSelect('PRAGMA user_version').getSingle();
    expect(row.data['user_version'], 6);
    expect(AppDatabase.currentSchemaVersion, 6);

    await db.customSelect('SELECT COUNT(*) AS c FROM children').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM settings').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM media_assets').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM attachments').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM reminders').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM tags').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM tag_links').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM audit_events').getSingle();
    await db
        .customSelect('SELECT COUNT(*) AS c FROM journal_entries')
        .getSingle();
    await db
        .customSelect('SELECT COUNT(*) AS c FROM funny_moments')
        .getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM achievements').getSingle();
    await db
        .customSelect('SELECT COUNT(*) AS c FROM growth_records')
        .getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM milestones').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM first_words').getSingle();
    await db
        .customSelect('SELECT COUNT(*) AS c FROM school_profiles')
        .getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM school_events').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM vaccinations').getSingle();
    await db
        .customSelect('SELECT COUNT(*) AS c FROM illness_episodes')
        .getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM medicines').getSingle();
    await db
        .customSelect('SELECT COUNT(*) AS c FROM medicine_schedules')
        .getSingle();
    await db
        .customSelect('SELECT COUNT(*) AS c FROM doctor_visits')
        .getSingle();
    await db
        .customSelect('SELECT COUNT(*) AS c FROM medical_documents')
        .getSingle();

    final cols = await db.customSelect('PRAGMA table_info(reminders)').get();
    final names = cols.map((c) => c.data['name']).toSet();
    expect(names.contains('title'), isTrue);
    expect(names.contains('notes'), isTrue);
  });
}
