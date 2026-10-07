import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/reminder_mapper.dart';
import 'package:shishur_dinlipi/core/notifications/notification_channels.dart';
import 'package:shishur_dinlipi/core/notifications/notification_id_store.dart';
import 'package:shishur_dinlipi/core/notifications/notification_service.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class RemindersRepository implements Repository {
  Future<List<Reminder>> list({String? childId, int? limit});
  Future<List<Reminder>> upcoming({DateTime? from, int? limit});
  Future<Reminder?> getById(String id);
  Future<Reminder> save(Reminder reminder, {bool scheduleNotification = true});
  Future<void> softDelete(String id);
  Future<void> setEnabled(String id, bool enabled);
  Future<void> rescheduleAll();
  Future<Reminder> ensureBirthdayReminder({
    required String childId,
    required DateTime dateOfBirth,
    required String childName,
  });
  Future<Reminder> ensureWeeklyMemoryPrompt({DateTime? nextAt});
  Future<Reminder> ensureBackupReminder({DateTime? nextAt});
  Future<Reminder> upsertLinked({
    required String reminderType,
    required String entityType,
    required String entityId,
    required String? childId,
    required DateTime scheduledAt,
    required String title,
    String? notes,
    String? repeatRule,
    bool enabled = true,
  });
}

class DriftRemindersRepository extends RepositoryBase
    implements RemindersRepository {
  DriftRemindersRepository(
    super.db, {
    required this.notifications,
    required this.idsStore,
    required this.permissions,
  });

  final NotificationService notifications;
  final NotificationIdStore idsStore;
  final PermissionService permissions;

  @override
  Future<List<Reminder>> list({String? childId, int? limit}) {
    return guard(() async {
      final rows = await db.remindersDao.forChild(childId, limit: limit);
      return rows.map(ReminderMapper.toDomain).toList();
    }, operation: 'reminders.list');
  }

  @override
  Future<List<Reminder>> upcoming({DateTime? from, int? limit}) {
    return guard(() async {
      final rows = await db.remindersDao.getEnabledUpcoming(
        from ?? DateTime.now(),
        limit: limit,
      );
      return rows.map(ReminderMapper.toDomain).toList();
    }, operation: 'reminders.upcoming');
  }

  @override
  Future<Reminder?> getById(String id) {
    return guard(() async {
      final row = await db.remindersDao.getById(id);
      return row == null ? null : ReminderMapper.toDomain(row);
    }, operation: 'reminders.getById');
  }

  @override
  Future<Reminder> save(
    Reminder reminder, {
    bool scheduleNotification = true,
  }) {
    return guard(() async {
      if (!ReminderTypes.all.contains(reminder.reminderType)) {
        throw const ValidationFailure(message: 'Invalid reminder type.');
      }
      final nowUtc = now();
      final id = reminder.id.isEmpty ? ids.next() : reminder.id;
      final existing = await db.remindersDao.getById(id);

      var notificationId = reminder.notificationId ?? existing?.notificationId;
      if (reminder.isEnabled &&
          scheduleNotification &&
          notificationId == null) {
        notificationId = await idsStore.nextId();
      }

      final toSave = reminder.copyWith(
        id: id,
        title: _trimOrNull(reminder.title),
        clearTitle: _trimOrNull(reminder.title) == null,
        notes: _trimOrNull(reminder.notes),
        clearNotes: _trimOrNull(reminder.notes) == null,
        repeatRule: reminder.repeatRule ?? ReminderRepeatRules.none,
        notificationId: notificationId,
        clearNotificationId: notificationId == null,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.remindersDao.upsert(ReminderMapper.toCompanion(toSave));

      if (scheduleNotification) {
        await _syncPlatform(toSave, previousNotificationId: existing?.notificationId);
      }
      return toSave;
    }, operation: 'reminders.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      final existing = await db.remindersDao.getById(id);
      if (existing?.notificationId != null) {
        await notifications.cancel(existing!.notificationId!);
      }
      await db.remindersDao.softDelete(id, now());
    }, operation: 'reminders.softDelete');
  }

  @override
  Future<void> setEnabled(String id, bool enabled) {
    return guard(() async {
      final existing = await getById(id);
      if (existing == null) return;
      await save(existing.copyWith(isEnabled: enabled, updatedAt: now()));
    }, operation: 'reminders.setEnabled');
  }

  @override
  Future<void> rescheduleAll() {
    return guard(() async {
      await notifications.configureTimeZone();
      final enabled = await db.remindersDao.allEnabled();
      for (final row in enabled) {
        await _syncPlatform(ReminderMapper.toDomain(row));
      }
      logger.info('Reminders rescheduled', {'count': enabled.length});
    }, operation: 'reminders.rescheduleAll');
  }

  @override
  Future<Reminder> ensureBirthdayReminder({
    required String childId,
    required DateTime dateOfBirth,
    required String childName,
  }) {
    return guard(() async {
      final existing = await db.remindersDao.findByType(
        reminderType: ReminderTypes.birthday,
        childId: childId,
      );
      final next = _nextYearlyOccurrence(dateOfBirth);
      final reminder = Reminder(
        id: existing?.id ?? '',
        childId: childId,
        reminderType: ReminderTypes.birthday,
        title: '$childName birthday',
        scheduledAt: next,
        repeatRule: ReminderRepeatRules.yearly,
        notificationId: existing?.notificationId,
        isEnabled: existing?.isEnabled ?? true,
        createdAt: existing?.createdAt ?? now(),
        updatedAt: now(),
      );
      return save(reminder);
    }, operation: 'reminders.ensureBirthday');
  }

  @override
  Future<Reminder> ensureWeeklyMemoryPrompt({DateTime? nextAt}) {
    return guard(() async {
      final existing = await db.remindersDao.findByType(
        reminderType: ReminderTypes.weeklyMemory,
      );
      final when = nextAt ?? _nextWeekday(DateTime.now(), DateTime.sunday, 10);
      final reminder = Reminder(
        id: existing?.id ?? '',
        reminderType: ReminderTypes.weeklyMemory,
        title: 'Weekly memory prompt',
        notes: 'Capture a memory this week.',
        scheduledAt: when,
        repeatRule: ReminderRepeatRules.weekly,
        notificationId: existing?.notificationId,
        isEnabled: existing?.isEnabled ?? true,
        createdAt: existing?.createdAt ?? now(),
        updatedAt: now(),
      );
      return save(reminder);
    }, operation: 'reminders.ensureWeekly');
  }

  @override
  Future<Reminder> ensureBackupReminder({DateTime? nextAt}) {
    return guard(() async {
      final existing = await db.remindersDao.findByType(
        reminderType: ReminderTypes.backup,
      );
      final when =
          nextAt ?? DateTime.now().add(const Duration(days: 30));
      final reminder = Reminder(
        id: existing?.id ?? '',
        reminderType: ReminderTypes.backup,
        title: 'Backup reminder',
        notes: 'Create a local backup of Shishur Dinlipi.',
        scheduledAt: DateTime(when.year, when.month, when.day, 19),
        repeatRule: ReminderRepeatRules.monthly,
        notificationId: existing?.notificationId,
        isEnabled: existing?.isEnabled ?? true,
        createdAt: existing?.createdAt ?? now(),
        updatedAt: now(),
      );
      return save(reminder);
    }, operation: 'reminders.ensureBackup');
  }

  @override
  Future<Reminder> upsertLinked({
    required String reminderType,
    required String entityType,
    required String entityId,
    required String? childId,
    required DateTime scheduledAt,
    required String title,
    String? notes,
    String? repeatRule,
    bool enabled = true,
  }) {
    return guard(() async {
      final existing = await db.remindersDao.findByEntity(
        reminderType: reminderType,
        entityType: entityType,
        entityId: entityId,
      );
      return save(
        Reminder(
          id: existing?.id ?? '',
          childId: childId,
          entityType: entityType,
          entityId: entityId,
          reminderType: reminderType,
          title: title,
          notes: notes,
          scheduledAt: scheduledAt,
          repeatRule: repeatRule ?? ReminderRepeatRules.none,
          notificationId: existing?.notificationId,
          isEnabled: enabled,
          createdAt: existing?.createdAt ?? now(),
          updatedAt: now(),
        ),
      );
    }, operation: 'reminders.upsertLinked');
  }

  Future<void> _syncPlatform(
    Reminder reminder, {
    int? previousNotificationId,
  }) async {
    final cancelId = previousNotificationId ?? reminder.notificationId;
    if (cancelId != null) {
      await notifications.cancel(cancelId);
    }
    if (!reminder.isEnabled || reminder.notificationId == null) return;

    final allowed = await permissions.ensure(AppPermission.notifications);
    if (!allowed) {
      logger.info('Notification permission denied; reminder kept offline', {
        'reminderId': reminder.id,
      });
      return;
    }

    await notifications.schedule(
      id: reminder.notificationId!,
      title: reminder.displayTitle,
      body: reminder.notes?.trim().isNotEmpty == true
          ? reminder.notes!.trim()
          : reminder.displayTitle,
      whenLocal: reminder.scheduledAt.toLocal(),
      channel: _channelFor(reminder.reminderType),
      repeatsDaily: reminder.repeatRule == ReminderRepeatRules.daily,
    );
  }

  AndroidNotificationChannel _channelFor(String type) {
    return switch (type) {
      ReminderTypes.vaccination => NotificationChannels.vaccination,
      ReminderTypes.medicine => NotificationChannels.medicine,
      ReminderTypes.doctorFollowUp => NotificationChannels.doctorFollowUp,
      ReminderTypes.birthday => NotificationChannels.birthday,
      ReminderTypes.weeklyMemory => NotificationChannels.memoryPrompt,
      ReminderTypes.backup => NotificationChannels.backup,
      _ => NotificationChannels.general,
    };
  }

  DateTime _nextYearlyOccurrence(DateTime dob) {
    final nowLocal = DateTime.now();
    var next = DateTime(nowLocal.year, dob.month, dob.day, 9);
    if (!next.isAfter(nowLocal)) {
      next = DateTime(nowLocal.year + 1, dob.month, dob.day, 9);
    }
    return next;
  }

  DateTime _nextWeekday(DateTime from, int weekday, int hour) {
    var candidate = DateTime(from.year, from.month, from.day, hour);
    while (candidate.weekday != weekday || !candidate.isAfter(from)) {
      candidate = candidate.add(const Duration(days: 1));
      candidate = DateTime(
        candidate.year,
        candidate.month,
        candidate.day,
        hour,
      );
    }
    return candidate;
  }

  String? _trimOrNull(String? value) {
    final t = value?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }
}
