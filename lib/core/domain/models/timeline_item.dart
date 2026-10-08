import 'package:flutter/foundation.dart';

enum TimelineItemType {
  journal,
  funnyMoment,
  achievement,
  growth,
  milestone,
  schoolEvent,
  vaccination,
  illness,
  doctorVisit,
  allergy,
  birthday,
  familyEvent,
  trip,
}

enum TimelineFilter {
  all,
  memories,
  growth,
  milestones,
  health,
  school,
  achievements,
  photos,
  funnyMoments,
}

@immutable
class TimelineItem {
  const TimelineItem({
    required this.id,
    required this.childId,
    required this.type,
    required this.eventDate,
    required this.title,
    this.subtitle,
    this.thumbnailRelativePath,
    this.favorite = false,
    this.hasPhoto = false,
    this.sortKey = 0,
  });

  final String id;
  final String childId;
  final TimelineItemType type;
  final DateTime eventDate;
  final String title;
  final String? subtitle;
  final String? thumbnailRelativePath;
  final bool favorite;
  final bool hasPhoto;

  /// Lower sorts earlier when dates are equal (same-day ordering).
  final int sortKey;

  String get entityTypeToken => switch (type) {
    TimelineItemType.journal => 'journal_entry',
    TimelineItemType.funnyMoment => 'funny_moment',
    TimelineItemType.achievement => 'achievement',
    TimelineItemType.growth => 'growth_record',
    TimelineItemType.milestone => 'milestone',
    TimelineItemType.schoolEvent => 'school_event',
    TimelineItemType.vaccination => 'vaccination',
    TimelineItemType.illness => 'illness_episode',
    TimelineItemType.doctorVisit => 'doctor_visit',
    TimelineItemType.allergy => 'allergy',
    TimelineItemType.birthday => 'birthday',
    TimelineItemType.familyEvent => 'family_event',
    TimelineItemType.trip => 'trip',
  };

  bool matches(TimelineFilter filter) {
    return switch (filter) {
      TimelineFilter.all => true,
      TimelineFilter.memories =>
        type == TimelineItemType.journal ||
        type == TimelineItemType.funnyMoment ||
        type == TimelineItemType.achievement ||
        type == TimelineItemType.familyEvent ||
        type == TimelineItemType.trip,
      TimelineFilter.growth => type == TimelineItemType.growth,
      TimelineFilter.milestones => type == TimelineItemType.milestone,
      TimelineFilter.health =>
        type == TimelineItemType.vaccination ||
        type == TimelineItemType.illness ||
        type == TimelineItemType.doctorVisit ||
        type == TimelineItemType.allergy,
      TimelineFilter.school => type == TimelineItemType.schoolEvent,
      TimelineFilter.achievements => type == TimelineItemType.achievement,
      TimelineFilter.photos => hasPhoto,
      TimelineFilter.funnyMoments => type == TimelineItemType.funnyMoment,
    };
  }

  static int typeSortKey(TimelineItemType type) => switch (type) {
    TimelineItemType.birthday => 0,
    TimelineItemType.journal => 1,
    TimelineItemType.achievement => 2,
    TimelineItemType.funnyMoment => 3,
    TimelineItemType.familyEvent => 4,
    TimelineItemType.trip => 5,
    TimelineItemType.milestone => 6,
    TimelineItemType.growth => 7,
    TimelineItemType.schoolEvent => 8,
    TimelineItemType.vaccination => 9,
    TimelineItemType.illness => 10,
    TimelineItemType.doctorVisit => 11,
    TimelineItemType.allergy => 12,
  };
}

@immutable
class TimelinePage {
  const TimelinePage({
    required this.items,
    required this.hasMore,
    required this.totalApprox,
  });

  final List<TimelineItem> items;
  final bool hasMore;
  final int totalApprox;
}
