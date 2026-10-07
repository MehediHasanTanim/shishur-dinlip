// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_review_preferences_dao.dart';

// ignore_for_file: type=lint
mixin _$YearReviewPreferencesDaoMixin on DatabaseAccessor<AppDatabase> {
  $YearReviewPreferencesTable get yearReviewPreferences =>
      attachedDatabase.yearReviewPreferences;
  YearReviewPreferencesDaoManager get managers =>
      YearReviewPreferencesDaoManager(this);
}

class YearReviewPreferencesDaoManager {
  final _$YearReviewPreferencesDaoMixin _db;
  YearReviewPreferencesDaoManager(this._db);
  $$YearReviewPreferencesTableTableManager get yearReviewPreferences =>
      $$YearReviewPreferencesTableTableManager(
        _db.attachedDatabase,
        _db.yearReviewPreferences,
      );
}
