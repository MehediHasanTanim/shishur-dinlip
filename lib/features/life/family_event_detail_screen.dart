import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/life/life_labels.dart';
import 'package:shishur_dinlipi/features/life/life_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class FamilyEventDetailScreen extends ConsumerWidget {
  const FamilyEventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(familyEventDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.familyEventsTitle),
        actions: [
          IconButton(
            onPressed: () =>
                context.push(AppRoutes.familyEventEditPath(eventId)),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: async.when(
        loading: () => AppStateViews.loading(),
        error: (e, _) => AppStateViews.error(message: '$e'),
        data: (item) {
          if (item == null) {
            return AppStateViews.empty(
              icon: Icons.family_restroom_outlined,
              title: l10n.familyEventEmpty,
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(familyEventTypeLabel(l10n, item.eventType)),
              Text(
                MaterialLocalizations.of(context).formatFullDate(item.eventDate),
              ),
              if (item.locationText != null) ...[
                const SizedBox(height: 8),
                Text(item.locationText!),
              ],
              if (item.story != null) ...[
                const SizedBox(height: 16),
                Text(item.story!),
              ],
              if (item.childReaction != null) ...[
                const SizedBox(height: 12),
                Text(
                  '${l10n.familyEventReaction}: ${item.childReaction}',
                ),
              ],
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final child = ref.read(selectedChildProvider).valueOrNull;
                    final album = await ref
                        .read(familyEventsRepositoryProvider)
                        .ensureFamilyEventAlbum(
                          item,
                          childName: child?.displayName,
                        );
                    ref.invalidate(familyEventDetailProvider(eventId));
                    if (!context.mounted) return;
                    AppStateViews.showSaveSuccess(
                      context,
                      l10n.familyEventAlbumReady,
                    );
                    context.push(AppRoutes.albumDetailPath(album.id));
                  } catch (e) {
                    if (!context.mounted) return;
                    AppStateViews.showSaveFailure(
                      context,
                      ErrorMapper.localize(context, e),
                    );
                  }
                },
                icon: const Icon(Icons.photo_album_outlined),
                label: Text(l10n.familyEventAlbumCreate),
              ),
              TextButton(
                onPressed: () async {
                  final ok = await AppStateViews.confirmDelete(
                    context,
                    title: l10n.commonDelete,
                    message: item.title,
                  );
                  if (!ok) return;
                  await ref
                      .read(familyEventsRepositoryProvider)
                      .softDelete(item.id);
                  ref.invalidate(familyEventsListProvider);
                  ref.invalidate(homeLifeCardsProvider);
                  if (context.mounted) context.pop();
                },
                child: Text(l10n.commonDelete),
              ),
            ],
          );
        },
      ),
    );
  }
}
