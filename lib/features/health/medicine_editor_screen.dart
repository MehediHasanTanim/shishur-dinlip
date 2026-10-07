import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MedicineEditorScreen extends ConsumerStatefulWidget {
  const MedicineEditorScreen({super.key, this.medicineId});

  final String? medicineId;

  @override
  ConsumerState<MedicineEditorScreen> createState() =>
      _MedicineEditorScreenState();
}

class _MedicineEditorScreenState extends ConsumerState<MedicineEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _strength;
  late final TextEditingController _dose;
  late final TextEditingController _frequency;
  late final TextEditingController _reason;
  late final TextEditingController _prescriber;
  late final TextEditingController _notes;

  String _status = MedicineStatuses.active;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<TextEditingController> _scheduleTimes = [];
  final List<String> _scheduleIds = [];
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController()..addListener(_markDirty);
    _strength = TextEditingController()..addListener(_markDirty);
    _dose = TextEditingController()..addListener(_markDirty);
    _frequency = TextEditingController()..addListener(_markDirty);
    _reason = TextEditingController()..addListener(_markDirty);
    _prescriber = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.medicineId != null) {
      final item = await ref
          .read(medicinesRepositoryProvider)
          .getById(widget.medicineId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _name.text = item.name;
        _strength.text = item.strength ?? '';
        _dose.text = item.dosage ?? '';
        _frequency.text = item.frequencyText ?? '';
        _reason.text = item.reason ?? '';
        _prescriber.text = item.prescribedBy ?? '';
        _notes.text = item.notes ?? '';
        _status = item.status;
        _startDate = item.startDate;
        _endDate = item.endDate;
        for (final schedule in item.schedules) {
          _scheduleIds.add(schedule.id);
          _scheduleTimes.add(
            TextEditingController(text: schedule.timeOfDay)
              ..addListener(_markDirty),
          );
        }
      }
    }
    if (mounted) {
      setState(() {
        _loading = false;
        _dirty = false;
      });
    }
  }

  void _addScheduleTime() {
    setState(() {
      _scheduleIds.add('');
      _scheduleTimes.add(TextEditingController(text: '08:00')..addListener(_markDirty));
      _dirty = true;
    });
  }

  @override
  void dispose() {
    for (final c in _scheduleTimes) {
      c.dispose();
    }
    _name.dispose();
    _strength.dispose();
    _dose.dispose();
    _frequency.dispose();
    _reason.dispose();
    _prescriber.dispose();
    _notes.dispose();
    super.dispose();
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
          title: Text(
            widget.medicineId == null ? l10n.addMedicine : l10n.editMedicine,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(labelText: l10n.medicineName),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.medicineNameRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _strength,
                      decoration: InputDecoration(
                        labelText: l10n.medicineStrength,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dose,
                      decoration: InputDecoration(labelText: l10n.medicineDose),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _frequency,
                      decoration: InputDecoration(
                        labelText: l10n.medicineFrequency,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.medicineStatus),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final status in MedicineStatuses.all)
                          ChoiceChip(
                            label: Text(medicineStatusLabel(l10n, status)),
                            selected: _status == status,
                            onSelected: (_) => setState(() {
                              _status = status;
                              _dirty = true;
                            }),
                          ),
                      ],
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.medicineStartDate),
                      subtitle: Text(
                        _startDate == null
                            ? l10n.commonNone
                            : dateFmt.formatFullDate(_startDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 2),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _startDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.medicineEndDate),
                      subtitle: Text(
                        _endDate == null
                            ? l10n.commonNone
                            : dateFmt.formatFullDate(_endDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 2),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _endDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _reason,
                      decoration: InputDecoration(
                        labelText: l10n.medicineReason,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _prescriber,
                      decoration: InputDecoration(
                        labelText: l10n.medicinePrescriber,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.medicineSchedule,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < _scheduleTimes.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _scheduleTimes[i],
                                decoration: const InputDecoration(
                                  hintText: 'HH:mm',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                _scheduleTimes[i].dispose();
                                _scheduleTimes.removeAt(i);
                                _scheduleIds.removeAt(i);
                                _dirty = true;
                              }),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    TextButton.icon(
                      onPressed: _addScheduleTime,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.medicineAddScheduleTime),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(labelText: l10n.commonNotes),
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
              child: Text(l10n.saveMedicine),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;

    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final schedules = <MedicineSchedule>[];
      for (var i = 0; i < _scheduleTimes.length; i++) {
        final time = _scheduleTimes[i].text.trim();
        if (time.isEmpty) continue;
        schedules.add(
          MedicineSchedule(
            id: _scheduleIds[i],
            medicineId: _loadedId ?? '',
            timeOfDay: time,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      await ref.read(medicinesRepositoryProvider).save(
            Medicine(
              id: _loadedId ?? '',
              childId: child.id,
              name: _name.text.trim(),
              strength: _strength.text.trim().isEmpty
                  ? null
                  : _strength.text.trim(),
              dosage: _dose.text.trim().isEmpty ? null : _dose.text.trim(),
              frequencyText: _frequency.text.trim().isEmpty
                  ? null
                  : _frequency.text.trim(),
              startDate: _startDate,
              endDate: _endDate,
              reason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
              prescribedBy: _prescriber.text.trim().isEmpty
                  ? null
                  : _prescriber.text.trim(),
              status: _status,
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              schedules: schedules,
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(medicinesProvider);
      ref.invalidate(activeMedicinesProvider);
      ref.invalidate(healthSummaryProvider);
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
}
