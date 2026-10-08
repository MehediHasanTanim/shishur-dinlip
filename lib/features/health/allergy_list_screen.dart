import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/health/allergy_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AllergyListScreen extends ConsumerWidget {
  const AllergyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(allergiesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.allergiesTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.allergyCreate),
        child: const Icon(Icons.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.allergiesEmpty),
                    const SizedBox(height: 8),
                    Text(
                      l10n.allergiesEmptyHint,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item.allergen),
                  subtitle: Text(
                    [
                      allergyTypeLabel(l10n, item.allergyType),
                      allergySeverityLabel(l10n, item.severity),
                      if (item.reaction != null && item.reaction!.isNotEmpty)
                        item.reaction!,
                    ].join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.allergyDetailPath(item.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
