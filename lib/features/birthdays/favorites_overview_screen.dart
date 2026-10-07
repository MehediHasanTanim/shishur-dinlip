import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_labels.dart';
import 'package:shishur_dinlipi/features/birthdays/birthdays_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class FavoritesOverviewScreen extends ConsumerWidget {
  const FavoritesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(favoritesGroupedProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.favoriteCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addFavorite),
      ),
      body: async.when(
        loading: () => AppStateViews.loading(),
        error: (e, _) => AppStateViews.error(
          message: '$e',
          onRetry: () => ref.invalidate(favoritesGroupedProvider),
        ),
        data: (grouped) {
          final hasAny = grouped.values.any((list) => list.isNotEmpty);
          if (!hasAny) {
            return AppStateViews.empty(
              icon: Icons.favorite_outline,
              title: l10n.favoriteEmpty,
              subtitle: l10n.favoriteEmptyHint,
              actionLabel: l10n.addFavorite,
              onAction: () => context.push(AppRoutes.favoriteCreate),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            children: [
              for (final category in FavoriteCategories.all) ...[
                Text(
                  favoriteCategoryLabel(l10n, category),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ..._categoryCards(context, l10n, grouped[category] ?? const []),
                const SizedBox(height: 20),
              ],
            ],
          );
        },
      ),
    );
  }

  List<Widget> _categoryCards(
    BuildContext context,
    AppLocalizations l10n,
    List<Favorite> items,
  ) {
    if (items.isEmpty) {
      return [
        Text(
          l10n.favoriteEmpty,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ];
    }
    final current = items.where((f) => f.isCurrent).toList();
    final history = items.where((f) => !f.isCurrent).toList();
    return [
      for (final f in current)
        Card(
          child: ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(f.value),
            subtitle: Text(
              [
                l10n.favoriteCurrent,
                if (f.recordedAge != null)
                  '${l10n.birthdayAge} ${f.recordedAge}',
              ].join(' · '),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.favoriteEditPath(f.id)),
          ),
        ),
      if (history.isNotEmpty) ...[
        const SizedBox(height: 4),
        Text(
          l10n.favoriteHistory,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        for (final f in history)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(f.value),
            subtitle: Text(
              [
                if (f.recordedAge != null)
                  '${l10n.birthdayAge} ${f.recordedAge}',
                if (f.startDate != null)
                  MaterialLocalizations.of(context)
                      .formatMediumDate(f.startDate!),
              ].join(' · '),
            ),
            onTap: () => context.push(AppRoutes.favoriteEditPath(f.id)),
          ),
      ],
    ];
  }
}
