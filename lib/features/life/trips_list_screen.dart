import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/life/life_labels.dart';
import 'package:shishur_dinlipi/features/life/life_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class TripsListScreen extends ConsumerWidget {
  const TripsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(tripsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tripsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.tripCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addTrip),
      ),
      body: async.when(
        loading: () => AppStateViews.loading(),
        error: (e, _) => AppStateViews.error(
          message: '$e',
          onRetry: () => ref.invalidate(tripsListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppStateViews.empty(
              icon: Icons.flight_takeoff_outlined,
              title: l10n.tripEmpty,
              subtitle: l10n.tripEmptyHint,
              actionLabel: l10n.addTrip,
              onAction: () => context.push(AppRoutes.tripCreate),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: Text(item.title),
                  subtitle: Text(
                    [
                      item.placeName,
                      tripTypeLabel(l10n, item.tripType),
                    ].join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.tripDetailPath(item.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
