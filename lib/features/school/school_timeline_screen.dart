import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/school_event.dart';
import 'package:shishur_dinlipi/features/school/school_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class SchoolTimelineScreen extends ConsumerStatefulWidget {
  const SchoolTimelineScreen({super.key});

  @override
  ConsumerState<SchoolTimelineScreen> createState() =>
      _SchoolTimelineScreenState();
}

class _SchoolTimelineScreenState extends ConsumerState<SchoolTimelineScreen> {
  String? _filterType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final timelineAsync = ref.watch(schoolTimelineProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.schoolTimeline)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.schoolEventCreate),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(l10n.commonAll),
                    selected: _filterType == null,
                    onSelected: (_) => setState(() => _filterType = null),
                  ),
                ),
                for (final type in SchoolEventTypes.all)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_typeLabel(l10n, type)),
                      selected: _filterType == type,
                      onSelected: (_) => setState(() => _filterType = type),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: timelineAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l10n.errorGeneric)),
              data: (events) {
                final filtered = _filterType == null
                    ? events
                    : events
                          .where((e) => e.eventType == _filterType)
                          .toList();
                if (filtered.isEmpty) {
                  return Center(child: Text(l10n.schoolEventsEmpty));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final event = filtered[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          _iconFor(event.eventType),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(event.title),
                        subtitle: Text(
                          '${_typeLabel(l10n, event.eventType)} · ${MaterialLocalizations.of(context).formatMediumDate(event.eventDate)}',
                        ),
                        onTap: () => context.push(
                          AppRoutes.schoolEventDetailPath(event.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String type) {
    return switch (type) {
      SchoolEventTypes.firstDay => Icons.waving_hand_outlined,
      SchoolEventTypes.exam => Icons.quiz_outlined,
      SchoolEventTypes.performance => Icons.theater_comedy_outlined,
      SchoolEventTypes.sports => Icons.sports_soccer_outlined,
      SchoolEventTypes.certificate => Icons.workspace_premium_outlined,
      SchoolEventTypes.classPromotion => Icons.trending_up,
      SchoolEventTypes.project => Icons.science_outlined,
      SchoolEventTypes.reportCard => Icons.description_outlined,
      _ => Icons.school_outlined,
    };
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
