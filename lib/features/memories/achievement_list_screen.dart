import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/features/memories/memories_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AchievementListScreen extends ConsumerStatefulWidget {
  const AchievementListScreen({super.key});

  @override
  ConsumerState<AchievementListScreen> createState() =>
      _AchievementListScreenState();
}

class _AchievementListScreenState extends ConsumerState<AchievementListScreen> {
  String? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(achievementsListProvider);
    final dateFmt = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievementsListTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.achievementCreate),
        child: const Icon(Icons.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (items) {
          final filtered = _categoryFilter == null
              ? items
              : items.where((a) => a.category == _categoryFilter).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(l10n.achievementsFilterAll),
                        selected: _categoryFilter == null,
                        onSelected: (_) =>
                            setState(() => _categoryFilter = null),
                      ),
                    ),
                    for (final cat in _categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_categoryLabel(l10n, cat)),
                          selected: _categoryFilter == cat,
                          onSelected: (_) =>
                              setState(() => _categoryFilter = cat),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? Center(child: Text(l10n.achievementsListEmpty))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return Card(
                            child: ListTile(
                              title: Text(item.title),
                              subtitle: Text(
                                '${_categoryLabel(l10n, item.category)} · '
                                '${dateFmt.formatMediumDate(item.eventDate)}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.push(
                                AppRoutes.achievementDetailPath(item.id),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  static const _categories = [
    AchievementCategories.school,
    AchievementCategories.sports,
    AchievementCategories.arts,
    AchievementCategories.social,
    AchievementCategories.personal,
    AchievementCategories.other,
  ];

  String _categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      AchievementCategories.school => l10n.categorySchool,
      AchievementCategories.sports => l10n.categorySports,
      AchievementCategories.arts => l10n.categoryArts,
      AchievementCategories.social => l10n.categorySocial,
      AchievementCategories.personal => l10n.categoryPersonal,
      AchievementCategories.other => l10n.categoryOther,
      _ => category,
    };
  }
}
