import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Android notification channels used by Shishur Dinlipi.
abstract final class NotificationChannels {
  static const vaccination = AndroidNotificationChannel(
    'vaccinations',
    'Vaccinations',
    description: 'Vaccination schedule reminders',
    importance: Importance.high,
  );

  static const medicine = AndroidNotificationChannel(
    'medicines',
    'Medicines',
    description: 'Medicine dose reminders',
    importance: Importance.high,
  );

  static const doctorFollowUp = AndroidNotificationChannel(
    'doctor_followup',
    'Doctor follow-ups',
    description: 'Doctor visit follow-up reminders',
    importance: Importance.defaultImportance,
  );

  static const birthday = AndroidNotificationChannel(
    'birthdays',
    'Birthdays',
    description: 'Birthday and celebration reminders',
    importance: Importance.defaultImportance,
  );

  static const memoryPrompt = AndroidNotificationChannel(
    'memory_prompts',
    'Memory prompts',
    description: 'Gentle prompts to capture memories',
    importance: Importance.low,
  );

  static const backup = AndroidNotificationChannel(
    'backup_reminders',
    'Backup reminders',
    description: 'Reminders to create a local backup',
    importance: Importance.defaultImportance,
  );

  static const general = AndroidNotificationChannel(
    'general',
    'General',
    description: 'General app notifications',
    importance: Importance.defaultImportance,
  );

  static List<AndroidNotificationChannel> get all => [
    vaccination,
    medicine,
    doctorFollowUp,
    birthday,
    memoryPrompt,
    backup,
    general,
  ];
}
