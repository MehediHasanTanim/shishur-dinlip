import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_highlight_selector.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_scorer.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_smart_suggestions.dart';

void main() {
  group('YearReviewScorer', () {
    test('favorites and captions outrank plain photos', () {
      final plain = YearReviewItem(
        id: 'p1',
        section: YearReviewSection.photos,
        title: 'Plain',
        eventDate: DateTime(2024, 6, 1),
        priority: YearReviewPriorities.photos,
        mediaAssetId: 'm1',
      );
      final favorite = YearReviewItem(
        id: 'p2',
        section: YearReviewSection.photos,
        title: 'Fav',
        eventDate: DateTime(2024, 6, 1),
        priority: YearReviewPriorities.favorites,
        mediaAssetId: 'm2',
        caption: 'Beach day',
      );

      final plainScore = YearReviewScorer.scorePhoto(
        item: plain,
        isFavorite: false,
        width: 640,
        height: 480,
      );
      final favScore = YearReviewScorer.scorePhoto(
        item: favorite,
        isFavorite: true,
        width: 1600,
        height: 1200,
      );
      expect(favScore, greaterThan(plainScore));
    });
  });

  group('duplicate photo removal', () {
    test('keeps highest scoring checksum and drops duplicates', () {
      final items = [
        YearReviewItem(
          id: 'a',
          section: YearReviewSection.photos,
          title: 'A',
          eventDate: DateTime(2024, 1, 1),
          priority: YearReviewPriorities.photos,
          score: 40,
          checksum: 'same',
          mediaAssetId: 'm-a',
        ),
        YearReviewItem(
          id: 'b',
          section: YearReviewSection.photos,
          title: 'B',
          eventDate: DateTime(2024, 2, 1),
          priority: YearReviewPriorities.favorites,
          score: 160,
          checksum: 'same',
          mediaAssetId: 'm-b',
        ),
        YearReviewItem(
          id: 'c',
          section: YearReviewSection.photos,
          title: 'C',
          eventDate: DateTime(2024, 3, 1),
          priority: YearReviewPriorities.photos,
          score: 50,
          checksum: 'other',
          mediaAssetId: 'm-c',
        ),
        YearReviewItem(
          id: 'm1',
          section: YearReviewSection.milestones,
          title: 'Walked',
          eventDate: DateTime(2024, 4, 1),
          priority: YearReviewPriorities.milestones,
          score: 90,
        ),
      ];

      final deduped = YearReviewHighlightSelector.removeDuplicatePhotos(items);
      expect(deduped.where((i) => i.section == YearReviewSection.photos), hasLength(2));
      expect(deduped.any((i) => i.id == 'b'), isTrue);
      expect(deduped.any((i) => i.id == 'a'), isFalse);
      expect(deduped.any((i) => i.id == 'm1'), isTrue);

      final selected = YearReviewHighlightSelector.apply(candidates: items);
      expect(
        selected.where((i) => i.section == YearReviewSection.photos).length,
        2,
      );
      expect(selected.firstWhere((i) => i.id == 'b').included, isTrue);
    });
  });

  group('smart suggestions', () {
    test('suggests title collage and section emphasis', () {
      final items = <YearReviewItem>[
        for (var i = 0; i < 4; i++)
          YearReviewItem(
            id: 'ms-$i',
            section: YearReviewSection.milestones,
            title: 'Milestone $i',
            eventDate: DateTime(2024, 1, i + 1),
            priority: YearReviewPriorities.milestones,
            score: 100,
            included: true,
          ),
        for (var i = 0; i < 6; i++)
          YearReviewItem(
            id: 'ph-$i',
            section: YearReviewSection.photos,
            title: 'Photo $i',
            eventDate: DateTime(2024, 5, i + 1),
            priority: i == 0
                ? YearReviewPriorities.favorites
                : YearReviewPriorities.photos,
            score: i == 0 ? 170 : 60.0 + i,
            included: true,
            mediaAssetId: 'media-$i',
            checksum: 'c-$i',
          ),
      ];

      final draft = YearReviewDraft(
        childId: 'child',
        childName: 'Azwad',
        dateOfBirth: DateTime(2018, 1, 1),
        year: 2024,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        ageAtEnd: 6,
        items: items,
      );

      final smart = YearReviewSmartSuggestionEngine.build(draft: draft);
      expect(smart.suggestedTitleEn, contains('Growing Up'));
      expect(smart.suggestedTitleBn, contains('বেড়ে ওঠা'));
      expect(smart.collageMediaAssetIds.length, greaterThanOrEqualTo(4));
      expect(smart.collageMediaAssetIds.first, 'media-0');
      expect(
        smart.sectionRecommendations.any(
          (r) =>
              r.section == YearReviewSection.milestones &&
              r.recommendEmphasize,
        ),
        isTrue,
      );
    });
  });
}
