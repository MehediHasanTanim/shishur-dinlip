import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/allergy.dart';
import 'package:shishur_dinlipi/core/domain/models/doctor_visit.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final vaccinationsProvider = FutureProvider.autoDispose<List<Vaccination>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(vaccinationsRepositoryProvider).forChild(child.id);
});

final upcomingVaccinationsProvider =
    FutureProvider.autoDispose<List<Vaccination>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref
          .watch(vaccinationsRepositoryProvider)
          .upcomingForChild(child.id, limit: 3);
    });

final illnessEpisodesProvider =
    FutureProvider.autoDispose<List<IllnessEpisode>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref.watch(illnessEpisodesRepositoryProvider).forChild(child.id);
    });

final recentIllnessProvider = FutureProvider.autoDispose<IllnessEpisode?>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return null;
  return ref.watch(illnessEpisodesRepositoryProvider).latestForChild(child.id);
});

final medicinesProvider = FutureProvider.autoDispose<List<Medicine>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(medicinesRepositoryProvider).forChild(child.id);
});

final activeMedicinesProvider = FutureProvider.autoDispose<List<Medicine>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(medicinesRepositoryProvider).activeForChild(child.id);
});

final doctorVisitsProvider = FutureProvider.autoDispose<List<DoctorVisit>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(doctorVisitsRepositoryProvider).forChild(child.id);
});

final latestDoctorVisitProvider = FutureProvider.autoDispose<DoctorVisit?>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return null;
  return ref.watch(doctorVisitsRepositoryProvider).latestForChild(child.id);
});

final upcomingFollowUpsProvider =
    FutureProvider.autoDispose<List<DoctorVisit>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref
          .watch(doctorVisitsRepositoryProvider)
          .upcomingFollowUps(child.id, limit: 3);
    });

final medicalDocumentsProvider =
    FutureProvider.autoDispose<List<MedicalDocument>>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      return ref.watch(medicalDocumentsRepositoryProvider).forChild(child.id);
    });

final allergiesProvider = FutureProvider.autoDispose<List<Allergy>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(allergiesRepositoryProvider).forChild(child.id);
});

final latestGrowthForHealthProvider =
    FutureProvider.autoDispose<GrowthRecord?>((ref) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return null;
      final list = await ref
          .watch(growthRepositoryProvider)
          .forChild(child.id, limit: 1);
      return list.isEmpty ? null : list.first;
    });

class HealthSummary {
  const HealthSummary({
    this.bloodGroup,
    this.latestGrowth,
    this.activeMedicines = const [],
    this.allergies = const [],
    this.recentIllness,
    this.recentVaccination,
    this.latestDoctorVisit,
    this.upcomingVaccines = const [],
    this.upcomingFollowUps = const [],
  });

  final String? bloodGroup;
  final GrowthRecord? latestGrowth;
  final List<Medicine> activeMedicines;
  final List<Allergy> allergies;
  final IllnessEpisode? recentIllness;
  final Vaccination? recentVaccination;
  final DoctorVisit? latestDoctorVisit;
  final List<Vaccination> upcomingVaccines;
  final List<DoctorVisit> upcomingFollowUps;
}

final healthSummaryProvider = FutureProvider.autoDispose<HealthSummary>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const HealthSummary();

  final vaccines = await ref
      .watch(vaccinationsRepositoryProvider)
      .forChild(child.id, limit: 1);
  final growth = await ref.watch(latestGrowthForHealthProvider.future);
  final activeMeds = await ref.watch(activeMedicinesProvider.future);
  final allergies = await ref.watch(allergiesProvider.future);
  final illness = await ref.watch(recentIllnessProvider.future);
  final visit = await ref.watch(latestDoctorVisitProvider.future);
  final upcomingVax = await ref.watch(upcomingVaccinationsProvider.future);
  final followUps = await ref.watch(upcomingFollowUpsProvider.future);

  return HealthSummary(
    bloodGroup: child.bloodGroup,
    latestGrowth: growth,
    activeMedicines: activeMeds,
    allergies: allergies,
    recentIllness: illness,
    recentVaccination: vaccines.isEmpty ? null : vaccines.first,
    latestDoctorVisit: visit,
    upcomingVaccines: upcomingVax,
    upcomingFollowUps: followUps,
  );
});
