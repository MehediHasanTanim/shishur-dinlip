import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class DoctorVisitListScreen extends ConsumerWidget {
  const DoctorVisitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(doctorVisitsProvider);
    final dateFmt = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.doctorVisitTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.doctorVisitCreate),
        child: const Icon(Icons.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.doctorVisitsEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item.doctorName),
                  subtitle: Text(
                    [
                      dateFmt.formatMediumDate(item.visitDate),
                      if (item.specialty != null) item.specialty!,
                      if (item.reason != null) item.reason!,
                    ].join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.doctorVisitDetailPath(item.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
