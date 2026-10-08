import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/life/life_labels.dart';
import 'package:shishur_dinlipi/features/life/life_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class FamilyEventsListScreen extends ConsumerWidget {
  const FamilyEventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(familyEventsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.familyEventsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.familyEventCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addFamilyEvent),
      ),
      body: async.when(
        loading: () => AppStateViews.loading(),
        error: (e, _) => AppStateViews.error(
          message: '$e',
          onRetry: () => ref.invalidate(familyEventsListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppStateViews.empty(
              icon: Icons.family_restroom_outlined,
              title: l10n.familyEventEmpty,
              subtitle: l10n.familyEventEmptyHint,
              actionLabel: l10n.addFamilyEvent,
              onAction: () => context.push(AppRoutes.familyEventCreate),
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
                  leading: const Icon(Icons.celebration_outlined),
                  title: Text(item.title),
                  subtitle: Text(
                    [
                      familyEventTypeLabel(l10n, item.eventType),
                      MaterialLocalizations.of(context)
                          .formatMediumDate(item.eventDate),
                    ].join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.familyEventDetailPath(item.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
