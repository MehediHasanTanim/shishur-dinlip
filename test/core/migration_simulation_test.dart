import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';

void main() {
  test('fresh database opens at schema version 8', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    final row = await db.customSelect('PRAGMA user_version').getSingle();
    expect(row.data['user_version'], 8);
    expect(AppDatabase.currentSchemaVersion, 8);

    for (final table in [
      'children',
      'settings',
      'media_assets',
      'attachments',
      'reminders',
      'tags',
      'tag_links',
      'journal_entries',
      'funny_moments',
      'achievements',
      'growth_records',
      'milestones',
      'first_words',
      'school_profiles',
      'school_events',
      'vaccinations',
      'illness_episodes',
      'medicines',
      'medicine_schedules',
      'doctor_visits',
      'medical_documents',
      'albums',
      'album_items',
      'generated_exports',
      'year_review_preferences',
    ]) {
      await db.customSelect('SELECT COUNT(*) AS c FROM $table').getSingle();
    }
  });
}
