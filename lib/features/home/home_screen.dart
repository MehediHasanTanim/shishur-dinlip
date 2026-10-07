import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/children/widgets/child_switcher_sheet.dart';
import 'package:shishur_dinlipi/core/domain/unit_conversion.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/features/development/growth_providers.dart';
import 'package:shishur_dinlipi/features/memories/recent_memories_provider.dart';
import 'package:shishur_dinlipi/features/reminders/reminder_labels.dart';
import 'package:shishur_dinlipi/features/reminders/reminders_providers.dart';
import 'package:shishur_dinlipi/features/school/school_providers.dart';
import 'package:shishur_dinlipi/features/timeline/timeline_providers.dart';
import 'package:shishur_dinlipi/features/timeline/widgets/timeline_card.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';
import 'package:shishur_dinlipi/shared/widgets/child_avatar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _birthdayEnsuredFor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final childAsync = ref.watch(selectedChildProvider);
    final childrenAsync = ref.watch(childrenListProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBnDigits = settings?.useBengaliDigits ?? false;

    ref.listen(selectedChildProvider, (prev, next) {
      final child = next.valueOrNull;
      if (child == null || child.id == _birthdayEnsuredFor) return;
      _birthdayEnsuredFor = child.id;
      ref.read(remindersRepositoryProvider).ensureBirthdayReminder(
            childId: child.id,
            dateOfBirth: child.dateOfBirth,
            childName: child.displayName,
          );
    });

    return childrenAsync.when(
      loading: () => AppStateViews.loading(),
      error: (error, _) => AppStateViews.error(
        message: '$error',
        onRetry: () => ref.invalidate(childrenListProvider),
      ),
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
                        onPressed: () => context.push(AppRoutes.search),
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
                    const _GrowthSnapshotCard(),
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
                          label: l10n.quickAddGrowth,
                          icon: Icons.monitor_weight_outlined,
                          onTap: () => context.push(AppRoutes.growthCreate),
                        ),
                        _QuickAddChip(
                          label: l10n.quickAddMilestone,
                          icon: Icons.stairs_outlined,
                          onTap: () => context.push(AppRoutes.milestoneCreate),
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
                      l10n.onThisDayTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const _OnThisDaySection(),
                    const SizedBox(height: 24),
                    Text(
                      l10n.recentMemories,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const _RecentMemoriesSection(),
                    const SizedBox(height: 24),
                    Text(
                      l10n.schoolDashboard,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const _SchoolDashboardSection(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.upcomingReminders,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.reminders),
                          child: Text(l10n.commonSeeAll),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const _UpcomingSection(),
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

class _GrowthSnapshotCard extends ConsumerWidget {
  const _GrowthSnapshotCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn = settings?.useBengaliDigits ?? false;
    final latestAsync = ref.watch(latestGrowthProvider);

    return latestAsync.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: LinearProgressIndicator(),
        ),
      ),
      error: (_, _) => _PlaceholderCard(
        icon: Icons.show_chart,
        message: l10n.errorGeneric,
      ),
      data: (latest) {
        if (latest == null) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.show_chart,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(l10n.growthEmpty),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.growthCreate),
            ),
          );
        }
        final height = UnitConversion.formatHeight(
          heightCm: latest.heightCm,
          unit: settings?.heightUnit ?? HeightUnit.cm,
          bangla: bangla,
          useBengaliDigits: useBn,
        );
        final weight = UnitConversion.formatWeight(
          weightKg: latest.weightKg,
          unit: settings?.weightUnit ?? WeightUnit.kg,
          bangla: bangla,
          useBengaliDigits: useBn,
        );
        return Card(
          child: ListTile(
            leading: Icon(
              Icons.show_chart,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text('$height · $weight'),
            subtitle: Text(
              MaterialLocalizations.of(
                context,
              ).formatMediumDate(latest.measuredAt),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.growth),
          ),
        );
      },
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

class _SchoolDashboardSection extends ConsumerWidget {
  const _SchoolDashboardSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recentSchool = ref.watch(recentSchoolEventProvider);
    final child = ref.watch(selectedChildProvider).valueOrNull;

    return Column(
      children: [
        recentSchool.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => Text(l10n.errorGeneric),
          data: (event) {
            if (event == null) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: Text(l10n.schoolEventsEmpty),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.school),
                ),
              );
            }
            return Card(
              child: ListTile(
                leading: Icon(
                  Icons.school,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(event.title),
                subtitle: Text(
                  MaterialLocalizations.of(
                    context,
                  ).formatMediumDate(event.eventDate),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    context.push(AppRoutes.schoolEventDetailPath(event.id)),
              ),
            );
          },
        ),
        if (child != null)
          FutureBuilder(
            future: ref
                .read(achievementsRepositoryProvider)
                .forChild(child.id, limit: 1),
            builder: (context, snapshot) {
              final list = snapshot.data;
              if (list == null || list.isEmpty) {
                return const SizedBox.shrink();
              }
              final achievement = list.first;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.emoji_events_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(achievement.title),
                    subtitle: Text(l10n.kindAchievement),
                    onTap: () => context.push(
                      AppRoutes.achievementDetailPath(achievement.id),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _OnThisDaySection extends ConsumerWidget {
  const _OnThisDaySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final onThisDayAsync = ref.watch(onThisDayProvider);

    return onThisDayAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => _PlaceholderCard(
        icon: Icons.history,
        message: l10n.errorGeneric,
      ),
      data: (items) {
        if (items.isEmpty) {
          return _PlaceholderCard(
            icon: Icons.history,
            message: l10n.onThisDayEmpty,
          );
        }
        final now = DateTime.now();
        return Column(
          children: [
            for (final item in items.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 4),
                      child: Text(
                        l10n.onThisDayYearsAgo(
                          (now.year - item.eventDate.year).clamp(1, 100),
                        ),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    TimelineCard(item: item),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _UpcomingSection extends ConsumerWidget {
  const _UpcomingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final remindersAsync = ref.watch(upcomingRemindersProvider);
    final schoolAsync = ref.watch(upcomingSchoolEventsProvider);

    return remindersAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => _PlaceholderCard(
        icon: Icons.notifications_none,
        message: l10n.errorGeneric,
      ),
      data: (reminders) {
        final schoolEvents = schoolAsync.valueOrNull ?? const [];
        if (reminders.isEmpty && schoolEvents.isEmpty) {
          return _PlaceholderCard(
            icon: Icons.notifications_none,
            message: l10n.upcomingEmpty,
          );
        }
        return Column(
          children: [
            for (final reminder in reminders.take(5))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications_active_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(reminder.displayTitle),
                    subtitle: Text(
                      [
                        reminderTypeLabel(l10n, reminder.reminderType),
                        MaterialLocalizations.of(context)
                            .formatMediumDate(reminder.scheduledAt.toLocal()),
                      ].join(' · '),
                    ),
                    onTap: () => context.push(
                      AppRoutes.reminderDetailPath(reminder.id),
                    ),
                  ),
                ),
              ),
            for (final event in schoolEvents.take(2))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.event_available_outlined),
                    title: Text(event.title),
                    subtitle: Text(
                      MaterialLocalizations.of(
                        context,
                      ).formatMediumDate(event.eventDate),
                    ),
                    onTap: () => context.push(
                      AppRoutes.schoolEventDetailPath(event.id),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
