import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/birthdays/birthdays_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class BirthdaysListScreen extends ConsumerWidget {
  const BirthdaysListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(birthdaysListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.birthdaysTitle),
        actions: [
          IconButton(
            tooltip: l10n.birthdayCompareTitle,
            onPressed: () => context.push(AppRoutes.birthdayCompare),
            icon: const Icon(Icons.compare_arrows_outlined),
          ),
          IconButton(
            tooltip: l10n.favoritesTitle,
            onPressed: () => context.push(AppRoutes.favorites),
            icon: const Icon(Icons.favorite_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.birthdayCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addBirthday),
      ),
      body: async.when(
        loading: () => AppStateViews.loading(),
        error: (e, _) => AppStateViews.error(
          message: '$e',
          onRetry: () => ref.invalidate(birthdaysListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppStateViews.empty(
              icon: Icons.cake_outlined,
              title: l10n.birthdayEmpty,
              subtitle: l10n.birthdayEmptyHint,
              actionLabel: l10n.addBirthday,
              onAction: () => context.push(AppRoutes.birthdayCreate),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final b = items[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text('${b.age}'),
                  ),
                  title: Text('${l10n.birthdayAge} ${b.age}'),
                  subtitle: Text(
                    [
                      if (b.theme != null && b.theme!.isNotEmpty) b.theme!,
                      if (b.favoriteGift != null && b.favoriteGift!.isNotEmpty)
                        b.favoriteGift!,
                      if (b.answers.isNotEmpty)
                        '${b.answers.length} ${l10n.birthdayInterview}',
                    ].join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.birthdayDetailPath(b.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
