import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/reminder.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/features/reminders/reminder_labels.dart';
import 'package:shishur_dinlipi/features/reminders/reminders_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class ReminderEditorScreen extends ConsumerStatefulWidget {
  const ReminderEditorScreen({super.key, this.reminderId});

  final String? reminderId;

  @override
  ConsumerState<ReminderEditorScreen> createState() =>
      _ReminderEditorScreenState();
}

class _ReminderEditorScreenState extends ConsumerState<ReminderEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _notes;

  String _type = ReminderTypes.custom;
  DateTime _scheduledDate = DateTime.now();
  TimeOfDay _scheduledTime = TimeOfDay.now();
  String _repeat = ReminderRepeatRules.none;
  bool _enabled = true;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;
  int? _notificationId;
  String? _childId;
  String? _entityType;
  String? _entityId;

  bool get _isEditing => widget.reminderId != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.reminderId != null) {
      final item = await ref
          .read(remindersRepositoryProvider)
          .getById(widget.reminderId!);
      if (item != null && mounted) {
        final local = item.scheduledAt.toLocal();
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _notificationId = item.notificationId;
        _childId = item.childId;
        _entityType = item.entityType;
        _entityId = item.entityId;
        _title.text = item.title ?? '';
        _notes.text = item.notes ?? '';
        _type = item.reminderType;
        _scheduledDate = DateTime(local.year, local.month, local.day);
        _scheduledTime = TimeOfDay.fromDateTime(local);
        _repeat = item.repeatRule ?? ReminderRepeatRules.none;
        _enabled = item.isEnabled;
      }
    } else {
      final now = DateTime.now();
      _scheduledDate = DateTime(now.year, now.month, now.day);
      _scheduledTime = TimeOfDay(hour: now.hour, minute: (now.minute ~/ 5) * 5);
      _childId = ref.read(selectedChildProvider).valueOrNull?.id;
    }
    if (mounted) {
      setState(() {
        _loading = false;
        _dirty = false;
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  DateTime get _combinedScheduledAt {
    return DateTime(
      _scheduledDate.year,
      _scheduledDate.month,
      _scheduledDate.day,
      _scheduledTime.hour,
      _scheduledTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFmt = MaterialLocalizations.of(context);

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await confirmDiscardIfDirty(context, isDirty: _dirty);
        if (ok && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? l10n.editReminder : l10n.addReminder),
          actions: [
            if (_isEditing)
              IconButton(
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.commonDelete,
              ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    Text(l10n.reminderType),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final type in ReminderTypes.all)
                          ChoiceChip(
                            label: Text(reminderTypeLabel(l10n, type)),
                            selected: _type == type,
                            onSelected: (_) => setState(() {
                              _type = type;
                              _dirty = true;
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(
                        labelText: l10n.reminderTitleField,
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.reminderTitleRequired
                          : null,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.reminderDateTime),
                      subtitle: Text(
                        '${dateFmt.formatFullDate(_scheduledDate)} · ${_scheduledTime.format(context)}',
                      ),
                      trailing: const Icon(Icons.event_outlined),
                      onTap: _pickDateTime,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: _repeat,
                      decoration: InputDecoration(
                        labelText: l10n.reminderRepeat,
                      ),
                      items: [
                        for (final rule in const [
                          ReminderRepeatRules.none,
                          ReminderRepeatRules.daily,
                          ReminderRepeatRules.weekly,
                          ReminderRepeatRules.monthly,
                          ReminderRepeatRules.yearly,
                        ])
                          DropdownMenuItem(
                            value: rule,
                            child: Text(reminderRepeatLabel(l10n, rule)),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _repeat = value;
                          _dirty = true;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.reminderEnabled),
                      value: _enabled,
                      onChanged: (value) => setState(() {
                        _enabled = value;
                        _dirty = true;
                      }),
                    ),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(
                        labelText: l10n.reminderNotes,
                      ),
                      minLines: 2,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.saveReminder),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: _scheduledTime,
    );
    if (!mounted) return;
    setState(() {
      _scheduledDate = DateTime(date.year, date.month, date.day);
      if (time != null) _scheduledTime = time;
      _dirty = true;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      await ref.read(remindersRepositoryProvider).save(
            Reminder(
              id: _loadedId ?? '',
              childId: _childId,
              entityType: _entityType,
              entityId: _entityId,
              reminderType: _type,
              title: _title.text.trim(),
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              scheduledAt: _combinedScheduledAt,
              repeatRule: _repeat,
              notificationId: _notificationId,
              isEnabled: _enabled,
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(remindersListProvider);
      ref.invalidate(upcomingRemindersProvider);
      if (mounted) {
        setState(() => _dirty = false);
        context.pop();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final id = _loadedId;
    if (id == null) return;
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
      await ref.read(remindersRepositoryProvider).softDelete(id);
      ref.invalidate(remindersListProvider);
      ref.invalidate(upcomingRemindersProvider);
      if (mounted) {
        setState(() => _dirty = false);
        context.pop();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}
