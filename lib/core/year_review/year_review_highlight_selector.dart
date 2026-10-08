import 'package:shishur_dinlipi/core/domain/models/year_review.dart';

/// Priority ranks for highlight selection (lower = higher priority).
abstract final class YearReviewPriorities {
  static const favorites = 10;
  static const milestones = 20;
  static const achievements = 30;
  static const birthday = 40;
  static const funnyQuotes = 50;
  static const school = 60;
  static const photos = 70;
  static const journals = 80;
  static const growth = 85;
  static const health = 90;
}

abstract final class YearReviewHighlightSelector {
  static const maxPhotosDefault = 24;
  static const maxJournalsDefault = 12;
  static const maxFunnyDefault = 12;
  static const maxSchoolDefault = 12;
  static const maxHealthDefault = 8;

  /// Merges candidates with optional saved include/caption/order state,
  /// then applies default inclusion caps by section + score.
  static List<YearReviewItem> apply({
    required List<YearReviewItem> candidates,
    List<YearReviewItem> savedSelection = const [],
  }) {
    final deduped = removeDuplicatePhotos(candidates);
    final savedById = {for (final s in savedSelection) s.id: s};

    final merged = deduped.map((c) {
      final saved = savedById[c.id];
      if (saved == null) return c;
      return c.copyWith(
        included: saved.included,
        caption: saved.caption ?? c.caption,
        sortOrder: saved.sortOrder,
        title: saved.title.isNotEmpty ? saved.title : c.title,
        subtitle: saved.subtitle ?? c.subtitle,
        score: c.score > 0 ? c.score : saved.score,
      );
    }).toList();

    // Preserve orphaned saved items that may no longer be queryable.
    for (final saved in savedSelection) {
      if (merged.any((m) => m.id == saved.id)) continue;
      merged.add(saved);
    }

    final hasSaved = savedSelection.isNotEmpty;
    if (hasSaved) {
      return _assignSortOrders(merged);
    }

    return _assignSortOrders(_applyDefaults(merged));
  }

  /// Keeps the highest-scoring photo per checksum (favorites win ties).
  static List<YearReviewItem> removeDuplicatePhotos(List<YearReviewItem> items) {
    final bestByChecksum = <String, YearReviewItem>{};
    final withoutDupes = <YearReviewItem>[];

    for (final item in items) {
      if (item.section != YearReviewSection.photos) {
        withoutDupes.add(item);
        continue;
      }
      final key = item.checksum?.trim();
      if (key == null || key.isEmpty) {
        withoutDupes.add(item);
        continue;
      }
      final existing = bestByChecksum[key];
      if (existing == null || _isBetterPhoto(item, existing)) {
        bestByChecksum[key] = item;
      }
    }
    withoutDupes.addAll(bestByChecksum.values);
    return withoutDupes;
  }

  static bool _isBetterPhoto(YearReviewItem a, YearReviewItem b) {
    if (a.score != b.score) return a.score > b.score;
    if (a.priority != b.priority) return a.priority < b.priority;
    return a.eventDate.isAfter(b.eventDate);
  }

  static List<YearReviewItem> _applyDefaults(List<YearReviewItem> items) {
    final bySection = <YearReviewSection, List<YearReviewItem>>{};
    for (final item in items) {
      bySection.putIfAbsent(item.section, () => []).add(item);
    }

    final result = <YearReviewItem>[];
    for (final section in YearReviewSection.values) {
      final list = bySection[section] ?? const [];
      if (list.isEmpty) continue;
      final sorted = [...list]..sort(_compareByScoreThenPriority);

      switch (section) {
        case YearReviewSection.growth:
        case YearReviewSection.birthday:
        case YearReviewSection.parentLetter:
          result.addAll(sorted.map((i) => i.copyWith(included: true)));
        case YearReviewSection.milestones:
        case YearReviewSection.achievements:
          result.addAll(sorted.map((i) => i.copyWith(included: true)));
        case YearReviewSection.funnyMoments:
          result.addAll(_capInclude(sorted, maxFunnyDefault));
        case YearReviewSection.school:
          result.addAll(_capInclude(sorted, maxSchoolDefault));
        case YearReviewSection.photos:
          result.addAll(_capInclude(sorted, maxPhotosDefault));
        case YearReviewSection.journals:
          result.addAll(_capInclude(sorted, maxJournalsDefault));
        case YearReviewSection.health:
          result.addAll(
            sorted.map((i) => i.copyWith(included: false)),
          );
      }
    }
    return result;
  }

  static int _compareByScoreThenPriority(YearReviewItem a, YearReviewItem b) {
    final byScore = b.score.compareTo(a.score);
    if (byScore != 0) return byScore;
    final byPriority = a.priority.compareTo(b.priority);
    if (byPriority != 0) return byPriority;
    return b.eventDate.compareTo(a.eventDate);
  }

  static List<YearReviewItem> _capInclude(
    List<YearReviewItem> sorted,
    int maxIncluded,
  ) {
    final out = <YearReviewItem>[];
    var includedCount = 0;
    for (final item in sorted) {
      final forceFavorite = item.priority <= YearReviewPriorities.favorites ||
          item.score >= 140;
      final include = forceFavorite || includedCount < maxIncluded;
      if (include) includedCount++;
      out.add(item.copyWith(included: include));
    }
    return out;
  }

  static List<YearReviewItem> _assignSortOrders(List<YearReviewItem> items) {
    final bySection = <YearReviewSection, List<YearReviewItem>>{};
    for (final item in items) {
      bySection.putIfAbsent(item.section, () => []).add(item);
    }
    final out = <YearReviewItem>[];
    for (final section in YearReviewSection.values) {
      final list = bySection[section];
      if (list == null) continue;
      list.sort((a, b) {
        final byOrder = a.sortOrder.compareTo(b.sortOrder);
        if (byOrder != 0 && (a.sortOrder != 0 || b.sortOrder != 0)) {
          return byOrder;
        }
        return _compareByScoreThenPriority(a, b);
      });
      for (var i = 0; i < list.length; i++) {
        out.add(list[i].copyWith(sortOrder: i));
      }
    }
    return out;
  }

  /// Reorders items within a section; returns full list with updated sortOrder.
  static List<YearReviewItem> reorderSection({
    required List<YearReviewItem> items,
    required YearReviewSection section,
    required int oldIndex,
    required int newIndex,
  }) {
    final sectionItems = items
        .where((i) => i.section == section)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (oldIndex < 0 ||
        oldIndex >= sectionItems.length ||
        newIndex < 0 ||
        newIndex >= sectionItems.length) {
      return items;
    }
    var target = newIndex;
    if (target > oldIndex) target -= 1;
    final moved = sectionItems.removeAt(oldIndex);
    sectionItems.insert(target, moved);
    final reorderedIds = {
      for (var i = 0; i < sectionItems.length; i++) sectionItems[i].id: i,
    };
    return items
        .map((i) {
          if (i.section != section) return i;
          return i.copyWith(sortOrder: reorderedIds[i.id] ?? i.sortOrder);
        })
        .toList();
  }
}
