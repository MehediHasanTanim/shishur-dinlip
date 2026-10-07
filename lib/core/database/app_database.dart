import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/connection/native_connection.dart';
import 'package:shishur_dinlipi/core/database/daos/achievements_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/attachments_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/audit_events_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/children_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/doctor_visits_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/first_words_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/funny_moments_dao.dart';
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
import 'package:shishur_dinlipi/core/database/tables/achievements_table.dart';
import 'package:shishur_dinlipi/core/database/tables/attachments_table.dart';
import 'package:shishur_dinlipi/core/database/tables/audit_events_table.dart';
import 'package:shishur_dinlipi/core/database/tables/children_table.dart';
import 'package:shishur_dinlipi/core/database/tables/doctor_visits_table.dart';
import 'package:shishur_dinlipi/core/database/tables/first_words_table.dart';
import 'package:shishur_dinlipi/core/database/tables/funny_moments_table.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.native() => AppDatabase(openAppConnection());

  factory AppDatabase.memory() => AppDatabase(openMemoryConnection());

  /// Bump when schema changes; add steps in [migration].
  static const int currentSchemaVersion = 5;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
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
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      AppLogger.instance.debug('Database opened', {
        'version': details.versionNow,
        'wasCreated': details.wasCreated,
      });
    },
  );

  Future<T> runInTransaction<T>(Future<T> Function() action) {
    return transaction(action);
  }
}
