import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';

abstract final class YearReviewPreferenceMapper {
  static YearReviewPreference toDomain(YearReviewPreferenceRow row) {
    return YearReviewPreference(
      id: row.id,
      childId: row.childId,
      year: row.year,
      parentLetter: row.parentLetter,
      coverAssetId: row.coverAssetId,
      theme: row.theme,
      includeHealth: row.includeHealth,
      languageCode: row.languageCode,
      selectionJson: row.selectionJson,
      titleOverride: row.titleOverride,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static YearReviewPreferencesCompanion toCompanion(
    YearReviewPreference preference,
  ) {
    return YearReviewPreferencesCompanion(
      id: Value(preference.id),
      childId: Value(preference.childId),
      year: Value(preference.year),
      parentLetter: Value(preference.parentLetter),
      coverAssetId: Value(preference.coverAssetId),
      theme: Value(preference.theme),
      includeHealth: Value(preference.includeHealth),
      languageCode: Value(preference.languageCode),
      selectionJson: Value(preference.selectionJson),
      titleOverride: Value(preference.titleOverride),
      createdAt: Value(preference.createdAt),
      updatedAt: Value(preference.updatedAt),
      deletedAt: Value(preference.deletedAt),
    );
  }
}
