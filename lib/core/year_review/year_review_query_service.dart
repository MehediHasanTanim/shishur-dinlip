import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/media_asset_mapper.dart';
import 'package:shishur_dinlipi/core/mappers/year_review_preference_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_highlight_selector.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_scorer.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_smart_suggestions.dart';

/// Builds a [YearReviewDraft] for a child + calendar year.
class YearReviewQueryService extends RepositoryBase {
  YearReviewQueryService(super.db);

  Future<YearReviewDraft> buildDraft({
    required String childId,
    required int year,
    String? languageCode,
  }) {
    return guard(() async {
      final childRow = await db.childrenDao.getById(childId);
      if (childRow == null || childRow.deletedAt != null) {
        throw const ValidationFailure(message: 'Child not found.');
      }

      final start = DateTime(year, 1, 1);
      final end = DateTime(year, 12, 31, 23, 59, 59);
      final dob = childRow.dateOfBirth;
      final ageAtEnd = AgeCalculator.at(dob, end).years;

      final preferenceRow = await db.yearReviewPreferencesDao.forChildYear(
        childId,
        year,
      );
      final preference = preferenceRow == null
          ? null
          : YearReviewPreferenceMapper.toDomain(preferenceRow);

      final growth = await _growthSummary(childId, start, end);
      final candidates = <YearReviewItem>[];

      candidates.addAll(await _milestones(childId, start, end));
      candidates.addAll(await _achievements(childId, start, end));
      candidates.addAll(await _funnyMoments(childId, start, end));
      candidates.addAll(await _schoolEvents(childId, start, end));
      candidates.addAll(await _journals(childId, start, end));
      candidates.addAll(await _photos(childId, start, end));
      candidates.add(await _birthdayItem(childId, childRow.name, dob, year));
      candidates.addAll(await _health(childId, start, end));

      if (growth.hasData) {
        candidates.add(
          YearReviewItem(
            id: 'growth-$year',
            section: YearReviewSection.growth,
            title: 'Growth',
            subtitle: _growthSubtitle(growth),
            eventDate: end,
            priority: YearReviewPriorities.growth,
            included: true,
            sortOrder: 0,
          ),
        );
      }

      final scored = candidates
          .map(
            (c) => c.copyWith(
              score: c.score > 0
                  ? c.score
                  : YearReviewScorer.scoreItem(c),
            ),
          )
          .toList();

      final beforeDedup = scored
          .where((i) => i.section == YearReviewSection.photos)
          .length;
      final selected = YearReviewHighlightSelector.apply(
        candidates: scored,
        savedSelection: YearReviewDraft.decodeSelection(
          preference?.selectionJson,
        ),
      );
      final afterDedup = selected
          .where((i) => i.section == YearReviewSection.photos)
          .length;
      final duplicatesRemoved = (beforeDedup - afterDedup).clamp(0, beforeDedup);

      var draft = YearReviewDraft(
        childId: childId,
        childName: childRow.name,
        dateOfBirth: dob,
        year: year,
        startDate: start,
        endDate: end,
        ageAtEnd: ageAtEnd,
        growth: growth,
        items: selected,
        parentLetter: preference?.parentLetter,
        coverAssetId: preference?.coverAssetId,
        theme: preference?.theme ?? AlbumThemes.minimal,
        includeHealth: preference?.includeHealth ?? false,
        languageCode: languageCode ?? preference?.languageCode ?? 'en',
        titleOverride: preference?.titleOverride,
        preferenceId: preference?.id,
        duplicatesRemoved: duplicatesRemoved,
      );

      final smart = YearReviewSmartSuggestionEngine.build(draft: draft);
      draft = draft.copyWith(
        suggestedTitleEn: smart.suggestedTitleEn,
        suggestedTitleBn: smart.suggestedTitleBn,
        sectionRecommendations: smart.sectionRecommendations,
        collageMediaAssetIds: smart.collageMediaAssetIds,
        coverAssetId: preference?.coverAssetId ?? smart.suggestedCoverAssetId,
        clearCoverAssetId: false,
      );
      return draft;
    }, operation: 'yearReview.buildDraft');
  }

  Future<GrowthSummary> _growthSummary(
    String childId,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.growthRecordsDao.forChild(childId);
    final inYear = rows
        .where(
          (r) =>
              !r.measuredAt.isBefore(start) && !r.measuredAt.isAfter(end),
        )
        .toList()
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    if (inYear.isEmpty) return const GrowthSummary();
    double? firstH;
    double? lastH;
    double? firstW;
    double? lastW;
    for (final r in inYear) {
      if (r.heightCm != null) {
        firstH ??= r.heightCm;
        lastH = r.heightCm;
      }
      if (r.weightKg != null) {
        firstW ??= r.weightKg;
        lastW = r.weightKg;
      }
    }
    return GrowthSummary(
      firstHeightCm: firstH,
      lastHeightCm: lastH,
      firstWeightKg: firstW,
      lastWeightKg: lastW,
      measurementCount: inYear.length,
    );
  }

  String _growthSubtitle(GrowthSummary g) {
    final parts = <String>[];
    if (g.firstHeightCm != null && g.lastHeightCm != null) {
      parts.add(
        '${g.firstHeightCm!.toStringAsFixed(1)} -> ${g.lastHeightCm!.toStringAsFixed(1)} cm',
      );
    }
    if (g.firstWeightKg != null && g.lastWeightKg != null) {
      parts.add(
        '${g.firstWeightKg!.toStringAsFixed(1)} -> ${g.lastWeightKg!.toStringAsFixed(1)} kg',
      );
    }
    parts.add('${g.measurementCount} measurements');
    return parts.join(' · ');
  }

  Future<List<YearReviewItem>> _milestones(
    String childId,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.milestonesDao.forChild(childId);
    final items = <YearReviewItem>[];
    for (final r in rows) {
      final date = r.eventDate;
      if (date == null || date.isBefore(start) || date.isAfter(end)) continue;
      items.add(
        YearReviewItem(
          id: 'milestone-${r.id}',
          section: YearReviewSection.milestones,
          title: r.title,
          subtitle: r.description,
          caption: r.description,
          eventDate: date,
          entityType: EntityTypes.milestone,
          entityId: r.id,
          priority: YearReviewPriorities.milestones,
        ),
      );
    }
    return items;
  }

  Future<List<YearReviewItem>> _achievements(
    String childId,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.achievementsDao.forChild(childId);
    return rows
        .where(
          (r) => !r.eventDate.isBefore(start) && !r.eventDate.isAfter(end),
        )
        .map((r) {
          final item = YearReviewItem(
            id: 'achievement-${r.id}',
            section: YearReviewSection.achievements,
            title: r.title,
            subtitle: r.description ?? r.category,
            caption: r.description,
            eventDate: r.eventDate,
            entityType: EntityTypes.achievement,
            entityId: r.id,
            priority: r.isFavorite
                ? YearReviewPriorities.favorites
                : YearReviewPriorities.achievements,
          );
          return item.copyWith(score: YearReviewScorer.scoreItem(item));
        })
        .toList();
  }

  Future<List<YearReviewItem>> _funnyMoments(
    String childId,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.funnyMomentsDao.forChild(childId);
    return rows
        .where(
          (r) => !r.eventDate.isBefore(start) && !r.eventDate.isAfter(end),
        )
        .map((r) {
          final quote = r.quoteText?.trim();
          final title = (r.title?.trim().isNotEmpty ?? false)
              ? r.title!.trim()
              : (quote != null && quote.isNotEmpty
                    ? quote
                    : (r.story?.trim() ?? 'Funny moment'));
          final item = YearReviewItem(
            id: 'funny-${r.id}',
            section: YearReviewSection.funnyMoments,
            title: title,
            subtitle: quote,
            caption: r.story ?? quote,
            eventDate: r.eventDate,
            entityType: EntityTypes.funnyMoment,
            entityId: r.id,
            priority: r.isFavorite
                ? YearReviewPriorities.favorites
                : YearReviewPriorities.funnyQuotes,
          );
          return item.copyWith(score: YearReviewScorer.scoreItem(item));
        })
        .toList();
  }

  Future<List<YearReviewItem>> _schoolEvents(
    String childId,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.schoolEventsDao.forChild(childId);
    return rows
        .where(
          (r) => !r.eventDate.isBefore(start) && !r.eventDate.isAfter(end),
        )
        .map(
          (r) => YearReviewItem(
            id: 'school-${r.id}',
            section: YearReviewSection.school,
            title: r.title,
            subtitle: r.description ?? r.eventType,
            caption: r.description,
            eventDate: r.eventDate,
            entityType: EntityTypes.schoolEvent,
            entityId: r.id,
            priority: YearReviewPriorities.school,
          ),
        )
        .toList();
  }

  Future<List<YearReviewItem>> _journals(
    String childId,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.journalEntriesDao.forChild(childId);
    return rows
        .where(
          (r) => !r.eventDate.isBefore(start) && !r.eventDate.isAfter(end),
        )
        .map((r) {
          final title = (r.title?.trim().isNotEmpty ?? false)
              ? r.title!.trim()
              : r.body.trim().split('\n').first;
          return YearReviewItem(
            id: 'journal-${r.id}',
            section: YearReviewSection.journals,
            title: title.length > 80 ? '${title.substring(0, 80)}…' : title,
            subtitle: r.body.trim().length > 120
                ? '${r.body.trim().substring(0, 120)}…'
                : r.body.trim(),
            caption: r.body,
            eventDate: r.eventDate,
            entityType: EntityTypes.journalEntry,
            entityId: r.id,
            priority: r.isFavorite
                ? YearReviewPriorities.favorites
                : YearReviewPriorities.journals,
          );
        })
        .toList();
  }

  Future<List<YearReviewItem>> _photos(
    String childId,
    DateTime start,
    DateTime end,
  ) async {
    final rows = await db.mediaAssetsDao.imagesForChild(childId);
    final items = <YearReviewItem>[];
    for (final row in rows) {
      final media = MediaAssetMapper.toDomain(row);
      if (media.assetType != MediaAssetType.image) continue;
      final date = media.capturedAt ?? media.importedAt;
      if (date.isBefore(start) || date.isAfter(end)) continue;
      final item = YearReviewItem(
        id: 'photo-${media.id}',
        section: YearReviewSection.photos,
        title: media.originalFilename ?? 'Photo',
        eventDate: date,
        mediaAssetId: media.id,
        entityType: EntityTypes.mediaAsset,
        entityId: media.id,
        priority: media.isFavorite
            ? YearReviewPriorities.favorites
            : YearReviewPriorities.photos,
        checksum: media.checksum,
      );
      items.add(
        item.copyWith(
          score: YearReviewScorer.scorePhoto(
            item: item,
            isFavorite: media.isFavorite,
            width: media.width,
            height: media.height,
          ),
        ),
      );
    }
    return items;
  }

  Future<YearReviewItem> _birthdayItem(
    String childId,
    String name,
    DateTime dob,
    int year,
  ) async {
    final birthday = DateTime(year, dob.month, dob.day);
    final ageYears = AgeCalculator.at(dob, birthday).years;
    final record = await db.birthdaysDao.forChildAge(childId, ageYears);
    return YearReviewItem(
      id: record?.id ?? 'birthday-$year',
      section: YearReviewSection.birthday,
      title: '$name turned $ageYears',
      subtitle: record?.theme ??
          record?.favoriteGift ??
          'Birthday',
      eventDate: record?.birthdayDate ?? birthday,
      mediaAssetId: record?.coverAssetId,
      entityType: record == null ? null : 'birthday',
      entityId: record?.id,
      priority: YearReviewPriorities.birthday,
      included: true,
      sortOrder: 0,
    );
  }

  Future<List<YearReviewItem>> _health(
    String childId,
    DateTime start,
    DateTime end,
  ) async {
    final items = <YearReviewItem>[];
    final vaccinations = await db.vaccinationsDao.forChild(childId);
    for (final r in vaccinations) {
      final date = r.givenDate ?? r.scheduledDate;
      if (date == null || date.isBefore(start) || date.isAfter(end)) continue;
      if (r.status != VaccinationStatuses.completed && r.givenDate == null) {
        continue;
      }
      items.add(
        YearReviewItem(
          id: 'vaccination-${r.id}',
          section: YearReviewSection.health,
          title: r.vaccineName,
          subtitle: r.doseLabel ?? 'Vaccination',
          eventDate: date,
          entityType: EntityTypes.vaccination,
          entityId: r.id,
          priority: YearReviewPriorities.health,
          included: false,
        ),
      );
    }
    final visits = await db.doctorVisitsDao.forChild(childId);
    for (final r in visits) {
      if (r.visitDate.isBefore(start) || r.visitDate.isAfter(end)) continue;
      items.add(
        YearReviewItem(
          id: 'doctor-${r.id}',
          section: YearReviewSection.health,
          title: r.doctorName.trim().isNotEmpty
              ? r.doctorName
              : 'Doctor visit',
          subtitle: r.reason ?? r.hospitalOrChamber,
          eventDate: r.visitDate,
          entityType: EntityTypes.doctorVisit,
          entityId: r.id,
          priority: YearReviewPriorities.health,
          included: false,
        ),
      );
    }
    return items;
  }
}
