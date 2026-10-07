import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/year_review/year_review_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class YearReviewHomeScreen extends ConsumerWidget {
  const YearReviewHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final child = ref.watch(selectedChildProvider).valueOrNull;
    final years = ref.watch(yearReviewAvailableYearsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.yearReviewTitle)),
      body: child == null
          ? Center(child: Text(l10n.errorGeneric))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Text(
                  l10n.yearReviewSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.yearReviewPickYear,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (years.isEmpty)
                  Text(l10n.yearReviewEmptyYears)
                else
                  ...years.map((year) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.auto_stories_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text('$year'),
                        subtitle: Text(
                          l10n.yearReviewOpenYear(child.name, year),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          AppRoutes.yearReviewEditorPath(year),
                        ),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
