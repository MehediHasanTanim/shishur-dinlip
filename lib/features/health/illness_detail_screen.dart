import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class IllnessDetailScreen extends ConsumerStatefulWidget {
  const IllnessDetailScreen({super.key, required this.illnessId});

  final String illnessId;

  @override
  ConsumerState<IllnessDetailScreen> createState() =>
      _IllnessDetailScreenState();
}

class _IllnessDetailScreenState extends ConsumerState<IllnessDetailScreen> {
  late final AttachmentDraftsController _attachments;
  IllnessEpisode? _item;
  String? _linkedVisitName;
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
        .read(illnessEpisodesRepositoryProvider)
        .getById(widget.illnessId);
    String? visitName;
    if (item?.doctorVisitId != null) {
      final visit = await ref
          .read(doctorVisitsRepositoryProvider)
          .getById(item!.doctorVisitId!);
      visitName = visit?.doctorName;
    }
    if (item != null) {
      await _attachments.loadExisting(
        entityType: EntityTypes.illnessEpisode,
        entityId: item.id,
      );
    }
    if (mounted) {
      setState(() {
        _item = item;
        _linkedVisitName = visitName;
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
        title: Text(item.title),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.illnessEditPath(item.id));
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
          if (item.isOngoing)
            Chip(label: Text(l10n.illnessOngoing))
          else
            const SizedBox.shrink(),
          const SizedBox(height: 8),
          _DetailRow(
            label: l10n.illnessStartDate,
            value: dateFmt.formatFullDate(item.startDate),
          ),
          if (item.endDate != null)
            _DetailRow(
              label: l10n.illnessEndDate,
              value: dateFmt.formatFullDate(item.endDate!),
            ),
          if (item.symptoms.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.illnessSymptoms,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in item.symptoms)
                  Chip(label: Text(illnessSymptomLabel(l10n, s))),
              ],
            ),
          ],
          if (item.maxTemperatureC != null)
            _DetailRow(
              label: l10n.illnessTemperature,
              value: '${item.maxTemperatureC} °C',
            ),
          if (item.diagnosis != null)
            _DetailRow(label: l10n.illnessDiagnosis, value: item.diagnosis!),
          if (item.recoveryNote != null)
            _DetailRow(
              label: l10n.illnessRecoveryNote,
              value: item.recoveryNote!,
            ),
          _DetailRow(
            label: l10n.illnessLinkedVisit,
            value: _linkedVisitName ?? l10n.illnessNoLinkedVisit,
          ),
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

  Future<void> _delete(IllnessEpisode item) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteIllnessTitle),
        content: Text(l10n.deleteIllnessMessage),
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
      await ref.read(illnessEpisodesRepositoryProvider).softDelete(item.id);
      ref.invalidate(illnessEpisodesProvider);
      ref.invalidate(recentIllnessProvider);
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
