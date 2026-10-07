import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/children/widgets/child_switcher_sheet.dart';
import 'package:shishur_dinlipi/features/memories/journal_templates.dart';
import 'package:shishur_dinlipi/features/memories/recent_memories_provider.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/child_avatar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final childAsync = ref.watch(selectedChildProvider);
    final childrenAsync = ref.watch(childrenListProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBnDigits = settings?.useBengaliDigits ?? false;

    return childrenAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('$error')),
      data: (children) {
        if (children.isEmpty) {
          return _EmptyChildren(l10n: l10n);
        }

        final child = childAsync.valueOrNull ?? children.first;
        final age = AgeFormatter.format(
          age: AgeCalculator.current(child.dateOfBirth),
          bangla: bangla,
          useBengaliDigits: useBnDigits,
        );

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () => showChildSwitcherSheet(context),
                        child: Row(
                          children: [
                            ChildAvatar(child: child, radius: 22),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child.displayName,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  age,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const Icon(Icons.expand_more),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                        tooltip: l10n.commonSearch,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    Text(
                      _greeting(l10n),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.homeAgeLine(child.displayName, age),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.growthSnapshot,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _PlaceholderCard(
                      icon: Icons.show_chart,
                      message: l10n.growthEmpty,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.quickAdd,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _QuickAddChip(
                          label: l10n.quickAddMemory,
                          icon: Icons.auto_stories_outlined,
                          onTap: () => context.push(AppRoutes.journalCreate),
                        ),
                        _QuickAddChip(
                          label: l10n.quickAddPhoto,
                          icon: Icons.photo_outlined,
                          onTap: () => context.push(
                            AppRoutes.journalCreatePath(
                              template: JournalTemplate.photoMemory.name,
                            ),
                          ),
                        ),
                        _QuickAddChip(
                          label: l10n.addFunnyMoment,
                          icon: Icons.sentiment_very_satisfied_outlined,
                          onTap: () => context.push(AppRoutes.funnyCreate),
                        ),
                        _QuickAddChip(
                          label: l10n.quickAddAchievement,
                          icon: Icons.emoji_events_outlined,
                          onTap: () =>
                              context.push(AppRoutes.achievementCreate),
                        ),
                        _QuickAddChip(
                          label: l10n.navAdd,
                          icon: Icons.add_circle_outline,
                          onTap: () => context.go(AppRoutes.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.recentMemories,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const _RecentMemoriesSection(),
                    const SizedBox(height: 24),
                    Text(
                      l10n.upcoming,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _PlaceholderCard(
                      icon: Icons.notifications_none,
                      message: l10n.upcomingEmpty,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.homeGreetingMorning;
    if (hour < 17) return l10n.homeGreetingAfternoon;
    return l10n.homeGreetingEvening;
  }
}

class _EmptyChildren extends StatelessWidget {
  const _EmptyChildren({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.child_care_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noChildrenTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.noChildrenMessage, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.push(AppRoutes.childCreate),
            child: Text(l10n.addChild),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  const _QuickAddChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

class _RecentMemoriesSection extends ConsumerWidget {
  const _RecentMemoriesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recentAsync = ref.watch(recentMemoriesProvider);

    return recentAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => _PlaceholderCard(
        icon: Icons.error_outline,
        message: l10n.errorGeneric,
      ),
      data: (cards) {
        if (cards.isEmpty) {
          return _PlaceholderCard(
            icon: Icons.photo_album_outlined,
            message: l10n.recentMemoriesEmpty,
          );
        }
        return Column(
          children: [
            for (final card in cards)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: _Thumb(card: card),
                    title: Text(card.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      [
                        _kindLabel(l10n, card.kind),
                        MaterialLocalizations.of(context)
                            .formatMediumDate(card.eventDate),
                      ].join(' · '),
                    ),
                    onTap: () => _open(context, card),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _kindLabel(AppLocalizations l10n, RecentMemoryKind kind) {
    return switch (kind) {
      RecentMemoryKind.journal => l10n.kindJournal,
      RecentMemoryKind.funny => l10n.kindFunny,
      RecentMemoryKind.achievement => l10n.kindAchievement,
    };
  }

  void _open(BuildContext context, RecentMemoryCard card) {
    final path = switch (card.kind) {
      RecentMemoryKind.journal => AppRoutes.journalDetailPath(card.id),
      RecentMemoryKind.funny => AppRoutes.funnyDetailPath(card.id),
      RecentMemoryKind.achievement =>
        AppRoutes.achievementDetailPath(card.id),
    };
    context.push(path);
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.card});

  final RecentMemoryCard card;

  @override
  Widget build(BuildContext context) {
    final file = card.thumbnail;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 48,
        height: 48,
        child: file == null
            ? ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  switch (card.kind) {
                    RecentMemoryKind.journal => Icons.auto_stories_outlined,
                    RecentMemoryKind.funny =>
                      Icons.sentiment_very_satisfied_outlined,
                    RecentMemoryKind.achievement => Icons.emoji_events_outlined,
                  },
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Image.file(file, fit: BoxFit.cover),
      ),
    );
  }
}
