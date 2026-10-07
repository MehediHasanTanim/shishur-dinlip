import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/doctor_visit.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class DoctorVisitEditorScreen extends ConsumerStatefulWidget {
  const DoctorVisitEditorScreen({super.key, this.visitId});

  final String? visitId;

  @override
  ConsumerState<DoctorVisitEditorScreen> createState() =>
      _DoctorVisitEditorScreenState();
}

class _DoctorVisitEditorScreenState
    extends ConsumerState<DoctorVisitEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _doctorName;
  late final TextEditingController _specialty;
  late final TextEditingController _hospital;
  late final TextEditingController _reason;
  late final TextEditingController _symptoms;
  late final TextEditingController _diagnosis;
  late final TextEditingController _tests;
  late final TextEditingController _notes;
  late final AttachmentDraftsController _attachments;

  DateTime _visitDate = DateTime.now();
  DateTime? _followUpDate;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _doctorName = TextEditingController()..addListener(_markDirty);
    _specialty = TextEditingController()..addListener(_markDirty);
    _hospital = TextEditingController()..addListener(_markDirty);
    _reason = TextEditingController()..addListener(_markDirty);
    _symptoms = TextEditingController()..addListener(_markDirty);
    _diagnosis = TextEditingController()..addListener(_markDirty);
    _tests = TextEditingController()..addListener(_markDirty);
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
    if (widget.visitId != null) {
      final item = await ref
          .read(doctorVisitsRepositoryProvider)
          .getById(widget.visitId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _doctorName.text = item.doctorName;
        _specialty.text = item.specialty ?? '';
        _hospital.text = item.hospitalOrChamber ?? '';
        _reason.text = item.reason ?? '';
        _symptoms.text = item.symptoms ?? '';
        _diagnosis.text = item.diagnosis ?? '';
        _tests.text = item.testsAdvised ?? '';
        _notes.text = item.notes ?? '';
        _visitDate = item.visitDate;
        _followUpDate = item.followUpDate;
        await _attachments.loadExisting(
          entityType: EntityTypes.doctorVisit,
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
    _doctorName.dispose();
    _specialty.dispose();
    _hospital.dispose();
    _reason.dispose();
    _symptoms.dispose();
    _diagnosis.dispose();
    _tests.dispose();
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
            widget.visitId == null
                ? l10n.addDoctorVisit
                : l10n.editDoctorVisit,
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
                      controller: _doctorName,
                      decoration: InputDecoration(labelText: l10n.doctorName),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.doctorNameRequired
                          : null,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.memoryDate),
                      subtitle: Text(dateFmt.formatFullDate(_visitDate)),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _visitDate,
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _visitDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _specialty,
                      decoration: InputDecoration(
                        labelText: l10n.doctorSpecialty,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _hospital,
                      decoration: InputDecoration(
                        labelText: l10n.doctorHospital,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _reason,
                      decoration: InputDecoration(labelText: l10n.doctorReason),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _symptoms,
                      decoration: InputDecoration(
                        labelText: l10n.doctorSymptoms,
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _diagnosis,
                      decoration: InputDecoration(
                        labelText: l10n.doctorDiagnosis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tests,
                      decoration: InputDecoration(labelText: l10n.doctorTests),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.doctorFollowUp),
                      subtitle: Text(
                        _followUpDate == null
                            ? l10n.commonNone
                            : dateFmt.formatFullDate(_followUpDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _followUpDate ?? DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 2),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _followUpDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(labelText: l10n.commonNotes),
                      minLines: 2,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.doctorAttachmentsHint,
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
              child: Text(l10n.saveDoctorVisit),
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
      await ref.read(doctorVisitsRepositoryProvider).save(
            visit: DoctorVisit(
              id: _loadedId ?? '',
              childId: child.id,
              visitDate: _visitDate,
              doctorName: _doctorName.text.trim(),
              specialty: _specialty.text.trim().isEmpty
                  ? null
                  : _specialty.text.trim(),
              hospitalOrChamber: _hospital.text.trim().isEmpty
                  ? null
                  : _hospital.text.trim(),
              reason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
              symptoms: _symptoms.text.trim().isEmpty
                  ? null
                  : _symptoms.text.trim(),
              diagnosis: _diagnosis.text.trim().isEmpty
                  ? null
                  : _diagnosis.text.trim(),
              testsAdvised: _tests.text.trim().isEmpty
                  ? null
                  : _tests.text.trim(),
              followUpDate: _followUpDate,
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
            attachments: _attachments.drafts,
          );
      ref.invalidate(doctorVisitsProvider);
      ref.invalidate(latestDoctorVisitProvider);
      ref.invalidate(upcomingFollowUpsProvider);
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
