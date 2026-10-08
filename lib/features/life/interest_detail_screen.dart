import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/features/life/life_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class InterestDetailScreen extends ConsumerWidget {
  const InterestDetailScreen({super.key, required this.interestId});

  final String interestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(interestDetailProvider(interestId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.interestsTitle),
        actions: [
          IconButton(
            onPressed: () =>
                context.push(AppRoutes.interestEditPath(interestId)),
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
              icon: Icons.interests_outlined,
              title: l10n.interestEmpty,
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
              if (item.interestLevel != null) ...[
                const SizedBox(height: 8),
                Text(l10n.interestLevelLabel(item.interestLevel!)),
              ],
              if (item.firstNoticed != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${l10n.interestFirstNoticed}: ${MaterialLocalizations.of(context).formatMediumDate(item.firstNoticed!)}',
                ),
              ],
              if (item.notes != null) ...[
                const SizedBox(height: 16),
                Text(item.notes!),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () async {
                  final ok = await AppStateViews.confirmDelete(
                    context,
                    title: l10n.commonDelete,
                    message: item.name,
                  );
                  if (!ok) return;
                  await ref
                      .read(interestsRepositoryProvider)
                      .softDelete(item.id);
                  ref.invalidate(interestsListProvider);
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
