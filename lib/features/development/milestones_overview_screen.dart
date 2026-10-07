import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/approximate_date.dart';
import 'package:shishur_dinlipi/core/domain/models/milestone.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/development/milestone_templates.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

final recentMilestonesProvider =
    FutureProvider.autoDispose<List<Milestone>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref
          .watch(milestonesRepositoryProvider)
          .forChild(child.id, limit: 8);
    });

final firstWordsListProvider = FutureProvider.autoDispose((ref) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(firstWordsRepositoryProvider).forChild(child.id, limit: 6);
});

class MilestonesOverviewScreen extends ConsumerWidget {
  const MilestonesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn =
        ref.watch(settingsControllerProvider).valueOrNull?.useBengaliDigits ??
        false;
    final milestonesAsync = ref.watch(recentMilestonesProvider);
    final wordsAsync = ref.watch(firstWordsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.milestonesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.milestoneCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addMilestone),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Text(
            l10n.milestoneCategories,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in MilestoneCategories.all)
                ActionChip(
                  label: Text(_categoryLabel(l10n, category)),
                  onPressed: () => context.push(
                    AppRoutes.milestonesByCategoryPath(category),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.milestoneTemplates,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final template in MilestoneTemplate.values)
                ActionChip(
                  label: Text(_templateLabel(l10n, template)),
                  onPressed: () {
                    if (template.opensFirstWord) {
                      context.push(AppRoutes.firstWordCreate);
                    } else {
                      context.push(
                        AppRoutes.milestoneCreatePath(template: template.name),
                      );
                    }
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.recentMilestones,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.firstWords),
                child: Text(l10n.firstWordsTitle),
              ),
            ],
          ),
          const SizedBox(height: 8),
          milestonesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (items) {
              if (items.isEmpty) {
                return Text(l10n.milestonesEmpty);
              }
              return Column(
                children: [
                  for (final item in items)
                    Card(
                      child: ListTile(
                        title: Text(item.title),
                        subtitle: Text(
                          [
                            _categoryLabel(l10n, item.category),
                            ApproximateDateFormatter.format(
                              date: item.eventDate,
                              precision: item.datePrecision,
                              bangla: bangla,
                              useBengaliDigits: useBn,
                            ),
                          ].join(' · '),
                        ),
                        onTap: () =>
                            context.push(AppRoutes.milestoneDetailPath(item.id)),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.firstWordsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          wordsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (words) {
              if (words.isEmpty) return Text(l10n.firstWordsEmpty);
              return Column(
                children: [
                  for (final word in words)
                    Card(
                      child: ListTile(
                        title: Text(
                          '"${word.word}"',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        subtitle: Text(
                          ApproximateDateFormatter.format(
                            date: word.eventDate,
                            precision: word.datePrecision,
                            bangla: bangla,
                            useBengaliDigits: useBn,
                          ),
                        ),
                        onTap: () => context.push(
                          AppRoutes.firstWordDetailPath(word.id),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      MilestoneCategories.movement => l10n.milestoneMovement,
      MilestoneCategories.speech => l10n.milestoneSpeech,
      MilestoneCategories.social => l10n.milestoneSocial,
      MilestoneCategories.selfCare => l10n.milestoneSelfCare,
      MilestoneCategories.learning => l10n.milestoneLearning,
      MilestoneCategories.custom => l10n.milestoneCustom,
      _ => category,
    };
  }

  String _templateLabel(AppLocalizations l10n, MilestoneTemplate template) {
    return switch (template) {
      MilestoneTemplate.firstCrawl => l10n.templateFirstCrawl,
      MilestoneTemplate.firstStand => l10n.templateFirstStand,
      MilestoneTemplate.firstStep => l10n.templateFirstStep,
      MilestoneTemplate.firstWalk => l10n.templateFirstWalk,
      MilestoneTemplate.firstRun => l10n.templateFirstRun,
      MilestoneTemplate.firstBicycle => l10n.templateFirstBicycle,
      MilestoneTemplate.firstWord => l10n.templateFirstWord,
      MilestoneTemplate.firstSentence => l10n.templateFirstSentence,
      MilestoneTemplate.wroteOwnName => l10n.templateWroteOwnName,
    };
  }
}
