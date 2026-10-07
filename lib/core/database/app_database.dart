import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/connection/native_connection.dart';
import 'package:shishur_dinlipi/core/database/daos/achievements_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/albums_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/attachments_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/audit_events_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/birthdays_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/children_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/favorites_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/doctor_visits_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/first_words_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/funny_moments_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/generated_exports_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/growth_records_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/illness_episodes_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/journal_entries_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/media_assets_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/medical_documents_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/medicine_schedules_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/medicines_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/milestones_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/reminders_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/school_events_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/school_profiles_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/settings_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/tags_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/vaccinations_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/year_review_preferences_dao.dart';
import 'package:shishur_dinlipi/core/database/tables/achievements_table.dart';
import 'package:shishur_dinlipi/core/database/tables/album_items_table.dart';
import 'package:shishur_dinlipi/core/database/tables/albums_table.dart';
import 'package:shishur_dinlipi/core/database/tables/attachments_table.dart';
import 'package:shishur_dinlipi/core/database/tables/audit_events_table.dart';
import 'package:shishur_dinlipi/core/database/tables/birthday_answers_table.dart';
import 'package:shishur_dinlipi/core/database/tables/birthdays_table.dart';
import 'package:shishur_dinlipi/core/database/tables/children_table.dart';
import 'package:shishur_dinlipi/core/database/tables/favorites_table.dart';
import 'package:shishur_dinlipi/core/database/tables/doctor_visits_table.dart';
import 'package:shishur_dinlipi/core/database/tables/first_words_table.dart';
import 'package:shishur_dinlipi/core/database/tables/funny_moments_table.dart';
import 'package:shishur_dinlipi/core/database/tables/generated_exports_table.dart';
import 'package:shishur_dinlipi/core/database/tables/growth_records_table.dart';
import 'package:shishur_dinlipi/core/database/tables/illness_episodes_table.dart';
import 'package:shishur_dinlipi/core/database/tables/journal_entries_table.dart';
import 'package:shishur_dinlipi/core/database/tables/media_assets_table.dart';
import 'package:shishur_dinlipi/core/database/tables/medical_documents_table.dart';
import 'package:shishur_dinlipi/core/database/tables/medicine_schedules_table.dart';
import 'package:shishur_dinlipi/core/database/tables/medicines_table.dart';
import 'package:shishur_dinlipi/core/database/tables/milestones_table.dart';
import 'package:shishur_dinlipi/core/database/tables/reminders_table.dart';
import 'package:shishur_dinlipi/core/database/tables/school_events_table.dart';
import 'package:shishur_dinlipi/core/database/tables/school_profiles_table.dart';
import 'package:shishur_dinlipi/core/database/tables/settings_table.dart';
import 'package:shishur_dinlipi/core/database/tables/tag_links_table.dart';
import 'package:shishur_dinlipi/core/database/tables/tags_table.dart';
import 'package:shishur_dinlipi/core/database/tables/vaccinations_table.dart';
import 'package:shishur_dinlipi/core/database/tables/year_review_preferences_table.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Children,
    Settings,
    MediaAssets,
    Attachments,
    Reminders,
    Tags,
    TagLinks,
    AuditEvents,
    JournalEntries,
    FunnyMoments,
    Achievements,
    GrowthRecords,
    Milestones,
    FirstWords,
    SchoolProfiles,
    SchoolEvents,
    Vaccinations,
    IllnessEpisodes,
    Medicines,
    MedicineSchedules,
    DoctorVisits,
    MedicalDocuments,
    Albums,
    AlbumItems,
    GeneratedExports,
    YearReviewPreferences,
    Birthdays,
    BirthdayAnswers,
    Favorites,
  ],
  daos: [
    ChildrenDao,
    SettingsDao,
    MediaAssetsDao,
    AttachmentsDao,
    RemindersDao,
    TagsDao,
    AuditEventsDao,
    JournalEntriesDao,
    FunnyMomentsDao,
    AchievementsDao,
    GrowthRecordsDao,
    MilestonesDao,
    FirstWordsDao,
    SchoolProfilesDao,
    SchoolEventsDao,
    VaccinationsDao,
    IllnessEpisodesDao,
    MedicinesDao,
    MedicineSchedulesDao,
    DoctorVisitsDao,
    MedicalDocumentsDao,
    AlbumsDao,
    GeneratedExportsDao,
    YearReviewPreferencesDao,
    BirthdaysDao,
    FavoritesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.native() => AppDatabase(openAppConnection());

  factory AppDatabase.memory() => AppDatabase(openMemoryConnection());

  /// Bump when schema changes; add steps in [migration].
  static const int currentSchemaVersion = 10;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _ensurePerformanceIndexes(m);
      AppLogger.instance.info('Database created', {
        'schemaVersion': schemaVersion,
      });
    },
    onUpgrade: (Migrator m, int from, int to) async {
      AppLogger.instance.info('Database migrating', {'from': from, 'to': to});
      if (from < 2) {
        await m.createTable(journalEntries);
        await m.createTable(funnyMoments);
        await m.createTable(achievements);
      }
      if (from < 3) {
        await m.createTable(growthRecords);
        await m.createTable(milestones);
        await m.createTable(firstWords);
      }
      if (from < 4) {
        await m.createTable(schoolProfiles);
        await m.createTable(schoolEvents);
      }
      if (from < 5) {
        await m.createTable(vaccinations);
        await m.createTable(illnessEpisodes);
        await m.createTable(medicines);
        await m.createTable(medicineSchedules);
        await m.createTable(doctorVisits);
        await m.createTable(medicalDocuments);
      }
      if (from < 6) {
        await m.addColumn(reminders, reminders.title);
        await m.addColumn(reminders, reminders.notes);
      }
      if (from < 7) {
        await m.createTable(albums);
        await m.createTable(albumItems);
        await m.createTable(generatedExports);
      }
      if (from < 8) {
        await m.createTable(yearReviewPreferences);
      }
      if (from < 9) {
        // Performance indexes (also declared via @TableIndex for fresh installs).
        await _ensurePerformanceIndexes(m);
      }
      if (from < 10) {
        await m.createTable(birthdays);
        await m.createTable(birthdayAnswers);
        await m.createTable(favorites);
        await _ensurePerformanceIndexes(m);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      AppLogger.instance.debug('Database opened', {
        'version': details.versionNow,
        'wasCreated': details.wasCreated,
      });
    },
  );

  Future<void> _ensurePerformanceIndexes(Migrator m) async {
    // Prefer generated index creators when available after codegen.
    try {
      await m.createAll();
    } catch (_) {
      // createAll on upgrade may no-op for existing tables; fall through.
    }
    const statements = <String>[
      'CREATE INDEX IF NOT EXISTS journal_entries_child_event ON journal_entries (child_id, event_date)',
      'CREATE INDEX IF NOT EXISTS journal_entries_title ON journal_entries (title)',
      'CREATE INDEX IF NOT EXISTS funny_moments_child_event ON funny_moments (child_id, event_date)',
      'CREATE INDEX IF NOT EXISTS achievements_child_event ON achievements (child_id, event_date)',
      'CREATE INDEX IF NOT EXISTS achievements_title ON achievements (title)',
      'CREATE INDEX IF NOT EXISTS growth_records_child_measured ON growth_records (child_id, measured_at)',
      'CREATE INDEX IF NOT EXISTS milestones_child_event ON milestones (child_id, event_date)',
      'CREATE INDEX IF NOT EXISTS milestones_title ON milestones (title)',
      'CREATE INDEX IF NOT EXISTS school_events_child_event ON school_events (child_id, event_date)',
      'CREATE INDEX IF NOT EXISTS school_events_title ON school_events (title)',
      'CREATE INDEX IF NOT EXISTS reminders_scheduled_enabled ON reminders (scheduled_at, is_enabled)',
      'CREATE INDEX IF NOT EXISTS reminders_child_scheduled ON reminders (child_id, scheduled_at)',
      'CREATE INDEX IF NOT EXISTS media_assets_child ON media_assets (child_id)',
      'CREATE INDEX IF NOT EXISTS media_assets_checksum ON media_assets (checksum)',
      'CREATE INDEX IF NOT EXISTS media_assets_favorite ON media_assets (is_favorite)',
      'CREATE INDEX IF NOT EXISTS attachments_entity ON attachments (entity_type, entity_id)',
      'CREATE INDEX IF NOT EXISTS attachments_media ON attachments (media_asset_id)',
      'CREATE INDEX IF NOT EXISTS tag_links_tag ON tag_links (tag_id)',
      'CREATE INDEX IF NOT EXISTS tag_links_entity ON tag_links (entity_type, entity_id)',
      'CREATE INDEX IF NOT EXISTS illness_episodes_child_start ON illness_episodes (child_id, start_date)',
      'CREATE INDEX IF NOT EXISTS doctor_visits_child_visit ON doctor_visits (child_id, visit_date)',
      'CREATE INDEX IF NOT EXISTS vaccinations_child_scheduled ON vaccinations (child_id, scheduled_date)',
      'CREATE INDEX IF NOT EXISTS vaccinations_name ON vaccinations (vaccine_name)',
      'CREATE INDEX IF NOT EXISTS first_words_child_event ON first_words (child_id, event_date)',
      'CREATE INDEX IF NOT EXISTS birthdays_child_age ON birthdays (child_id, age)',
      'CREATE INDEX IF NOT EXISTS birthdays_child_date ON birthdays (child_id, birthday_date)',
      'CREATE INDEX IF NOT EXISTS birthday_answers_birthday ON birthday_answers (birthday_id, sort_order)',
      'CREATE INDEX IF NOT EXISTS favorites_child_category ON favorites (child_id, category)',
    ];
    for (final sql in statements) {
      await customStatement(sql);
    }
  }

  Future<T> runInTransaction<T>(Future<T> Function() action) {
    return transaction(action);
  }
}
