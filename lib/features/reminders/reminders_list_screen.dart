import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/features/reminders/reminder_labels.dart';
import 'package:shishur_dinlipi/features/reminders/reminders_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class RemindersListScreen extends ConsumerStatefulWidget {
  const RemindersListScreen({super.key});

  @override
  ConsumerState<RemindersListScreen> createState() =>
      _RemindersListScreenState();
}

class _RemindersListScreenState extends ConsumerState<RemindersListScreen> {
  bool _permissionPrompted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybePromptPermission());
  }

  Future<void> _maybePromptPermission() async {
    if (_permissionPrompted || !mounted) return;
    _permissionPrompted = true;
    final permissions = ref.read(permissionServiceProvider);
    final status = await permissions.status(AppPermission.notifications);
    if (!mounted) return;
    if (status == AppPermissionStatus.granted ||
        status == AppPermissionStatus.limited) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final allow = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.notificationPermissionTitle),
        content: Text(l10n.notificationPermissionBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.notificationNotNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.notificationAllow),
          ),
        ],
      ),
    );
    if (allow == true) {
      await permissions.ensure(AppPermission.notifications);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final listAsync = ref.watch(remindersListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.remindersTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.reminderCreate),
        child: const Icon(Icons.add),
      ),
      body: listAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (reminders) {
          if (reminders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.remindersEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final sections = _partition(reminders);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
            children: [
              if (sections.today.isNotEmpty) ...[
                _SectionHeader(label: _todayLabel()),
                for (final r in sections.today) _ReminderTile(reminder: r),
                const SizedBox(height: 12),
              ],
              if (sections.upcoming.isNotEmpty) ...[
                _SectionHeader(label: l10n.upcomingReminders),
                for (final r in sections.upcoming) _ReminderTile(reminder: r),
                const SizedBox(height: 12),
              ],
              if (sections.later.isNotEmpty) ...[
                _SectionHeader(label: _laterLabel()),
                for (final r in sections.later) _ReminderTile(reminder: r),
              ],
            ],
          );
        },
      ),
    );
  }

  String _todayLabel() {
    final bn = Localizations.localeOf(context).languageCode == 'bn';
    return bn ? 'আজ' : 'Today';
  }

  String _laterLabel() {
    final bn = Localizations.localeOf(context).languageCode == 'bn';
    return bn ? 'পরে' : 'Later';
  }

  _ReminderSections _partition(List<Reminder> reminders) {
    final now = DateTime.now();
    final startToday = DateTime(now.year, now.month, now.day);
    final endToday = startToday.add(const Duration(days: 1));
    final upcomingEnd = startToday.add(const Duration(days: 8));

    final today = <Reminder>[];
    final upcoming = <Reminder>[];
    final later = <Reminder>[];

    for (final r in reminders) {
      final at = r.scheduledAt.toLocal();
      if (at.isBefore(endToday)) {
        today.add(r);
      } else if (at.isBefore(upcomingEnd)) {
        upcoming.add(r);
      } else {
        later.add(r);
      }
    }

    int byTime(Reminder a, Reminder b) =>
        a.scheduledAt.compareTo(b.scheduledAt);
    today.sort(byTime);
    upcoming.sort(byTime);
    later.sort(byTime);
    return _ReminderSections(today: today, upcoming: upcoming, later: later);
  }
}

class _ReminderSections {
  const _ReminderSections({
    required this.today,
    required this.upcoming,
    required this.later,
  });

  final List<Reminder> today;
  final List<Reminder> upcoming;
  final List<Reminder> later;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFmt = MaterialLocalizations.of(context);
    final local = reminder.scheduledAt.toLocal();
    final time = TimeOfDay.fromDateTime(local);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: Icon(
            reminder.isEnabled
                ? Icons.notifications_active_outlined
                : Icons.notifications_off_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(reminder.displayTitle),
          subtitle: Text(
            [
              reminderTypeLabel(l10n, reminder.reminderType),
              dateFmt.formatMediumDate(local),
              time.format(context),
            ].join(' · '),
          ),
          trailing: reminder.isEnabled
              ? null
              : Icon(
                  Icons.pause_circle_outline,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          onTap: () => context.push(AppRoutes.reminderDetailPath(reminder.id)),
        ),
      ),
    );
  }
}
