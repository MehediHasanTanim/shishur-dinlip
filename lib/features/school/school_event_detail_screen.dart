import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/school_event.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/school/school_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class SchoolEventDetailScreen extends ConsumerStatefulWidget {
  const SchoolEventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<SchoolEventDetailScreen> createState() =>
      _SchoolEventDetailScreenState();
}

class _SchoolEventDetailScreenState
    extends ConsumerState<SchoolEventDetailScreen> {
  late final AttachmentDraftsController _attachments;
  SchoolEvent? _event;
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
    final event = await ref
        .read(schoolEventsRepositoryProvider)
        .getById(widget.eventId);
    if (event != null) {
      await _attachments.loadExisting(
        entityType: EntityTypes.schoolEvent,
        entityId: event.id,
      );
    }
    if (mounted) {
      setState(() {
        _event = event;
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
    final event = _event;
    if (event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.schoolEventEditPath(event.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _delete(event),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Chip(label: Text(_typeLabel(l10n, event.eventType))),
          const SizedBox(height: 8),
          Text(
            MaterialLocalizations.of(context).formatFullDate(event.eventDate),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (event.description != null) ...[
            const SizedBox(height: 16),
            Text(event.description!),
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

  String _typeLabel(AppLocalizations l10n, String type) {
    return switch (type) {
      SchoolEventTypes.firstDay => l10n.schoolEventFirstDay,
      SchoolEventTypes.exam => l10n.schoolEventExam,
      SchoolEventTypes.performance => l10n.schoolEventPerformance,
      SchoolEventTypes.sports => l10n.schoolEventSports,
      SchoolEventTypes.certificate => l10n.schoolEventCertificate,
      SchoolEventTypes.classPromotion => l10n.schoolEventPromotion,
      SchoolEventTypes.project => l10n.schoolEventProject,
      SchoolEventTypes.reportCard => l10n.schoolEventReportCard,
      _ => l10n.schoolEventCustom,
    };
  }

  Future<void> _delete(SchoolEvent event) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSchoolEventTitle),
        content: Text(l10n.deleteSchoolEventMessage),
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
      await ref.read(schoolEventsRepositoryProvider).softDelete(event.id);
      ref.invalidate(schoolTimelineProvider);
      ref.invalidate(recentSchoolEventProvider);
      ref.invalidate(upcomingSchoolEventsProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}
