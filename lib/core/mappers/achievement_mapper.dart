import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/achievement.dart';

abstract final class AchievementMapper {
  static Achievement toDomain(AchievementRow row) {
    return Achievement(
      id: row.id,
      childId: row.childId,
      title: row.title,
      category: row.category,
      eventDate: row.eventDate,
      description: row.description,
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static AchievementsCompanion toCompanion(Achievement achievement) {
    return AchievementsCompanion(
      id: Value(achievement.id),
      childId: Value(achievement.childId),
      title: Value(achievement.title),
      category: Value(achievement.category),
      eventDate: Value(achievement.eventDate),
      description: Value(achievement.description),
      isFavorite: Value(achievement.isFavorite),
      createdAt: Value(achievement.createdAt),
      updatedAt: Value(achievement.updatedAt),
      deletedAt: Value(achievement.deletedAt),
    );
  }
}
