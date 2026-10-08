import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/life/life_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class InterestsListScreen extends ConsumerWidget {
  const InterestsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(interestsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.interestsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.interestCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addInterest),
      ),
      body: async.when(
        loading: () => AppStateViews.loading(),
        error: (e, _) => AppStateViews.error(
          message: '$e',
          onRetry: () => ref.invalidate(interestsListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppStateViews.empty(
              icon: Icons.interests_outlined,
              title: l10n.interestEmpty,
              subtitle: l10n.interestEmptyHint,
              actionLabel: l10n.addInterest,
              onAction: () => context.push(AppRoutes.interestCreate),
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
                  leading: CircleAvatar(
                    child: Text('${item.interestLevel ?? '·'}'),
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    [
                      if (item.interestLevel != null)
                        l10n.interestLevelLabel(item.interestLevel!),
                      if (item.notes != null && item.notes!.isNotEmpty)
                        item.notes!,
                    ].join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.interestDetailPath(item.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
