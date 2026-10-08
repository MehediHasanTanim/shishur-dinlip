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

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(tripDetailProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tripsTitle),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.tripEditPath(tripId)),
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
              icon: Icons.flight_takeoff_outlined,
              title: l10n.tripEmpty,
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(item.placeName),
              Text(tripTypeLabel(l10n, item.tripType)),
              Text(
                MaterialLocalizations.of(context)
                    .formatMediumDate(item.startDate),
              ),
              if (item.story != null) ...[
                const SizedBox(height: 16),
                Text(item.story!),
              ],
              if (item.childReaction != null) ...[
                const SizedBox(height: 12),
                Text('${l10n.tripReaction}: ${item.childReaction}'),
              ],
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final child = ref.read(selectedChildProvider).valueOrNull;
                    final album = await ref
                        .read(tripsRepositoryProvider)
                        .ensureTripAlbum(
                          item,
                          childName: child?.displayName,
                        );
                    ref.invalidate(tripDetailProvider(tripId));
                    if (!context.mounted) return;
                    AppStateViews.showSaveSuccess(
                      context,
                      l10n.tripAlbumReady,
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
                label: Text(l10n.tripAlbumCreate),
              ),
              TextButton(
                onPressed: () async {
                  final ok = await AppStateViews.confirmDelete(
                    context,
                    title: l10n.commonDelete,
                    message: item.title,
                  );
                  if (!ok) return;
                  await ref.read(tripsRepositoryProvider).softDelete(item.id);
                  ref.invalidate(tripsListProvider);
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
