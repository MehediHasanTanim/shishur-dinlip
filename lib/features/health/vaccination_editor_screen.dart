import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class VaccinationEditorScreen extends ConsumerStatefulWidget {
  const VaccinationEditorScreen({super.key, this.vaccinationId});

  final String? vaccinationId;

  @override
  ConsumerState<VaccinationEditorScreen> createState() =>
      _VaccinationEditorScreenState();
}

class _VaccinationEditorScreenState
    extends ConsumerState<VaccinationEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _dose;
  late final TextEditingController _provider;
  late final TextEditingController _clinic;
  late final TextEditingController _batch;
  late final TextEditingController _notes;
  late final AttachmentDraftsController _attachments;

  String _status = VaccinationStatuses.upcoming;
  DateTime? _scheduledDate;
  DateTime? _givenDate;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController()..addListener(_markDirty);
    _dose = TextEditingController()..addListener(_markDirty);
    _provider = TextEditingController()..addListener(_markDirty);
    _clinic = TextEditingController()..addListener(_markDirty);
    _batch = TextEditingController()..addListener(_markDirty);
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
    if (widget.vaccinationId != null) {
      final item = await ref
          .read(vaccinationsRepositoryProvider)
          .getById(widget.vaccinationId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _name.text = item.vaccineName;
        _dose.text = item.doseLabel ?? '';
        _provider.text = item.providerName ?? '';
        _clinic.text = item.clinicName ?? '';
        _batch.text = item.batchNumber ?? '';
        _notes.text = item.notes ?? '';
        _status = item.status;
        _scheduledDate = item.scheduledDate;
        _givenDate = item.givenDate;
        await _attachments.loadExisting(
          entityType: EntityTypes.vaccination,
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
    _name.dispose();
    _dose.dispose();
    _provider.dispose();
    _clinic.dispose();
    _batch.dispose();
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
            widget.vaccinationId == null
                ? l10n.addVaccination
                : l10n.editVaccination,
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
                      decoration: InputDecoration(labelText: l10n.vaccineName),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.vaccineNameRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dose,
                      decoration: InputDecoration(labelText: l10n.vaccineDose),
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.vaccineStatus),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final status in VaccinationStatuses.all)
                          ChoiceChip(
                            label: Text(vaccinationStatusLabel(l10n, status)),
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
                      title: Text(l10n.vaccineScheduledDate),
                      subtitle: Text(
                        _scheduledDate == null
                            ? l10n.commonNone
                            : dateFmt.formatFullDate(_scheduledDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _scheduledDate ?? DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 5),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _scheduledDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.vaccineGivenDate),
                      subtitle: Text(
                        _givenDate == null
                            ? l10n.commonNone
                            : dateFmt.formatFullDate(_givenDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _givenDate ?? DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _givenDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _provider,
                      decoration: InputDecoration(
                        labelText: l10n.vaccineProvider,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _clinic,
                      decoration: InputDecoration(
                        labelText: l10n.vaccineClinic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _batch,
                      decoration: InputDecoration(
                        labelText: l10n.vaccineBatch,
                      ),
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
                      l10n.vaccineAttachmentsHint,
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
              child: Text(l10n.saveVaccination),
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
      await ref.read(vaccinationsRepositoryProvider).save(
            vaccination: Vaccination(
              id: _loadedId ?? '',
              childId: child.id,
              vaccineName: _name.text.trim(),
              doseLabel: _dose.text.trim().isEmpty ? null : _dose.text.trim(),
              scheduledDate: _scheduledDate,
              givenDate: _givenDate,
              status: _status,
              providerName: _provider.text.trim().isEmpty
                  ? null
                  : _provider.text.trim(),
              clinicName: _clinic.text.trim().isEmpty
                  ? null
                  : _clinic.text.trim(),
              batchNumber: _batch.text.trim().isEmpty
                  ? null
                  : _batch.text.trim(),
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
            attachments: _attachments.drafts,
          );
      ref.invalidate(vaccinationsProvider);
      ref.invalidate(upcomingVaccinationsProvider);
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
