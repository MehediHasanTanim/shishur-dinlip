import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/core/notifications/notification_id_store.dart';
import 'package:shishur_dinlipi/core/notifications/notification_service.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/reminders_repository.dart';

class _DeniedPermissions extends PermissionService {
  @override
  Future<bool> ensure(AppPermission permission) async => false;
}

class _AllowedPermissions extends PermissionService {
  @override
  Future<bool> ensure(AppPermission permission) async => true;
}

class _FakeNotifications extends NotificationService {
  final cancelled = <int>[];
  final scheduled = <int>[];
  var configureCalls = 0;

  @override
  Future<void> initialize({bool requestIosPermissions = false}) async {}

  @override
  Future<void> configureTimeZone() async {
    configureCalls++;
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime whenLocal,
    required AndroidNotificationChannel channel,
    bool repeatsDaily = false,
  }) async {
    scheduled.add(id);
  }
}

void main() {
  late AppDatabase db;
  late DriftRemindersRepository reminders;
  late _FakeNotifications notifications;
  late String childId;

  setUp(() async {
    db = AppDatabase.memory();
    notifications = _FakeNotifications();
    reminders = DriftRemindersRepository(
      db,
      notifications: notifications,
      idsStore: NotificationIdStore(db),
      permissions: _DeniedPermissions(),
    );

    final now = DateTime.now().toUtc();
    final child = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2018, 3, 15),
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;
  });

  tearDown(() async {
    await db.close();
  });

  test('permission denied still saves reminder offline', () async {
    final saved = await reminders.save(
      Reminder(
        id: '',
        childId: childId,
        reminderType: ReminderTypes.custom,
        title: 'Check temperature',
        scheduledAt: DateTime.now().add(const Duration(hours: 2)),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    expect(saved.id, isNotEmpty);
    expect(saved.notificationId, isNotNull);
    expect(notifications.scheduled, isEmpty);
    expect(await reminders.getById(saved.id), isNotNull);
  });

  test('reschedule refreshes timezone and schedules when allowed', () async {
    final allowed = DriftRemindersRepository(
      db,
      notifications: notifications,
      idsStore: NotificationIdStore(db),
      permissions: _AllowedPermissions(),
    );
    final saved = await allowed.save(
      Reminder(
        id: '',
        reminderType: ReminderTypes.backup,
        title: 'Backup',
        scheduledAt: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    expect(notifications.scheduled, contains(saved.notificationId));

    notifications.scheduled.clear();
    notifications.cancelled.clear();
    await allowed.rescheduleAll();
    expect(notifications.configureCalls, greaterThan(0));
    expect(notifications.cancelled, isNotEmpty);
    expect(notifications.scheduled, contains(saved.notificationId));

    await allowed.setEnabled(saved.id, false);
    expect((await allowed.getById(saved.id))!.isEnabled, isFalse);
  });

  test('birthday and weekly prompts upsert; child switch lists scope', () async {
    final bday = await reminders.ensureBirthdayReminder(
      childId: childId,
      dateOfBirth: DateTime(2018, 3, 15),
      childName: 'Azwad',
    );
    expect(bday.reminderType, ReminderTypes.birthday);
    expect(bday.repeatRule, ReminderRepeatRules.yearly);

    final again = await reminders.ensureBirthdayReminder(
      childId: childId,
      dateOfBirth: DateTime(2018, 3, 15),
      childName: 'Azwad',
    );
    expect(again.id, bday.id);

    await reminders.ensureWeeklyMemoryPrompt();
    await reminders.ensureBackupReminder();

    final list = await reminders.list(childId: childId);
    expect(list.any((r) => r.reminderType == ReminderTypes.birthday), isTrue);
    expect(
      list.any((r) => r.reminderType == ReminderTypes.weeklyMemory),
      isTrue,
    );

    final otherChild = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Other',
        dateOfBirth: DateTime(2020, 1, 1),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await reminders.ensureBirthdayReminder(
      childId: otherChild.id,
      dateOfBirth: DateTime(2020, 1, 1),
      childName: 'Other',
    );
    final forFirst = await reminders.list(childId: childId);
    expect(
      forFirst.where((r) => r.reminderType == ReminderTypes.birthday).length,
      1,
    );
  });

  test('linked doctor follow-up upsert and soft delete cancels', () async {
    final linked = await reminders.upsertLinked(
      reminderType: ReminderTypes.doctorFollowUp,
      entityType: 'doctor_visit',
      entityId: 'visit-1',
      childId: childId,
      scheduledAt: DateTime.now().add(const Duration(days: 7)),
      title: 'Follow-up with Dr. Rahman',
    );
    final again = await reminders.upsertLinked(
      reminderType: ReminderTypes.doctorFollowUp,
      entityType: 'doctor_visit',
      entityId: 'visit-1',
      childId: childId,
      scheduledAt: DateTime.now().add(const Duration(days: 10)),
      title: 'Follow-up moved',
    );
    expect(again.id, linked.id);
    expect(again.title, 'Follow-up moved');

    await reminders.softDelete(again.id);
    expect(await reminders.getById(again.id), isNull);
    expect(notifications.cancelled, contains(again.notificationId));
  });
}
