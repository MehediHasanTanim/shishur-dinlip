import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_highlight_selector.dart';

/// Deterministic highlight scores (no external AI).
///
/// Higher score = more likely to be included / ranked first.
abstract final class YearReviewScorer {
  static const favoriteBonus = 100.0;
  static const captionBonus = 18.0;
  static const mediaBonus = 12.0;
  static const largePhotoBonus = 10.0;

  static double scoreItem(
    YearReviewItem item, {
    int? photoPixelCount,
    bool isFavoritePhoto = false,
  }) {
    var score = _sectionBase(item.section);

    if (item.priority <= YearReviewPriorities.favorites || isFavoritePhoto) {
      score += favoriteBonus;
    }

    final caption = (item.caption ?? item.subtitle)?.trim() ?? '';
    if (caption.isNotEmpty) score += captionBonus;

    if (item.mediaAssetId != null && item.mediaAssetId!.isNotEmpty) {
      score += mediaBonus;
    }

    if (photoPixelCount != null && photoPixelCount >= 800 * 600) {
      score += largePhotoBonus;
    }

    // Mild preference for mid/late-year memories (story arc).
    final day = item.eventDate.month * 30 + item.eventDate.day;
    score += (day / 400.0) * 8.0;

    // Priority buckets still matter as a tie-breaker base.
    score += (100 - item.priority).clamp(0, 100) * 0.15;

    return score;
  }

  static double _sectionBase(YearReviewSection section) {
    return switch (section) {
      YearReviewSection.milestones => 80,
      YearReviewSection.birthday => 78,
      YearReviewSection.achievements => 72,
      YearReviewSection.funnyMoments => 65,
      YearReviewSection.school => 55,
      YearReviewSection.photos => 48,
      YearReviewSection.journals => 42,
      YearReviewSection.growth => 38,
      YearReviewSection.health => 15,
      YearReviewSection.parentLetter => 20,
    };
  }

  /// Photo-specific score using favorite flag and dimensions.
  static double scorePhoto({
    required YearReviewItem item,
    required bool isFavorite,
    int? width,
    int? height,
  }) {
    final pixels = (width != null && height != null) ? width * height : null;
    return scoreItem(
      item,
      photoPixelCount: pixels,
      isFavoritePhoto: isFavorite,
    );
  }
}
