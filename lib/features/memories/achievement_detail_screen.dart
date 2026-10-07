import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/achievement.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/recent_memories_provider.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AchievementDetailScreen extends ConsumerStatefulWidget {
  const AchievementDetailScreen({super.key, required this.achievementId});

  final String achievementId;

  @override
  ConsumerState<AchievementDetailScreen> createState() =>
      _AchievementDetailScreenState();
}

class _AchievementDetailScreenState
    extends ConsumerState<AchievementDetailScreen> {
  late final AttachmentDraftsController _attachments;
  Achievement? _item;
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
        .read(achievementsRepositoryProvider)
        .getById(widget.achievementId);
    if (item != null) {
      await _attachments.loadExisting(
        entityType: EntityTypes.achievement,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            onPressed: () async {
              final next = !item.isFavorite;
              await ref
                  .read(achievementsRepositoryProvider)
                  .setFavorite(item.id, next);
              ref.invalidate(recentMemoriesProvider);
              setState(() => _item = item.copyWith(isFavorite: next));
            },
            icon: Icon(
              item.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.achievementEditPath(item.id));
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
            MaterialLocalizations.of(context).formatFullDate(item.eventDate),
          ),
          const SizedBox(height: 8),
          Chip(label: Text(item.category)),
          if (item.description != null) ...[
            const SizedBox(height: 16),
            Text(item.description!),
          ],
          const SizedBox(height: 16),
          AttachmentStrip(controller: _attachments, enabled: false),
        ],
      ),
    );
  }

  Future<void> _delete(Achievement item) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAchievementTitle),
        content: Text(l10n.deleteAchievementMessage),
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
      await ref.read(achievementsRepositoryProvider).softDelete(item.id);
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
