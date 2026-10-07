import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/domain/approximate_date.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/milestone.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/development/milestones_overview_screen.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MilestoneDetailScreen extends ConsumerStatefulWidget {
  const MilestoneDetailScreen({super.key, required this.milestoneId});

  final String milestoneId;

  @override
  ConsumerState<MilestoneDetailScreen> createState() =>
      _MilestoneDetailScreenState();
}

class _MilestoneDetailScreenState extends ConsumerState<MilestoneDetailScreen> {
  late final AttachmentDraftsController _attachments;
  Milestone? _item;
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
        .read(milestonesRepositoryProvider)
        .getById(widget.milestoneId);
    if (item != null) {
      await _attachments.loadExisting(
        entityType: EntityTypes.milestone,
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
    final child = ref.watch(selectedChildProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn =
        ref.watch(settingsControllerProvider).valueOrNull?.useBengaliDigits ??
        false;

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

    final age = child == null || item.eventDate == null
        ? null
        : AgeFormatter.format(
            age: AgeCalculator.atEvent(
              dateOfBirth: child.dateOfBirth,
              eventDate: item.eventDate!,
            ),
            bangla: bangla,
            useBengaliDigits: useBn,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.milestoneEditPath(item.id));
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
          Text(
            ApproximateDateFormatter.format(
              date: item.eventDate,
              precision: item.datePrecision,
              bangla: bangla,
              useBengaliDigits: useBn,
            ),
          ),
          if (age != null) ...[
            const SizedBox(height: 4),
            Text(age, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 12),
          Chip(label: Text(_categoryLabel(l10n, item.category))),
          if (item.description != null) ...[
            const SizedBox(height: 16),
            Text(item.description!),
          ],
          if (item.locationText != null) ...[
            const SizedBox(height: 12),
            Text('${l10n.memoryLocation}: ${item.locationText}'),
          ],
          if (item.peoplePresent != null) ...[
            const SizedBox(height: 8),
            Text('${l10n.peoplePresent}: ${item.peoplePresent}'),
          ],
          const SizedBox(height: 16),
          AttachmentStrip(controller: _attachments, enabled: false),
        ],
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      MilestoneCategories.movement => l10n.milestoneMovement,
      MilestoneCategories.speech => l10n.milestoneSpeech,
      MilestoneCategories.social => l10n.milestoneSocial,
      MilestoneCategories.selfCare => l10n.milestoneSelfCare,
      MilestoneCategories.learning => l10n.milestoneLearning,
      MilestoneCategories.custom => l10n.milestoneCustom,
      _ => category,
    };
  }

  Future<void> _delete(Milestone item) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMilestoneTitle),
        content: Text(l10n.deleteMilestoneMessage),
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
      await ref.read(milestonesRepositoryProvider).softDelete(item.id);
      ref.invalidate(recentMilestonesProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}
