import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/memories/memories_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// UX §17.4 — quote-first cards where possible.
class FunnyMomentListScreen extends ConsumerWidget {
  const FunnyMomentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(funnyMomentsListProvider);
    final dateFmt = MaterialLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.funnyListTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.funnyCreate),
        child: const Icon(Icons.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.funnyListEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final quote = item.quoteText?.trim();
              final hasQuote = quote != null && quote.isNotEmpty;
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () =>
                      context.push(AppRoutes.funnyDetailPath(item.id)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasQuote)
                          Text(
                            '"$quote"',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          Text(
                            item.displayTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                        if (hasQuote &&
                            item.title != null &&
                            item.title!.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            item.title!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          dateFmt.formatMediumDate(item.eventDate),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
