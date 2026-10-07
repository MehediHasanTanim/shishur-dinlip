import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/backup_crypto.dart';
import 'package:shishur_dinlipi/core/backup/backup_service.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/config/app_flavor.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/security/auto_lock_mode.dart';
import 'package:shishur_dinlipi/core/security/db_encryption_key_store.dart';
import 'package:shishur_dinlipi/core/security/pin_service.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';
import 'package:shishur_dinlipi/core/security/security_settings_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SecureStorageService secure;
  late PinService pins;

  setUp(() {
    AppConfig.initialize(AppFlavor.dev);
    secure = SecureStorageService.memory();
    pins = PinService(secure);
  });

  group('PIN', () {
    test('set verify change remove', () async {
      await pins.setPin('1234');
      expect(await pins.isPinEnabled(), isTrue);
      expect(await pins.verifyPin('1234'), isTrue);
      await expectLater(pins.verifyPin('9999'), throwsA(isA<SecurityFailure>()));

      await pins.changePin(currentPin: '1234', newPin: '5678');
      expect(await pins.verifyPin('5678'), isTrue);

      await pins.removePin('5678');
      expect(await pins.isPinEnabled(), isFalse);
    });

    test('wrong PIN lockout after max attempts', () async {
      await pins.setPin('1234');
      for (var i = 0; i < PinService.maxAttempts - 1; i++) {
        await expectLater(
          pins.verifyPin('0000'),
          throwsA(isA<SecurityFailure>()),
        );
      }
      await expectLater(
        pins.verifyPin('0000'),
        throwsA(
          isA<SecurityFailure>().having((e) => e.lockedOut, 'lockedOut', true),
        ),
      );
    });

    test('rejects non-digit or short PIN', () async {
      await expectLater(pins.setPin('12'), throwsA(isA<SecurityFailure>()));
      await expectLater(pins.setPin('abcd'), throwsA(isA<SecurityFailure>()));
    });
  });

  group('security settings', () {
    test('auto-lock modes persist', () async {
      final store = SecuritySettingsStore(secure);
      await store.setAutoLock(AutoLockMode.fiveMinutes);
      final loaded = await store.load();
      expect(loaded.autoLock, AutoLockMode.fiveMinutes);
      expect(AutoLockMode.fiveMinutes.timeout, const Duration(minutes: 5));
      expect(AutoLockMode.immediately.timeout, Duration.zero);
    });
  });

  group('db encryption key store', () {
    test('generates stable key', () async {
      final keys = DbEncryptionKeyStore(secure);
      final a = await keys.getOrCreateKey();
      final b = await keys.getOrCreateKey();
      expect(a, b);
      expect(a.length, greaterThan(20));
    });
  });

  group('backup crypto', () {
    test('round-trip encrypt decrypt', () async {
      final clear = Uint8List.fromList(
        List<int>.generate(5000, (i) => i % 256),
      );
      final sealed = await BackupCrypto.encrypt(
        plaintext: clear,
        password: 'correct-horse',
      );
      expect(sealed.length, greaterThan(clear.length));
      final opened = await BackupCrypto.decrypt(
        package: sealed,
        password: 'correct-horse',
      );
      expect(opened, clear);
    });

    test('wrong password fails', () async {
      final sealed = await BackupCrypto.encrypt(
        plaintext: Uint8List.fromList([1, 2, 3, 4, 5]),
        password: 'correct-horse',
      );
      await expectLater(
        BackupCrypto.decrypt(package: sealed, password: 'wrong-password'),
        throwsA(isA<RestoreFailure>()),
      );
    });

    test('corrupt package fails', () async {
      final sealed = await BackupCrypto.encrypt(
        plaintext: Uint8List.fromList([1, 2, 3]),
        password: 'correct-horse',
      );
      sealed[sealed.length - 1] ^= 0xff;
      await expectLater(
        BackupCrypto.decrypt(package: sealed, password: 'correct-horse'),
        throwsA(isA<RestoreFailure>()),
      );
    });
  });

  group('backup service package', () {
    late AppDatabase db;
    late Directory root;
    late BackupService backups;

    setUp(() async {
      db = AppDatabase.memory();
      root = await Directory.systemTemp.createTemp('sd_s11_');
      final storage = FileStorageService(rootOverride: root);
      await storage.ensureBootstrapped();
      backups = BackupService(db: db, storage: storage);

      // Backup snapshot expects DB beside the file-storage root's parent.
      final dbFile = File(p.join(root.parent.path, 'shishur_dinlipi.sqlite'));
      await dbFile.writeAsBytes(List<int>.filled(256, 7));

      final now = DateTime.now().toUtc();
      await DriftChildrenRepository(db).save(
        Child(
          id: idGenerator.next(),
          name: 'Azwad',
          dateOfBirth: DateTime(2019, 1, 1),
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    tearDown(() async {
      await db.close();
      if (await root.exists()) await root.delete(recursive: true);
      final dbFile = File(p.join(root.parent.path, 'shishur_dinlipi.sqlite'));
      if (await dbFile.exists()) await dbFile.delete();
    });

    test('create encrypted backup and list history', () async {
      final result = await backups.createBackup(
        password: 'backup-pass-1',
        confirmPassword: 'backup-pass-1',
      );
      expect(result.fileName.endsWith('.sdjbackup'), isTrue);
      expect(File(result.absolutePath).existsSync(), isTrue);
      expect(result.manifest.childCount, 1);
      expect(result.manifest.childNames, contains('Azwad'));

      final history = await backups.listLocalHistory();
      expect(history, isNotEmpty);
    });

    test('password mismatch fails', () async {
      await expectLater(
        backups.createBackup(
          password: 'backup-pass-1',
          confirmPassword: 'other',
        ),
        throwsA(isA<BackupFailure>()),
      );
    });
  });
}
