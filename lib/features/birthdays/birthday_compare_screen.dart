import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_labels.dart';
import 'package:shishur_dinlipi/features/birthdays/birthdays_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class BirthdayCompareScreen extends ConsumerWidget {
  const BirthdayCompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(birthdayCompareProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.birthdayCompareTitle)),
      body: async.when(
        loading: () => AppStateViews.loading(),
        error: (e, _) => AppStateViews.error(
          message: '$e',
          onRetry: () => ref.invalidate(birthdayCompareProvider),
        ),
        data: (rows) {
          if (rows.isEmpty) {
            return AppStateViews.empty(
              icon: Icons.compare_arrows_outlined,
              title: l10n.birthdayEmpty,
              subtitle: l10n.birthdayEmptyHint,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final row = rows[index];
              final ages = row.byAge.keys.toList()..sort();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        birthdayQuestionLabel(l10n, row.questionKey),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...ages.map(
                        (age) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 72,
                                child: Text(
                                  '${l10n.birthdayAge} $age',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              Expanded(child: Text(row.byAge[age]!)),
                            ],
                          ),
                        ),
                      ),
                    ],
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
