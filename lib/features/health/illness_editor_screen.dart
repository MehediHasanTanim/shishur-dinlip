import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/doctor_visit.dart';
import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/health/widgets/symptom_selector.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class IllnessEditorScreen extends ConsumerStatefulWidget {
  const IllnessEditorScreen({super.key, this.illnessId});

  final String? illnessId;

  @override
  ConsumerState<IllnessEditorScreen> createState() =>
      _IllnessEditorScreenState();
}

class _IllnessEditorScreenState extends ConsumerState<IllnessEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _temperature;
  late final TextEditingController _diagnosis;
  late final TextEditingController _recovery;
  late final TextEditingController _notes;
  late final AttachmentDraftsController _attachments;

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  Set<String> _symptoms = {};
  String? _doctorVisitId;
  List<DoctorVisit> _visits = const [];
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController()..addListener(_markDirty);
    _temperature = TextEditingController()..addListener(_markDirty);
    _diagnosis = TextEditingController()..addListener(_markDirty);
    _recovery = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    _attachments = AttachmentDraftsController(
      attachments: ref.read(attachmentRepositoryProvider),
      storage: ref.read(fileStorageServiceProvider),
      permissions: ref.read(permissionServiceProvider),
    )..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child != null) {
      _visits = await ref
          .read(doctorVisitsRepositoryProvider)
          .forChild(child.id);
    }

    if (widget.illnessId != null) {
      final item = await ref
          .read(illnessEpisodesRepositoryProvider)
          .getById(widget.illnessId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _title.text = item.title;
        _startDate = item.startDate;
        _endDate = item.endDate;
        _symptoms = item.symptoms.toSet();
        _temperature.text = item.maxTemperatureC?.toString() ?? '';
        _diagnosis.text = item.diagnosis ?? '';
        _recovery.text = item.recoveryNote ?? '';
        _notes.text = item.notes ?? '';
        _doctorVisitId = item.doctorVisitId;
        await _attachments.loadExisting(
          entityType: EntityTypes.illnessEpisode,
          entityId: item.id,
        );
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
    _attachments
      ..removeListener(_markDirty)
      ..dispose();
    _title.dispose();
    _temperature.dispose();
    _diagnosis.dispose();
    _recovery.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFmt = MaterialLocalizations.of(context);
    final ongoing = _endDate == null;

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
            widget.illnessId == null ? l10n.addIllness : l10n.editIllness,
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
                      controller: _title,
                      decoration: InputDecoration(
                        labelText: l10n.illnessTitleField,
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.illnessTitleRequired
                          : null,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.illnessStartDate),
                      subtitle: Text(dateFmt.formatFullDate(_startDate)),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
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
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.illnessOngoing),
                      value: ongoing,
                      onChanged: (value) => setState(() {
                        if (value) {
                          _endDate = null;
                        } else {
                          _endDate = DateTime.now();
                        }
                        _dirty = true;
                      }),
                    ),
                    if (!ongoing) ...[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.illnessEndDate),
                        subtitle: Text(dateFmt.formatFullDate(_endDate!)),
                        trailing: const Icon(Icons.calendar_today_outlined),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate!,
                            firstDate: _startDate,
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
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
                      TextButton(
                        onPressed: () => setState(() {
                          _endDate = null;
                          _dirty = true;
                        }),
                        child: Text(l10n.illnessClearEndDate),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(l10n.illnessSymptoms),
                    const SizedBox(height: 8),
                    SymptomSelector(
                      selected: _symptoms,
                      onChanged: (next) => setState(() {
                        _symptoms = next;
                        _dirty = true;
                      }),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _temperature,
                      decoration: InputDecoration(
                        labelText: l10n.illnessTemperature,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _diagnosis,
                      decoration: InputDecoration(
                        labelText: l10n.illnessDiagnosis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _recovery,
                      decoration: InputDecoration(
                        labelText: l10n.illnessRecoveryNote,
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      // ignore: deprecated_member_use
                      value: _doctorVisitId,
                      decoration: InputDecoration(
                        labelText: l10n.illnessLinkedVisit,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(l10n.illnessNoLinkedVisit),
                        ),
                        for (final visit in _visits)
                          DropdownMenuItem(
                            value: visit.id,
                            child: Text(
                              '${visit.doctorName} · ${dateFmt.formatMediumDate(visit.visitDate)}',
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() {
                        _doctorVisitId = value;
                        _dirty = true;
                      }),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(labelText: l10n.commonNotes),
                      minLines: 2,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.illnessAttachmentsHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    AttachmentStrip(
                      controller: _attachments,
                      allowDocuments: true,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.saveIllness),
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
      final tempRaw = _temperature.text.trim();
      final temp = tempRaw.isEmpty ? null : double.tryParse(tempRaw);
      await ref.read(illnessEpisodesRepositoryProvider).save(
            episode: IllnessEpisode(
              id: _loadedId ?? '',
              childId: child.id,
              title: _title.text.trim(),
              startDate: _startDate,
              endDate: _endDate,
              symptoms: _symptoms.toList(),
              maxTemperatureC: temp,
              diagnosis: _diagnosis.text.trim().isEmpty
                  ? null
                  : _diagnosis.text.trim(),
              doctorVisitId: _doctorVisitId,
              recoveryNote: _recovery.text.trim().isEmpty
                  ? null
                  : _recovery.text.trim(),
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
            attachments: _attachments.drafts,
          );
      ref.invalidate(illnessEpisodesProvider);
      ref.invalidate(recentIllnessProvider);
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
