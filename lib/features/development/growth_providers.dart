import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final growthHistoryProvider =
    FutureProvider.autoDispose<List<GrowthHistoryItem>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref.watch(growthRepositoryProvider).historyForChild(child.id);
    });

final latestGrowthProvider = FutureProvider.autoDispose<GrowthRecord?>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return null;
  return ref.watch(growthRepositoryProvider).latestForChild(child.id);
});

final growthChartProvider = FutureProvider.autoDispose
    .family<List<GrowthRecord>, GrowthChartRange>((ref, range) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      final all = await ref.watch(growthRepositoryProvider).forChild(child.id);
      if (range == GrowthChartRange.all) {
        return all.reversed.toList();
      }
      final cutoff = DateTime.now().subtract(
        range == GrowthChartRange.sixMonths
            ? const Duration(days: 183)
            : const Duration(days: 365),
      );
      return all
          .where((r) => !r.measuredAt.isBefore(cutoff))
          .toList()
          .reversed
          .toList();
    });

enum GrowthChartRange { sixMonths, oneYear, all }
