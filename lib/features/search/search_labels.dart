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
  };
}

void openSearchResult(BuildContext context, SearchResult result) {
  final path = searchResultDetailPath(result);
  if (path != null) context.push(path);
}
