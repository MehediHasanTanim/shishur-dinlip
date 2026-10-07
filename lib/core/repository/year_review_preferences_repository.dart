import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/mappers/year_review_preference_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class YearReviewPreferencesRepository implements Repository {
  Future<YearReviewPreference?> forChildYear(String childId, int year);
  Future<List<YearReviewPreference>> forChild(String childId);
  Future<YearReviewPreference> save(YearReviewPreference preference);
  Future<void> softDelete(String id);
}

class DriftYearReviewPreferencesRepository extends RepositoryBase
    implements YearReviewPreferencesRepository {
  DriftYearReviewPreferencesRepository(super.db);

  @override
  Future<YearReviewPreference?> forChildYear(String childId, int year) {
    return guard(() async {
      final row = await db.yearReviewPreferencesDao.forChildYear(
        childId,
        year,
      );
      return row == null ? null : YearReviewPreferenceMapper.toDomain(row);
    }, operation: 'yearReviewPreferences.forChildYear');
  }

  @override
  Future<List<YearReviewPreference>> forChild(String childId) {
    return guard(() async {
      final rows = await db.yearReviewPreferencesDao.forChild(childId);
      return rows.map(YearReviewPreferenceMapper.toDomain).toList();
    }, operation: 'yearReviewPreferences.forChild');
  }

  @override
  Future<YearReviewPreference> save(YearReviewPreference preference) {
    return guard(() async {
      await db.yearReviewPreferencesDao.upsert(
        YearReviewPreferenceMapper.toCompanion(preference),
      );
      final row = await db.yearReviewPreferencesDao.getById(preference.id);
      return YearReviewPreferenceMapper.toDomain(row!);
    }, operation: 'yearReviewPreferences.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.yearReviewPreferencesDao.softDelete(id, now());
    }, operation: 'yearReviewPreferences.softDelete');
  }
}
