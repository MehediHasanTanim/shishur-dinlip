import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/search_result.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

String searchTypeLabel(AppLocalizations l10n, SearchResultType type) {
  return switch (type) {
    SearchResultType.journal => l10n.searchTypeJournal,
    SearchResultType.milestone => l10n.searchTypeMilestone,
    SearchResultType.medicine => l10n.searchTypeMedicine,
    SearchResultType.doctorVisit => l10n.searchTypeDoctor,
    SearchResultType.illness => l10n.searchTypeIllness,
    SearchResultType.schoolEvent => l10n.searchTypeSchool,
    SearchResultType.achievement => l10n.searchTypeAchievement,
    SearchResultType.birthday => l10n.searchTypeBirthday,
    SearchResultType.favorite => l10n.searchTypeFavorite,
    SearchResultType.interest => l10n.searchTypeInterest,
    SearchResultType.familyEvent => l10n.searchTypeFamilyEvent,
    SearchResultType.trip => l10n.searchTypeTrip,
  };
}

IconData searchTypeIcon(SearchResultType type) {
  return switch (type) {
    SearchResultType.journal => Icons.auto_stories_outlined,
    SearchResultType.milestone => Icons.stairs_outlined,
    SearchResultType.medicine => Icons.medication_outlined,
    SearchResultType.doctorVisit => Icons.medical_services_outlined,
    SearchResultType.illness => Icons.healing_outlined,
    SearchResultType.schoolEvent => Icons.school_outlined,
    SearchResultType.achievement => Icons.emoji_events_outlined,
    SearchResultType.birthday => Icons.cake_outlined,
    SearchResultType.favorite => Icons.favorite_outline,
    SearchResultType.interest => Icons.interests_outlined,
    SearchResultType.familyEvent => Icons.family_restroom_outlined,
    SearchResultType.trip => Icons.flight_takeoff_outlined,
  };
}

String? searchResultDetailPath(SearchResult result) {
  return switch (result.type) {
    SearchResultType.journal => AppRoutes.journalDetailPath(result.id),
    SearchResultType.milestone => AppRoutes.milestoneDetailPath(result.id),
    SearchResultType.medicine => AppRoutes.medicineDetailPath(result.id),
    SearchResultType.doctorVisit => AppRoutes.doctorVisitDetailPath(result.id),
    SearchResultType.illness => AppRoutes.illnessDetailPath(result.id),
    SearchResultType.schoolEvent => AppRoutes.schoolEventDetailPath(result.id),
    SearchResultType.achievement => AppRoutes.achievementDetailPath(result.id),
    SearchResultType.birthday => AppRoutes.birthdayDetailPath(result.id),
    SearchResultType.favorite => AppRoutes.favoriteEditPath(result.id),
    SearchResultType.interest => AppRoutes.interestDetailPath(result.id),
    SearchResultType.familyEvent =>
      AppRoutes.familyEventDetailPath(result.id),
    SearchResultType.trip => AppRoutes.tripDetailPath(result.id),
  };
}

void openSearchResult(BuildContext context, SearchResult result) {
  final path = searchResultDetailPath(result);
  if (path != null) context.push(path);
}
