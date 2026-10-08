import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/core/notifications/notification_id_store.dart';
import 'package:shishur_dinlipi/core/notifications/notification_privacy_copy.dart';
import 'package:shishur_dinlipi/core/notifications/notification_service.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/core/repository/reminders_repository.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_keys.dart';
import 'package:shishur_dinlipi/core/settings/settings_repository.dart';

class _AllowedPermissions extends PermissionService {
  @override
  Future<bool> ensure(AppPermission permission) async => true;
}

class _CapturingNotifications extends NotificationService {
  final scheduled = <({String title, String body, bool privacyMode})>[];

  @override
  Future<void> initialize({bool requestIosPermissions = false}) async {}

  @override
  Future<void> configureTimeZone() async {}

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime whenLocal,
    required AndroidNotificationChannel channel,
    bool repeatsDaily = false,
    bool privacyMode = true,
  }) async {
    scheduled.add((title: title, body: body, privacyMode: privacyMode));
  }
}

void main() {
  group('NotificationPrivacyCopy', () {
    final medicine = Reminder(
      id: '1',
      reminderType: ReminderTypes.medicine,
      title: 'Azwad — Paracetamol 5ml',
      notes: 'Give after food. Diagnosis: fever',
      scheduledAt: DateTime.now().add(const Duration(hours: 1)),
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    test('privacy ON redacts title and body to generic medicine copy', () {
      final en = NotificationPrivacyCopy.resolve(
        reminder: medicine,
        privacyMode: true,
        language: AppLanguage.english,
      );
      expect(en.title, 'Medicine reminder');
      expect(en.body, 'Medicine reminder');
      expect(en.title, isNot(contains('Azwad')));
      expect(en.body, isNot(contains('Paracetamol')));
      expect(en.body, isNot(contains('fever')));

      final bn = NotificationPrivacyCopy.resolve(
        reminder: medicine,
        privacyMode: true,
        language: AppLanguage.bangla,
      );
      expect(bn.title, 'ওষুধের অনুস্মারক');
      expect(bn.body, bn.title);
    });

    test('privacy OFF keeps custom title and notes', () {
      final copy = NotificationPrivacyCopy.resolve(
        reminder: medicine,
        privacyMode: false,
        language: AppLanguage.english,
      );
      expect(copy.title, 'Azwad — Paracetamol 5ml');
      expect(copy.body, 'Give after food. Diagnosis: fever');
    });
  });

  group('settings + schedule integration', () {
    late AppDatabase db;
    late SettingsRepository settings;
    late _CapturingNotifications notifications;
    late DriftRemindersRepository reminders;

    setUp(() async {
      db = AppDatabase.memory();
      settings = SettingsRepository(db);
      notifications = _CapturingNotifications();
      reminders = DriftRemindersRepository(
        db,
        notifications: notifications,
        idsStore: NotificationIdStore(db),
        permissions: _AllowedPermissions(),
        settings: settings,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('notificationPrivacyMode defaults to ON when unset', () async {
      final loaded = await settings.load();
      expect(loaded.notificationPrivacyMode, isTrue);
    });

    test('toggle persists and schedules use redacted copy when ON', () async {
      await settings.save(
        const AppSettings(notificationPrivacyMode: true),
      );
      final reloaded = await settings.load();
      expect(reloaded.notificationPrivacyMode, isTrue);
      expect(
        (await db.settingsDao.getAll())[SettingsKeys.notificationPrivacyMode],
        'true',
      );

      await reminders.save(
        Reminder(
          id: '',
          reminderType: ReminderTypes.medicine,
          title: 'Azwad — Amoxicillin',
          notes: '2.5ml twice daily',
          scheduledAt: DateTime.now().add(const Duration(days: 1)),
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );

      expect(notifications.scheduled, isNotEmpty);
      final last = notifications.scheduled.last;
      expect(last.privacyMode, isTrue);
      expect(last.title, 'Medicine reminder');
      expect(last.body, 'Medicine reminder');
    });

    test('privacy OFF schedules detailed title and notes', () async {
      await settings.save(
        const AppSettings(notificationPrivacyMode: false),
      );

      await reminders.save(
        Reminder(
          id: '',
          reminderType: ReminderTypes.medicine,
          title: 'Azwad — Amoxicillin',
          notes: '2.5ml twice daily',
          scheduledAt: DateTime.now().add(const Duration(days: 1)),
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
      );

      final last = notifications.scheduled.last;
      expect(last.privacyMode, isFalse);
      expect(last.title, 'Azwad — Amoxicillin');
      expect(last.body, '2.5ml twice daily');
    });

    test('birthday ensure never persists child name in title', () async {
      final bday = await reminders.ensureBirthdayReminder(
        childId: 'child-1',
        dateOfBirth: DateTime(2018, 3, 15),
        childName: 'Azwad',
      );
      expect(bday.title, isNot(contains('Azwad')));
      expect(bday.title, 'Birthday reminder');
    });
  });
}
