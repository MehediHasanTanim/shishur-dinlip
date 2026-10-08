import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

String reminderTypeLabel(AppLocalizations l10n, String type) {
  return switch (type) {
    ReminderTypes.vaccination => l10n.reminderTypeVaccination,
    ReminderTypes.medicine => l10n.reminderTypeMedicine,
    ReminderTypes.doctorFollowUp => l10n.reminderTypeDoctorFollowUp,
    ReminderTypes.birthday => l10n.reminderTypeBirthday,
    ReminderTypes.weeklyMemory => l10n.reminderTypeWeeklyMemory,
    ReminderTypes.backup => l10n.reminderTypeBackup,
    ReminderTypes.custom => l10n.reminderTypeCustom,
    _ => type,
  };
}

String reminderRepeatLabel(AppLocalizations l10n, String? rule) {
  return switch (rule) {
    ReminderRepeatRules.daily => l10n.reminderRepeatDaily,
    ReminderRepeatRules.weekly => l10n.reminderRepeatWeekly,
    ReminderRepeatRules.yearly => l10n.reminderRepeatYearly,
    ReminderRepeatRules.monthly => l10n.reminderRepeatMonthly,
    ReminderRepeatRules.none || null => l10n.reminderRepeatNone,
    _ => l10n.reminderRepeatNone,
  };
}
