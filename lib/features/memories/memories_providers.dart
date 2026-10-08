import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/achievement.dart';
import 'package:shishur_dinlipi/core/domain/models/funny_moment.dart';
import 'package:shishur_dinlipi/core/domain/models/journal_entry.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final journalEntriesProvider =
    FutureProvider.autoDispose<List<JournalEntry>>((ref) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(journalRepositoryProvider).forChild(child.id);
});

final funnyMomentsListProvider =
    FutureProvider.autoDispose<List<FunnyMoment>>((ref) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(funnyMomentsRepositoryProvider).forChild(child.id);
});

final achievementsListProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(achievementsRepositoryProvider).forChild(child.id);
});
