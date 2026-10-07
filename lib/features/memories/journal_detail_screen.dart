import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/journal_entry.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/recent_memories_provider.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class JournalDetailScreen extends ConsumerStatefulWidget {
  const JournalDetailScreen({super.key, required this.entryId});

  final String entryId;

  @override
  ConsumerState<JournalDetailScreen> createState() =>
      _JournalDetailScreenState();
}

class _JournalDetailScreenState extends ConsumerState<JournalDetailScreen> {
  late final AttachmentDraftsController _attachments;
  JournalEntry? _entry;
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
    final entry = await ref
        .read(journalRepositoryProvider)
        .getById(widget.entryId);
    if (entry != null) {
      await _attachments.loadExisting(
        entityType: EntityTypes.journalEntry,
        entityId: entry.id,
      );
    }
    if (mounted) {
      setState(() {
        _entry = entry;
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

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final entry = _entry;
    if (entry == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    final age = child == null
        ? null
        : AgeFormatter.format(
            age: AgeCalculator.atEvent(
              dateOfBirth: child.dateOfBirth,
              eventDate: entry.eventDate,
            ),
            bangla: Localizations.localeOf(context).languageCode == 'bn',
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.displayTitle),
        actions: [
          IconButton(
            tooltip: l10n.favorite,
            onPressed: () => _toggleFavorite(entry),
            icon: Icon(
              entry.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
          IconButton(
            tooltip: l10n.commonEdit,
            onPressed: () async {
              await context.push(AppRoutes.journalEditPath(entry.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: l10n.commonDelete,
            onPressed: () => _confirmDelete(entry),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            MaterialLocalizations.of(context).formatFullDate(entry.eventDate),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          if (age != null) ...[
            const SizedBox(height: 4),
            Text(
              age,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          if (entry.title != null && entry.title!.trim().isNotEmpty)
            Text(
              entry.title!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (entry.body.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(entry.body, style: Theme.of(context).textTheme.bodyLarge),
          ],
          if (entry.mood != null) ...[
            const SizedBox(height: 16),
            Text('${l10n.memoryMood}: ${entry.mood}'),
          ],
          if (entry.locationText != null) ...[
            const SizedBox(height: 8),
            Text('${l10n.memoryLocation}: ${entry.locationText}'),
          ],
          if (entry.tagNames.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final tag in entry.tagNames) Chip(label: Text(tag)),
              ],
            ),
          ],
          const SizedBox(height: 16),
          AttachmentStrip(controller: _attachments, enabled: false),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(JournalEntry entry) async {
    final next = !entry.isFavorite;
    await ref.read(journalRepositoryProvider).setFavorite(entry.id, next);
    ref.invalidate(recentMemoriesProvider);
    setState(() => _entry = entry.copyWith(isFavorite: next));
  }

  Future<void> _confirmDelete(JournalEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMemoryTitle),
        content: Text(l10n.deleteMemoryMessage),
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
      await ref.read(journalRepositoryProvider).softDelete(entry.id);
      ref.invalidate(recentMemoriesProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}
