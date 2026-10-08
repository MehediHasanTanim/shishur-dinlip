import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/allergy.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/health/allergy_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AllergyEditorScreen extends ConsumerStatefulWidget {
  const AllergyEditorScreen({super.key, this.allergyId});

  final String? allergyId;

  @override
  ConsumerState<AllergyEditorScreen> createState() =>
      _AllergyEditorScreenState();
}

class _AllergyEditorScreenState extends ConsumerState<AllergyEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _allergen;
  late final TextEditingController _reaction;
  late final TextEditingController _notes;

  String _type = AllergyTypes.food;
  String _severity = AllergySeverities.unknown;
  DateTime? _firstObserved;
  bool _doctorConfirmed = false;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _allergen = TextEditingController()..addListener(_markDirty);
    _reaction = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.allergyId != null) {
      final item = await ref
          .read(allergiesRepositoryProvider)
          .getById(widget.allergyId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _allergen.text = item.allergen;
        _reaction.text = item.reaction ?? '';
        _notes.text = item.notes ?? '';
        _type = item.allergyType;
        _severity = item.severity;
        _firstObserved = item.firstObserved;
        _doctorConfirmed = item.doctorConfirmed;
      }
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
    _allergen.dispose();
    _reaction.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;

    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final saved = await ref.read(allergiesRepositoryProvider).save(
        Allergy(
          id: _loadedId ?? '',
          childId: child.id,
          allergen: _allergen.text,
          allergyType: _type,
          reaction: _reaction.text,
          severity: _severity,
          firstObserved: _firstObserved,
          doctorConfirmed: _doctorConfirmed,
          notes: _notes.text,
          createdAt: _createdAt ?? now,
          updatedAt: now,
        ),
      );
      ref.invalidate(allergiesProvider);
      ref.invalidate(healthSummaryProvider);
      if (!mounted) return;
      setState(() => _dirty = false);
      context.pop(saved.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _firstObserved ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _firstObserved = picked;
        _dirty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFmt = MaterialLocalizations.of(context);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: !_dirty || _saving,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await confirmDiscardIfDirty(
          context,
          isDirty: _dirty && !_saving,
        );
        if (ok && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.allergyId == null ? l10n.allergyAdd : l10n.allergyEdit,
          ),
          actions: [
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.commonSave),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            children: [
              TextFormField(
                controller: _allergen,
                decoration: InputDecoration(
                  labelText: l10n.allergyAllergen,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.errorGeneric : null,
              ),
              const SizedBox(height: 16),
              Text(l10n.allergyType, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AllergyTypes.all.map((type) {
                  return ChoiceChip(
                    label: Text(allergyTypeLabel(l10n, type)),
                    selected: _type == type,
                    onSelected: (_) {
                      setState(() {
                        _type = type;
                        _dirty = true;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.allergySeverity,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AllergySeverities.all.map((severity) {
                  return ChoiceChip(
                    label: Text(allergySeverityLabel(l10n, severity)),
                    selected: _severity == severity,
                    onSelected: (_) {
                      setState(() {
                        _severity = severity;
                        _dirty = true;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reaction,
                decoration: InputDecoration(
                  labelText: l10n.allergyReaction,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.allergyFirstObserved),
                subtitle: Text(
                  _firstObserved == null
                      ? l10n.commonNone
                      : dateFmt.formatMediumDate(_firstObserved!),
                ),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _pickDate,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.allergyDoctorConfirmed),
                value: _doctorConfirmed,
                onChanged: (v) {
                  setState(() {
                    _doctorConfirmed = v;
                    _dirty = true;
                  });
                },
              ),
              TextFormField(
                controller: _notes,
                decoration: InputDecoration(
                  labelText: l10n.allergyNotes,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
