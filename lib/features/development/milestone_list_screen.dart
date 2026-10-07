import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/approximate_date.dart';
import 'package:shishur_dinlipi/core/domain/models/milestone.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MilestoneListScreen extends ConsumerWidget {
  const MilestoneListScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn =
        ref.watch(settingsControllerProvider).valueOrNull?.useBengaliDigits ??
        false;
    final child = ref.watch(selectedChildProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(_categoryLabel(l10n, category))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          AppRoutes.milestoneCreatePath(category: category),
        ),
        child: const Icon(Icons.add),
      ),
      body: child == null
          ? Center(child: Text(l10n.noChildrenMessage))
          : FutureBuilder(
              future: ref
                  .read(milestonesRepositoryProvider)
                  .forChild(child.id, category: category),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!;
                if (items.isEmpty) {
                  return Center(child: Text(l10n.milestonesEmpty));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.title),
                        subtitle: Text(
                          ApproximateDateFormatter.format(
                            date: item.eventDate,
                            precision: item.datePrecision,
                            bangla: bangla,
                            useBengaliDigits: useBn,
                          ),
                        ),
                        onTap: () => context.push(
                          AppRoutes.milestoneDetailPath(item.id),
                        ),
                      ),
                    );
                  },
                );
              },
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
}
