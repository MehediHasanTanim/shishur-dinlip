import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/family_event.dart';
import 'package:shishur_dinlipi/core/domain/models/interest.dart';
import 'package:shishur_dinlipi/core/domain/models/trip.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final interestsListProvider = FutureProvider.autoDispose<List<Interest>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(interestsRepositoryProvider).forChild(child.id);
});

final interestDetailProvider =
    FutureProvider.autoDispose.family<Interest?, String>((ref, id) {
      return ref.watch(interestsRepositoryProvider).getById(id);
    });

final familyEventsListProvider =
    FutureProvider.autoDispose<List<FamilyEvent>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref.watch(familyEventsRepositoryProvider).forChild(child.id);
    });

final familyEventDetailProvider =
    FutureProvider.autoDispose.family<FamilyEvent?, String>((ref, id) {
      return ref.watch(familyEventsRepositoryProvider).getById(id);
    });

final tripsListProvider = FutureProvider.autoDispose<List<Trip>>((ref) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(tripsRepositoryProvider).forChild(child.id);
});

final tripDetailProvider =
    FutureProvider.autoDispose.family<Trip?, String>((ref, id) {
      return ref.watch(tripsRepositoryProvider).getById(id);
    });

/// Compact home cards: top interests + recent family/trips.
final homeLifeCardsProvider =
    FutureProvider.autoDispose<({List<Interest> interests, List<FamilyEvent> events, List<Trip> trips})>((
      ref,
    ) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) {
        return (interests: const <Interest>[], events: const <FamilyEvent>[], trips: const <Trip>[]);
      }
      final interests = await ref
          .watch(interestsRepositoryProvider)
          .forChild(child.id, limit: 3);
      final events = await ref
          .watch(familyEventsRepositoryProvider)
          .forChild(child.id, limit: 3);
      final trips = await ref
          .watch(tripsRepositoryProvider)
          .forChild(child.id, limit: 3);
      return (interests: interests, events: events, trips: trips);
    });
