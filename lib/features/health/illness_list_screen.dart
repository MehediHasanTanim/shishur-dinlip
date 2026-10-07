import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class IllnessListScreen extends ConsumerWidget {
  const IllnessListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(illnessEpisodesProvider);
    final dateFmt = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.illnessTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.illnessCreate),
        child: const Icon(Icons.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.illnessesEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final range = item.endDate == null
                  ? '${dateFmt.formatMediumDate(item.startDate)} · ${l10n.illnessOngoing}'
                  : '${dateFmt.formatMediumDate(item.startDate)} – ${dateFmt.formatMediumDate(item.endDate!)}';
              return Card(
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(range),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.illnessDetailPath(item.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
