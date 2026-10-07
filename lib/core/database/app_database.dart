import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/connection/native_connection.dart';
import 'package:shishur_dinlipi/core/database/daos/achievements_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/attachments_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/audit_events_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/children_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/funny_moments_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/journal_entries_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/media_assets_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/reminders_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/settings_dao.dart';
import 'package:shishur_dinlipi/core/database/daos/tags_dao.dart';
import 'package:shishur_dinlipi/core/database/tables/achievements_table.dart';
import 'package:shishur_dinlipi/core/database/tables/attachments_table.dart';
import 'package:shishur_dinlipi/core/database/tables/audit_events_table.dart';
import 'package:shishur_dinlipi/core/database/tables/children_table.dart';
import 'package:shishur_dinlipi/core/database/tables/funny_moments_table.dart';
import 'package:shishur_dinlipi/core/database/tables/journal_entries_table.dart';
import 'package:shishur_dinlipi/core/database/tables/media_assets_table.dart';
import 'package:shishur_dinlipi/core/database/tables/reminders_table.dart';
import 'package:shishur_dinlipi/core/database/tables/settings_table.dart';
import 'package:shishur_dinlipi/core/database/tables/tag_links_table.dart';
import 'package:shishur_dinlipi/core/database/tables/tags_table.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.native() => AppDatabase(openAppConnection());

  factory AppDatabase.memory() => AppDatabase(openMemoryConnection());

  /// Bump when schema changes; add steps in [migration].
  static const int currentSchemaVersion = 2;

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
