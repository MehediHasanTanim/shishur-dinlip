import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final birthdaysListProvider = FutureProvider.autoDispose<List<Birthday>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(birthdaysRepositoryProvider).forChild(child.id);
});

final birthdayDetailProvider =
    FutureProvider.autoDispose.family<Birthday?, String>((ref, id) {
      return ref.watch(birthdaysRepositoryProvider).getById(id);
    });

final birthdayCompareProvider =
    FutureProvider.autoDispose<List<BirthdayAnswerComparison>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref
          .watch(birthdaysRepositoryProvider)
          .compareAnswersByAge(child.id);
    });

final favoritesGroupedProvider =
    FutureProvider.autoDispose<Map<String, List<Favorite>>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const {};
      return ref.watch(favoritesRepositoryProvider).groupedByCategory(child.id);
    });

final favoriteDetailProvider =
    FutureProvider.autoDispose.family<Favorite?, String>((ref, id) {
      return ref.watch(favoritesRepositoryProvider).getById(id);
    });
