import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/timeline_item.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

String timelineFilterLabel(AppLocalizations l10n, TimelineFilter filter) {
  return switch (filter) {
    TimelineFilter.all => l10n.timelineFilterAll,
    TimelineFilter.memories => l10n.timelineFilterMemories,
    TimelineFilter.growth => l10n.timelineFilterGrowth,
    TimelineFilter.milestones => l10n.timelineFilterMilestones,
    TimelineFilter.health => l10n.timelineFilterHealth,
    TimelineFilter.school => l10n.timelineFilterSchool,
    TimelineFilter.achievements => l10n.timelineFilterAchievements,
    TimelineFilter.photos => l10n.timelineFilterPhotos,
    TimelineFilter.funnyMoments => l10n.timelineFilterFunny,
  };
}

String timelineTypeLabel(AppLocalizations l10n, TimelineItemType type) {
  return switch (type) {
    TimelineItemType.journal => l10n.timelineTypeJournal,
    TimelineItemType.funnyMoment => l10n.timelineTypeFunny,
    TimelineItemType.achievement => l10n.timelineTypeAchievement,
    TimelineItemType.growth => l10n.timelineTypeGrowth,
    TimelineItemType.milestone => l10n.timelineTypeMilestone,
    TimelineItemType.schoolEvent => l10n.timelineTypeSchool,
    TimelineItemType.vaccination => l10n.timelineTypeVaccination,
    TimelineItemType.illness => l10n.timelineTypeIllness,
    TimelineItemType.doctorVisit => l10n.timelineTypeDoctor,
    TimelineItemType.birthday => l10n.timelineTypeBirthday,
    TimelineItemType.familyEvent => l10n.timelineTypeFamilyEvent,
    TimelineItemType.trip => l10n.timelineTypeTrip,
  };
}

IconData timelineTypeIcon(TimelineItemType type) {
  return switch (type) {
    TimelineItemType.journal => Icons.auto_stories_outlined,
    TimelineItemType.funnyMoment => Icons.sentiment_very_satisfied_outlined,
    TimelineItemType.achievement => Icons.emoji_events_outlined,
    TimelineItemType.growth => Icons.monitor_weight_outlined,
    TimelineItemType.milestone => Icons.stairs_outlined,
    TimelineItemType.schoolEvent => Icons.school_outlined,
    TimelineItemType.vaccination => Icons.vaccines_outlined,
    TimelineItemType.illness => Icons.healing_outlined,
    TimelineItemType.doctorVisit => Icons.medical_services_outlined,
    TimelineItemType.birthday => Icons.cake_outlined,
    TimelineItemType.familyEvent => Icons.family_restroom_outlined,
    TimelineItemType.trip => Icons.flight_takeoff_outlined,
  };
}

String? timelineDetailPath(TimelineItem item) {
  return switch (item.type) {
    TimelineItemType.journal => AppRoutes.journalDetailPath(item.id),
    TimelineItemType.funnyMoment => AppRoutes.funnyDetailPath(item.id),
    TimelineItemType.achievement => AppRoutes.achievementDetailPath(item.id),
    TimelineItemType.growth => AppRoutes.growthDetailPath(item.id),
    TimelineItemType.milestone => AppRoutes.milestoneDetailPath(item.id),
    TimelineItemType.schoolEvent => AppRoutes.schoolEventDetailPath(item.id),
    TimelineItemType.vaccination => AppRoutes.vaccinationDetailPath(item.id),
    TimelineItemType.illness => AppRoutes.illnessDetailPath(item.id),
    TimelineItemType.doctorVisit => AppRoutes.doctorVisitDetailPath(item.id),
    TimelineItemType.birthday => AppRoutes.birthdayDetailPath(item.id),
    TimelineItemType.familyEvent => AppRoutes.familyEventDetailPath(item.id),
    TimelineItemType.trip => AppRoutes.tripDetailPath(item.id),
  };
}

void openTimelineItem(BuildContext context, TimelineItem item) {
  final path = timelineDetailPath(item);
  if (path != null) context.push(path);
}
