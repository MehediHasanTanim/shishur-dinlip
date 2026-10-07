import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';
import 'package:shishur_dinlipi/core/security/db_encryption_key_store.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

const _dbFileName = 'shishur_dinlipi.sqlite';
const _plainLegacyName = 'shishur_dinlipi.plain.sqlite';

/// Opens the on-device encrypted SQLite database (sqlite3mc / SQLCipher-compatible).
LazyDatabase openAppConnection({
  SecureStorageService? secureStorage,
  DbEncryptionKeyStore? keyStore,
}) {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final secure = secureStorage ?? SecureStorageService();
    final keys = keyStore ?? DbEncryptionKeyStore(secure);
    final passphrase = await keys.getOrCreateKey();

    final dir = await getApplicationSupportDirectory();
    final dbFile = File(p.join(dir.path, _dbFileName));
    final legacyPlain = File(p.join(dir.path, _plainLegacyName));

    // One-time migration: older builds may have left an unencrypted copy aside.
    if (!await dbFile.exists() && await legacyPlain.exists()) {
      await legacyPlain.rename(dbFile.path);
    }

    final encryptionAvailable = _detectEncryptionSupport();
    if (!encryptionAvailable) {
      AppLogger.instance.warn(
        'SQLite encryption binary not detected; opening without PRAGMA key',
      );
      return NativeDatabase.createInBackground(dbFile);
    }

    final alreadyMarked = await keys.isEncryptionMarkedEnabled();
    final exists = await dbFile.exists();

    if (exists && !alreadyMarked) {
      // Migrate plaintext DB → encrypted via REKEY when supported.
      await _migratePlainToEncrypted(dbFile, passphrase);
      await keys.markEncryptionEnabled(true);
    } else if (!exists) {
      await keys.markEncryptionEnabled(true);
    }

    return NativeDatabase.createInBackground(
      dbFile,
      setup: (rawDb) {
        _applyKey(rawDb, passphrase);
        // Touch schema to fail fast on wrong key.
        rawDb.execute('SELECT count(*) FROM sqlite_master');
      },
    );
  });
}

QueryExecutor openMemoryConnection() => NativeDatabase.memory();

bool _detectEncryptionSupport() {
  Database? db;
  try {
    db = sqlite3.openInMemory();
    final cipherVersion = db.select('PRAGMA cipher_version');
    if (cipherVersion.isNotEmpty) return true;
    final cipher = db.select('PRAGMA cipher');
    if (cipher.isNotEmpty) return true;
    return false;
  } catch (_) {
    return false;
  } finally {
    db?.close();
  }
}

void _applyKey(Database rawDb, String passphrase) {
  // Escape single quotes for PRAGMA string literal.
  final escaped = passphrase.replaceAll("'", "''");
  rawDb.execute("PRAGMA key = '$escaped'");
}

Future<void> _migratePlainToEncrypted(File dbFile, String passphrase) async {
  Database? db;
  try {
    db = sqlite3.open(dbFile.path);
    // Opening without key — if already encrypted this may fail; caller only
    // invokes when encryption was not previously marked.
    try {
      db.select('SELECT count(*) FROM sqlite_master');
    } catch (_) {
      // Already encrypted or unreadable — apply key and bail.
      _applyKey(db, passphrase);
      db.select('SELECT count(*) FROM sqlite_master');
      return;
    }
    final escaped = passphrase.replaceAll("'", "''");
    db.execute("PRAGMA rekey = '$escaped'");
    db.select('SELECT count(*) FROM sqlite_master');
    AppLogger.instance.info('Migrated SQLite database to encrypted storage');
  } catch (error, stackTrace) {
    AppLogger.instance.error(
      'DB encryption migration failed; continuing with key on next open',
      error: error,
      stackTrace: stackTrace,
    );
  } finally {
    db?.close();
  }
}
