import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_highlight_selector.dart';

@immutable
class YearReviewSmartSuggestions {
  const YearReviewSmartSuggestions({
    required this.suggestedTitleEn,
    required this.suggestedTitleBn,
    required this.sectionRecommendations,
    required this.collageMediaAssetIds,
    required this.suggestedCoverAssetId,
  });

  final String suggestedTitleEn;
  final String suggestedTitleBn;
  final List<YearReviewSectionRecommendation> sectionRecommendations;
  final List<String> collageMediaAssetIds;
  final String? suggestedCoverAssetId;

  static const collageSizeDefault = 6;
}

abstract final class YearReviewSmartSuggestionEngine {
  static YearReviewSmartSuggestions build({
    required YearReviewDraft draft,
    int collageSize = YearReviewSmartSuggestions.collageSizeDefault,
  }) {
    final included = draft.items.where((i) => i.included).toList();
    final bySection = <YearReviewSection, List<YearReviewItem>>{};
    for (final item in draft.items) {
      bySection.putIfAbsent(item.section, () => []).add(item);
    }

    final recommendations = <YearReviewSectionRecommendation>[];
    for (final section in [
      YearReviewSection.milestones,
      YearReviewSection.achievements,
      YearReviewSection.funnyMoments,
      YearReviewSection.photos,
      YearReviewSection.school,
      YearReviewSection.journals,
      YearReviewSection.birthday,
      YearReviewSection.growth,
    ]) {
      final list = bySection[section] ?? const [];
      if (list.isEmpty) continue;
      final avg = list.map((i) => i.score).fold<double>(0, (a, b) => a + b) /
          list.length;
      final includedCount = list.where((i) => i.included).length;
      final emphasize = includedCount >= _emphasizeThreshold(section) ||
          avg >= 90 ||
          (section == YearReviewSection.photos && includedCount >= 4);
      recommendations.add(
        YearReviewSectionRecommendation(
          section: section,
          itemCount: includedCount,
          averageScore: avg,
          recommendEmphasize: emphasize,
          reasonKey: _reasonKey(section, emphasize),
        ),
      );
    }
    recommendations.sort((a, b) {
      final byEmph = (b.recommendEmphasize ? 1 : 0)
          .compareTo(a.recommendEmphasize ? 1 : 0);
      if (byEmph != 0) return byEmph;
      return b.averageScore.compareTo(a.averageScore);
    });

    final photoItems = included
        .where(
          (i) =>
              i.section == YearReviewSection.photos &&
              i.mediaAssetId != null &&
              i.mediaAssetId!.isNotEmpty,
        )
        .toList()
      ..sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        if (byScore != 0) return byScore;
        return b.eventDate.compareTo(a.eventDate);
      });

    final collageIds = <String>[];
    final seen = <String>{};
    for (final p in photoItems) {
      final id = p.mediaAssetId!;
      if (!seen.add(id)) continue;
      collageIds.add(id);
      if (collageIds.length >= collageSize) break;
    }

    String? favoriteCover;
    for (final p in photoItems) {
      if (p.priority <= YearReviewPriorities.favorites &&
          p.mediaAssetId != null) {
        favoriteCover = p.mediaAssetId;
        break;
      }
    }
    final cover = draft.coverAssetId ??
        favoriteCover ??
        (collageIds.isEmpty ? null : collageIds.first);

    final titles = _suggestTitles(draft, bySection);

    return YearReviewSmartSuggestions(
      suggestedTitleEn: titles.$1,
      suggestedTitleBn: titles.$2,
      sectionRecommendations: recommendations,
      collageMediaAssetIds: collageIds,
      suggestedCoverAssetId: cover,
    );
  }

  static int _emphasizeThreshold(YearReviewSection section) {
    return switch (section) {
      YearReviewSection.milestones => 2,
      YearReviewSection.achievements => 2,
      YearReviewSection.funnyMoments => 3,
      YearReviewSection.photos => 4,
      YearReviewSection.school => 2,
      YearReviewSection.journals => 3,
      YearReviewSection.birthday => 1,
      YearReviewSection.growth => 1,
      _ => 2,
    };
  }

  static String _reasonKey(YearReviewSection section, bool emphasize) {
    if (!emphasize) return 'yearReviewRecLight';
    return switch (section) {
      YearReviewSection.milestones => 'yearReviewRecMilestones',
      YearReviewSection.achievements => 'yearReviewRecAchievements',
      YearReviewSection.funnyMoments => 'yearReviewRecFunny',
      YearReviewSection.photos => 'yearReviewRecPhotos',
      YearReviewSection.school => 'yearReviewRecSchool',
      YearReviewSection.journals => 'yearReviewRecJournals',
      YearReviewSection.birthday => 'yearReviewRecBirthday',
      YearReviewSection.growth => 'yearReviewRecGrowth',
      _ => 'yearReviewRecLight',
    };
  }

  static (String, String) _suggestTitles(
    YearReviewDraft draft,
    Map<YearReviewSection, List<YearReviewItem>> bySection,
  ) {
    final name = draft.childName;
    final age = draft.ageAtEnd;
    final year = draft.year;

    int count(YearReviewSection s) =>
        (bySection[s] ?? const []).where((i) => i.included).length;

    final milestones = count(YearReviewSection.milestones);
    final funny = count(YearReviewSection.funnyMoments);
    final achievements = count(YearReviewSection.achievements);
    final photos = count(YearReviewSection.photos);
    final school = count(YearReviewSection.school);

    if (milestones >= 3 && milestones >= funny && milestones >= achievements) {
      return (
        '$name — Age $age: Growing Up in $year',
        '$name — $age বছর: $year-এর বেড়ে ওঠা',
      );
    }
    if (funny >= 3 && funny >= achievements) {
      return (
        '$name — Age $age: Laughs of $year',
        '$name — $age বছর: $year-এর হাসি',
      );
    }
    if (achievements >= 3) {
      return (
        '$name — Age $age: Proud Moments of $year',
        '$name — $age বছর: $year-এর গর্বের মুহূর্ত',
      );
    }
    if (school >= 2 && school >= photos) {
      return (
        '$name — Age $age: School Year $year',
        '$name — $age বছর: $year স্কুলের বছর',
      );
    }
    if (photos >= 6) {
      return (
        '$name — Age $age: Pictures of $year',
        '$name — $age বছর: $year-এর ছবি',
      );
    }
    return (
      '$name — Age $age: Year in Review',
      '$name — $age বছর: বছরের স্মৃতিচারণ',
    );
  }
}
