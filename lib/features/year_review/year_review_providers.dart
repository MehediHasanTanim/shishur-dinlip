import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

export 'package:shishur_dinlipi/core/di/core_providers.dart'
    show
        yearReviewPreferencesRepositoryProvider,
        yearReviewQueryServiceProvider,
        yearReviewPdfGeneratorProvider;

final yearReviewAvailableYearsProvider = Provider<List<int>>((ref) {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  final nowYear = DateTime.now().year;
  final startYear = child.dateOfBirth.year;
  if (startYear > nowYear) return [nowYear];
  return [for (var y = nowYear; y >= startYear; y--) y];
});

final yearReviewDraftProvider = FutureProvider.autoDispose
    .family<YearReviewDraft, int>((ref, year) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) {
        throw StateError('No child selected');
      }
      final settings = ref.watch(settingsControllerProvider).valueOrNull;
      final languageCode = switch (settings?.language) {
        AppLanguage.bangla => 'bn',
        _ => 'en',
      };
      return ref
          .watch(yearReviewQueryServiceProvider)
          .buildDraft(
            childId: child.id,
            year: year,
            languageCode: languageCode,
          );
    });
