import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class VaccinationDetailScreen extends ConsumerStatefulWidget {
  const VaccinationDetailScreen({super.key, required this.vaccinationId});

  final String vaccinationId;

  @override
  ConsumerState<VaccinationDetailScreen> createState() =>
      _VaccinationDetailScreenState();
}

class _VaccinationDetailScreenState
    extends ConsumerState<VaccinationDetailScreen> {
  late final AttachmentDraftsController _attachments;
  Vaccination? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _attachments = AttachmentDraftsController(
      attachments: ref.read(attachmentRepositoryProvider),
      storage: ref.read(fileStorageServiceProvider),
      permissions: ref.read(permissionServiceProvider),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final item = await ref
        .read(vaccinationsRepositoryProvider)
        .getById(widget.vaccinationId);
    if (item != null) {
      await _attachments.loadExisting(
        entityType: EntityTypes.vaccination,
        entityId: item.id,
      );
    }
    if (mounted) {
      setState(() {
        _item = item;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _attachments.dispose();
    super.dispose();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(item.vaccineName),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.vaccinationEditPath(item.id));
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
          Chip(label: Text(vaccinationStatusLabel(l10n, item.status))),
          const SizedBox(height: 12),
          if (item.doseLabel != null)
            _DetailRow(label: l10n.vaccineDose, value: item.doseLabel!),
          if (item.scheduledDate != null)
            _DetailRow(
              label: l10n.vaccineScheduledDate,
              value: dateFmt.formatFullDate(item.scheduledDate!),
            ),
          if (item.givenDate != null)
            _DetailRow(
              label: l10n.vaccineGivenDate,
              value: dateFmt.formatFullDate(item.givenDate!),
            ),
          if (item.providerName != null)
            _DetailRow(label: l10n.vaccineProvider, value: item.providerName!),
          if (item.clinicName != null)
            _DetailRow(label: l10n.vaccineClinic, value: item.clinicName!),
          if (item.batchNumber != null)
            _DetailRow(label: l10n.vaccineBatch, value: item.batchNumber!),
          if (item.notes != null) ...[
            const SizedBox(height: 8),
            Text(l10n.commonNotes, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(item.notes!),
          ],
          const SizedBox(height: 16),
          AttachmentStrip(
            controller: _attachments,
            enabled: false,
            allowDocuments: true,
          ),
        ],
      ),
    );
  }

  Future<void> _delete(Vaccination item) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteVaccinationTitle),
        content: Text(l10n.deleteVaccinationMessage),
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
      await ref.read(vaccinationsRepositoryProvider).softDelete(item.id);
      ref.invalidate(vaccinationsProvider);
      ref.invalidate(upcomingVaccinationsProvider);
      ref.invalidate(healthSummaryProvider);
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
