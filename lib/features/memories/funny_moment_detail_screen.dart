import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/funny_moment.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/recent_memories_provider.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class FunnyMomentDetailScreen extends ConsumerStatefulWidget {
  const FunnyMomentDetailScreen({super.key, required this.momentId});

  final String momentId;

  @override
  ConsumerState<FunnyMomentDetailScreen> createState() =>
      _FunnyMomentDetailScreenState();
}

class _FunnyMomentDetailScreenState
    extends ConsumerState<FunnyMomentDetailScreen> {
  late final AttachmentDraftsController _attachments;
  FunnyMoment? _moment;
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
    final moment = await ref
        .read(funnyMomentsRepositoryProvider)
        .getById(widget.momentId);
    if (moment != null) {
      await _attachments.loadExisting(
        entityType: EntityTypes.funnyMoment,
        entityId: moment.id,
      );
    }
    if (mounted) {
      setState(() {
        _moment = moment;
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
    final moment = _moment;
    if (moment == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(moment.displayTitle),
        actions: [
          IconButton(
            onPressed: () async {
              final next = !moment.isFavorite;
              await ref
                  .read(funnyMomentsRepositoryProvider)
                  .setFavorite(moment.id, next);
              ref.invalidate(recentMemoriesProvider);
              setState(() => _moment = moment.copyWith(isFavorite: next));
            },
            icon: Icon(
              moment.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
          IconButton(
            tooltip: l10n.quoteCardTitle,
            onPressed: () =>
                context.push(AppRoutes.funnyQuoteCardPath(moment.id)),
            icon: const Icon(Icons.format_quote_outlined),
          ),
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.funnyEditPath(moment.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _delete(moment),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            MaterialLocalizations.of(context).formatFullDate(moment.eventDate),
          ),
          if (moment.quoteText != null) ...[
            const SizedBox(height: 16),
            Text(
              '"${moment.quoteText}"',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () =>
                  context.push(AppRoutes.funnyQuoteCardPath(moment.id)),
              icon: const Icon(Icons.style_outlined),
              label: Text(l10n.quoteCardTitle),
            ),
          ],
          if (moment.story != null) ...[
            const SizedBox(height: 12),
            Text(moment.story!),
          ],
          if (moment.peoplePresent != null) ...[
            const SizedBox(height: 12),
            Text('${l10n.peoplePresent}: ${moment.peoplePresent}'),
          ],
          const SizedBox(height: 16),
          AttachmentStrip(controller: _attachments, enabled: false),
        ],
      ),
    );
  }

  Future<void> _delete(FunnyMoment moment) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteFunnyTitle),
        content: Text(l10n.deleteFunnyMessage),
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
      await ref.read(funnyMomentsRepositoryProvider).softDelete(moment.id);
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
