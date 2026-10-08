import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';

void main() {
  test('fresh database opens at schema version 13', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    final row = await db.customSelect('PRAGMA user_version').getSingle();
    expect(row.data['user_version'], 13);
    expect(AppDatabase.currentSchemaVersion, 13);

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
      'allergies',
      'albums',
      'album_items',
      'generated_exports',
      'year_review_preferences',
      'birthdays',
      'birthday_answers',
      'favorites',
      'interests',
      'family_events',
      'trips',
      'search_index_meta',
      'search_index',
    ]) {
      await db.customSelect('SELECT COUNT(*) AS c FROM $table').getSingle();
    }

    final indexes = await db.customSelect('PRAGMA index_list(journal_entries)').get();
    final names = indexes.map((r) => r.data['name'] as String).toSet();
    expect(names.contains('journal_entries_child_event'), isTrue);
  });
}
