import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/school_event.dart';
import 'package:shishur_dinlipi/features/school/school_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class SchoolOverviewScreen extends ConsumerWidget {
  const SchoolOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentAsync = ref.watch(currentSchoolProvider);
    final profilesAsync = ref.watch(schoolProfilesProvider);
    final recentAsync = ref.watch(recentSchoolEventProvider);
    final timelineAsync = ref.watch(schoolTimelineProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.schoolTitle),
        actions: [
          IconButton(
            tooltip: l10n.schoolTimeline,
            onPressed: () => context.push(AppRoutes.schoolTimeline),
            icon: const Icon(Icons.timeline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMenu(context, l10n),
        icon: const Icon(Icons.add),
        label: Text(l10n.schoolAdd),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Text(
            l10n.schoolCurrent,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          currentAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (school) {
              if (school == null) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(l10n.schoolEmpty),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.schoolProfileCreate),
                  ),
                );
              }
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.school,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(school.schoolName),
                  subtitle: Text(
                    [
                      if (school.className != null) school.className!,
                      if (school.teacherName != null) school.teacherName!,
                    ].join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.schoolProfileDetailPath(school.id)),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            l10n.schoolRecentEvent,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          recentAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (event) {
              if (event == null) {
                return Text(l10n.schoolEventsEmpty);
              }
              return Card(
                child: ListTile(
                  title: Text(event.title),
                  subtitle: Text(
                    '${_typeLabel(l10n, event.eventType)} · ${MaterialLocalizations.of(context).formatMediumDate(event.eventDate)}',
                  ),
                  onTap: () =>
                      context.push(AppRoutes.schoolEventDetailPath(event.id)),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            l10n.schoolHistory,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          profilesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (profiles) {
              if (profiles.isEmpty) return Text(l10n.schoolEmpty);
              return Column(
                children: [
                  for (final profile in profiles)
                    Card(
                      child: ListTile(
                        title: Text(profile.schoolName),
                        subtitle: Text(
                          [
                            if (profile.className != null) profile.className!,
                            if (profile.isCurrent)
                              l10n.schoolCurrentBadge
                            else if (profile.endDate != null)
                              MaterialLocalizations.of(
                                context,
                              ).formatMediumDate(profile.endDate!),
                          ].join(' · '),
                        ),
                        onTap: () => context.push(
                          AppRoutes.schoolProfileDetailPath(profile.id),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.schoolEvents,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.schoolTimeline),
                child: Text(l10n.commonSeeAll),
              ),
            ],
          ),
          const SizedBox(height: 8),
          timelineAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (events) {
              if (events.isEmpty) return Text(l10n.schoolEventsEmpty);
              return Column(
                children: [
                  for (final event in events.take(5))
                    Card(
                      child: ListTile(
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
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: Text(l10n.addSchoolProfile),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.schoolProfileCreate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: Text(l10n.addSchoolEvent),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.schoolEventCreate);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, String type) {
    return switch (type) {
      SchoolEventTypes.firstDay => l10n.schoolEventFirstDay,
      SchoolEventTypes.exam => l10n.schoolEventExam,
      SchoolEventTypes.performance => l10n.schoolEventPerformance,
      SchoolEventTypes.sports => l10n.schoolEventSports,
      SchoolEventTypes.certificate => l10n.schoolEventCertificate,
      SchoolEventTypes.classPromotion => l10n.schoolEventPromotion,
      SchoolEventTypes.project => l10n.schoolEventProject,
      SchoolEventTypes.reportCard => l10n.schoolEventReportCard,
      _ => l10n.schoolEventCustom,
    };
  }
}
