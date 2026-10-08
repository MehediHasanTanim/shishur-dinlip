import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';

/// Lock-screen-safe notification titles/bodies (no Flutter l10n dependency).
abstract final class NotificationPrivacyCopy {
  static ({String title, String body}) resolve({
    required Reminder reminder,
    required bool privacyMode,
    required AppLanguage language,
  }) {
    final bn = language == AppLanguage.bangla;
    if (privacyMode) {
      final generic = _generic(reminder.reminderType, bn: bn);
      return (title: generic, body: generic);
    }

    final title = reminder.displayTitle.trim().isEmpty
        ? _generic(reminder.reminderType, bn: bn)
        : reminder.displayTitle;
    final notes = reminder.notes?.trim();
    final body = (notes != null && notes.isNotEmpty) ? notes : title;
    return (title: title, body: body);
  }

  static String _generic(String type, {required bool bn}) {
    return switch (type) {
      ReminderTypes.vaccination =>
        bn ? 'টিকা অনুস্মারক' : 'Vaccination reminder',
      ReminderTypes.medicine => bn ? 'ওষুধের অনুস্মারক' : 'Medicine reminder',
      ReminderTypes.doctorFollowUp =>
        bn ? 'ডাক্তার ফলো-আপ' : 'Doctor follow-up',
      ReminderTypes.birthday => bn ? 'জন্মদিনের অনুস্মারক' : 'Birthday reminder',
      ReminderTypes.weeklyMemory =>
        bn ? 'সাপ্তাহিক স্মৃতি প্রম্পট' : 'Weekly memory prompt',
      ReminderTypes.backup => bn ? 'ব্যাকআপ অনুস্মারক' : 'Backup reminder',
      _ => bn ? 'অনুস্মারক' : 'Reminder',
    };
  }

  static String systemBirthdayTitle({required bool bn}) =>
      bn ? 'জন্মদিনের অনুস্মারক' : 'Birthday reminder';

  static String systemWeeklyTitle({required bool bn}) =>
      bn ? 'সাপ্তাহিক স্মৃতি প্রম্পট' : 'Weekly memory prompt';

  static String systemWeeklyNotes({required bool bn}) => bn
      ? 'এই সপ্তাহে একটি স্মৃতি লিখে রাখুন।'
      : 'Capture a memory this week.';

  static String systemBackupTitle({required bool bn}) =>
      bn ? 'ব্যাকআপ অনুস্মারক' : 'Backup reminder';

  static String systemBackupNotes({required bool bn}) => bn
      ? 'শিশুর দিনলিপির একটি স্থানীয় ব্যাকআপ তৈরি করুন।'
      : 'Create a local backup of Shishur Dinlipi.';
}
