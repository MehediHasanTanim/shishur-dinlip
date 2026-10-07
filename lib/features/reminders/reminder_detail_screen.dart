import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/reminders/reminder_labels.dart';
import 'package:shishur_dinlipi/features/reminders/reminders_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class ReminderDetailScreen extends ConsumerStatefulWidget {
  const ReminderDetailScreen({super.key, required this.reminderId});

  final String reminderId;

  @override
  ConsumerState<ReminderDetailScreen> createState() =>
      _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends ConsumerState<ReminderDetailScreen> {
  Reminder? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final item = await ref
        .read(remindersRepositoryProvider)
        .getById(widget.reminderId);
    if (mounted) {
      setState(() {
        _item = item;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final item = _item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    final dateFmt = MaterialLocalizations.of(context);
    final local = item.scheduledAt.toLocal();
    final time = TimeOfDay.fromDateTime(local);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.displayTitle),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.reminderEditPath(item.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _delete(item),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DetailRow(
            label: l10n.reminderType,
            value: reminderTypeLabel(l10n, item.reminderType),
          ),
          _DetailRow(
            label: l10n.reminderDateTime,
            value: '${dateFmt.formatFullDate(local)} · ${time.format(context)}',
          ),
          _DetailRow(
            label: l10n.reminderRepeat,
            value: reminderRepeatLabel(l10n, item.repeatRule),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.reminderEnabled),
            value: item.isEnabled,
            onChanged: (value) => _toggle(item, value),
          ),
          if (item.notes != null && item.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.commonNotes,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(item.notes!),
          ],
        ],
      ),
    );
  }

  Future<void> _toggle(Reminder item, bool enabled) async {
    try {
      await ref.read(remindersRepositoryProvider).setEnabled(item.id, enabled);
      ref.invalidate(remindersListProvider);
      ref.invalidate(upcomingRemindersProvider);
      await _load();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }

  Future<void> _delete(Reminder item) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteReminderTitle),
        content: Text(l10n.deleteReminderMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(remindersRepositoryProvider).softDelete(item.id);
      ref.invalidate(remindersListProvider);
      ref.invalidate(upcomingRemindersProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
