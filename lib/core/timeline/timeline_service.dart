import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/timeline_item.dart';
import 'package:shishur_dinlipi/core/mappers/media_asset_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

/// Merges domain tables into a paginated, filterable child timeline.
class TimelineService extends RepositoryBase {
  TimelineService(super.db);

  static const defaultPageSize = 40;

  Future<TimelinePage> pageForChild({
    required String childId,
    TimelineFilter filter = TimelineFilter.all,
    int offset = 0,
    int limit = defaultPageSize,
    DateTime? onMonthDay,
    int? beforeYear,
  }) {
    return guard(() async {
      final all = await _collect(childId);
      var filtered = all.where((i) => i.matches(filter)).toList();

      if (onMonthDay != null) {
        filtered = filtered.where((i) {
          final d = i.eventDate;
          final yearOk = beforeYear == null || d.year < beforeYear;
          return yearOk &&
              d.month == onMonthDay.month &&
              d.day == onMonthDay.day;
        }).toList();
      }

      _sort(filtered);
      final slice = filtered.skip(offset).take(limit).toList();
      return TimelinePage(
        items: slice,
        hasMore: offset + slice.length < filtered.length,
        totalApprox: filtered.length,
      );
    }, operation: 'timeline.page');
  }

  Future<List<TimelineItem>> forDate({
    required String childId,
    required DateTime date,
    TimelineFilter filter = TimelineFilter.all,
  }) {
    return guard(() async {
      final day = DateTime(date.year, date.month, date.day);
      final all = await _collect(childId);
      final items = all.where((i) {
        final d = DateTime(i.eventDate.year, i.eventDate.month, i.eventDate.day);
        return d == day && i.matches(filter);
      }).toList();
      _sort(items);
      return items;
    }, operation: 'timeline.forDate');
  }

  Future<Map<DateTime, int>> monthCounts({
    required String childId,
    required int year,
    required int month,
    TimelineFilter filter = TimelineFilter.all,
  }) {
    return guard(() async {
      final all = await _collect(childId);
      final counts = <DateTime, int>{};
      for (final item in all) {
        if (!item.matches(filter)) continue;
        if (item.eventDate.year != year || item.eventDate.month != month) {
          continue;
        }
        final key = DateTime(
          item.eventDate.year,
          item.eventDate.month,
          item.eventDate.day,
        );
        counts[key] = (counts[key] ?? 0) + 1;
      }
      return counts;
    }, operation: 'timeline.monthCounts');
  }

  Future<List<TimelineItem>> onThisDay({
    required String childId,
    DateTime? asOf,
    int limit = 10,
  }) {
    final today = asOf ?? DateTime.now();
    return pageForChild(
      childId: childId,
      onMonthDay: today,
      beforeYear: today.year,
      limit: limit,
    ).then((page) => page.items);
  }

  Future<List<TimelineItem>> _collect(String childId) async {
    final items = <TimelineItem>[];

    final journals = await db.journalEntriesDao.forChild(childId);
    for (final row in journals) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.journal,
          eventDate: row.eventDate,
          title: (row.title?.trim().isNotEmpty ?? false)
              ? row.title!.trim()
              : (row.body.trim().isEmpty
                    ? 'Memory'
                    : row.body.trim().split('\n').first),
          subtitle: row.mood,
          favorite: row.isFavorite,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.journal),
        ),
      );
    }

    final funny = await db.funnyMomentsDao.forChild(childId);
    for (final row in funny) {
      final title = row.title?.trim().isNotEmpty == true
          ? row.title!.trim()
          : (row.quoteText?.trim().isNotEmpty == true
                ? row.quoteText!.trim()
                : (row.story?.trim() ?? 'Funny moment'));
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.funnyMoment,
          eventDate: row.eventDate,
          title: title.length > 64 ? '${title.substring(0, 64)}…' : title,
          favorite: row.isFavorite,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.funnyMoment),
        ),
      );
    }

    final achievements = await db.achievementsDao.forChild(childId);
    for (final row in achievements) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.achievement,
          eventDate: row.eventDate,
          title: row.title,
          subtitle: row.category,
          favorite: row.isFavorite,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.achievement),
        ),
      );
    }

    final growth = await db.growthRecordsDao.forChild(childId);
    for (final row in growth) {
      final parts = <String>[];
      if (row.heightCm != null) {
        parts.add('${row.heightCm!.toStringAsFixed(1)} cm');
      }
      if (row.weightKg != null) {
        parts.add('${row.weightKg!.toStringAsFixed(1)} kg');
      }
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.growth,
          eventDate: row.measuredAt,
          title: parts.isEmpty ? 'Growth' : parts.join(' · '),
          subtitle: row.measurementLocation,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.growth),
        ),
      );
    }

    final milestones = await db.milestonesDao.forChild(childId);
    for (final row in milestones) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.milestone,
          eventDate: row.eventDate ?? row.createdAt,
          title: row.title,
          subtitle: row.category,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.milestone),
        ),
      );
    }

    final school = await db.schoolEventsDao.forChild(childId);
    for (final row in school) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.schoolEvent,
          eventDate: row.eventDate,
          title: row.title,
          subtitle: row.eventType,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.schoolEvent),
        ),
      );
    }

    final vaccines = await db.vaccinationsDao.forChild(childId);
    for (final row in vaccines) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.vaccination,
          eventDate: row.givenDate ?? row.scheduledDate ?? row.createdAt,
          title: row.vaccineName,
          subtitle: row.status,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.vaccination),
        ),
      );
    }

    final illnesses = await db.illnessEpisodesDao.forChild(childId);
    for (final row in illnesses) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.illness,
          eventDate: row.startDate,
          title: row.title,
          subtitle: row.diagnosis,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.illness),
        ),
      );
    }

    final visits = await db.doctorVisitsDao.forChild(childId);
    for (final row in visits) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.doctorVisit,
          eventDate: row.visitDate,
          title: row.doctorName,
          subtitle: row.reason ?? row.specialty,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.doctorVisit),
        ),
      );
    }

    final birthdays = await db.birthdaysDao.forChild(childId);
    final birthdayCoverIds = <String, String>{};
    for (final row in birthdays) {
      if (row.coverAssetId != null) {
        birthdayCoverIds[row.id] = row.coverAssetId!;
      }
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.birthday,
          eventDate: row.birthdayDate,
          title: 'Age ${row.age}',
          subtitle: row.theme ?? row.favoriteGift,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.birthday),
        ),
      );
    }

    final familyEvents = await db.familyEventsDao.forChild(childId);
    for (final row in familyEvents) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.familyEvent,
          eventDate: row.eventDate,
          title: row.title,
          subtitle: row.eventType,
          favorite: row.isFavorite,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.familyEvent),
        ),
      );
    }

    final trips = await db.tripsDao.forChild(childId);
    for (final row in trips) {
      items.add(
        TimelineItem(
          id: row.id,
          childId: childId,
          type: TimelineItemType.trip,
          eventDate: row.startDate,
          title: row.title,
          subtitle: row.placeName,
          favorite: row.isFavorite,
          sortKey: TimelineItem.typeSortKey(TimelineItemType.trip),
        ),
      );
    }

    await _attachPhotos(items);

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.type != TimelineItemType.birthday) continue;
      if (item.thumbnailRelativePath != null) continue;
      final coverId = birthdayCoverIds[item.id];
      if (coverId == null) continue;
      final media = await db.mediaAssetsDao.getById(coverId);
      if (media == null) continue;
      final asset = MediaAssetMapper.toDomain(media);
      items[i] = TimelineItem(
        id: item.id,
        childId: item.childId,
        type: item.type,
        eventDate: item.eventDate,
        title: item.title,
        subtitle: item.subtitle,
        thumbnailRelativePath: asset.thumbnailPath ?? asset.localPath,
        favorite: item.favorite,
        hasPhoto: true,
        sortKey: item.sortKey,
      );
    }

    return items;
  }

  Future<void> _attachPhotos(List<TimelineItem> items) async {
    Future<void> enrich(TimelineItemType type, String entityType) async {
      final subset = items.where((i) => i.type == type).toList();
      if (subset.isEmpty) return;
      final ids = subset.map((i) => i.id).toList();
      final withPhotos = await db.attachmentsDao.entityIdsWithAttachments(
        entityType: entityType,
        entityIds: ids,
      );
      final firsts = await db.attachmentsDao.firstForEntities(
        entityType: entityType,
        entityIds: ids.where(withPhotos.contains).toList(),
      );
      final thumbByEntity = <String, String>{};
      for (final att in firsts) {
        final media = await db.mediaAssetsDao.getById(att.mediaAssetId);
        if (media == null) continue;
        final asset = MediaAssetMapper.toDomain(media);
        thumbByEntity[att.entityId] =
            asset.thumbnailPath ?? asset.localPath;
      }
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        if (item.type != type) continue;
        if (!withPhotos.contains(item.id)) continue;
        items[i] = TimelineItem(
          id: item.id,
          childId: item.childId,
          type: item.type,
          eventDate: item.eventDate,
          title: item.title,
          subtitle: item.subtitle,
          thumbnailRelativePath: thumbByEntity[item.id],
          favorite: item.favorite,
          hasPhoto: true,
          sortKey: item.sortKey,
        );
      }
    }

    await enrich(TimelineItemType.journal, EntityTypes.journalEntry);
    await enrich(TimelineItemType.funnyMoment, EntityTypes.funnyMoment);
    await enrich(TimelineItemType.achievement, EntityTypes.achievement);
    await enrich(TimelineItemType.milestone, EntityTypes.milestone);
    await enrich(TimelineItemType.schoolEvent, EntityTypes.schoolEvent);
    await enrich(TimelineItemType.vaccination, EntityTypes.vaccination);
    await enrich(TimelineItemType.illness, EntityTypes.illnessEpisode);
    await enrich(TimelineItemType.doctorVisit, EntityTypes.doctorVisit);
    await enrich(TimelineItemType.birthday, EntityTypes.birthday);
    await enrich(TimelineItemType.familyEvent, EntityTypes.familyEvent);
    await enrich(TimelineItemType.trip, EntityTypes.trip);
  }

  void _sort(List<TimelineItem> items) {
    items.sort((a, b) {
      final byDate = b.eventDate.compareTo(a.eventDate);
      if (byDate != 0) return byDate;
      final byType = a.sortKey.compareTo(b.sortKey);
      if (byType != 0) return byType;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
  }
}
