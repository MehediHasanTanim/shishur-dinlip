import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/school_event.dart';
import 'package:shishur_dinlipi/core/domain/models/school_profile.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final schoolProfilesProvider =
    FutureProvider.autoDispose<List<SchoolProfile>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref.watch(schoolProfilesRepositoryProvider).forChild(child.id);
    });

final currentSchoolProvider = FutureProvider.autoDispose<SchoolProfile?>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return null;
  return ref.watch(schoolProfilesRepositoryProvider).currentForChild(child.id);
});

final schoolTimelineProvider =
    FutureProvider.autoDispose<List<SchoolEvent>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref.watch(schoolEventsRepositoryProvider).forChild(child.id);
    });

final recentSchoolEventProvider = FutureProvider.autoDispose<SchoolEvent?>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return null;
  final list = await ref
      .watch(schoolEventsRepositoryProvider)
      .forChild(child.id, limit: 1);
  return list.isEmpty ? null : list.first;
});

final upcomingSchoolEventsProvider =
    FutureProvider.autoDispose<List<SchoolEvent>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref
          .watch(schoolEventsRepositoryProvider)
          .upcomingForChild(child.id, limit: 3);
    });
