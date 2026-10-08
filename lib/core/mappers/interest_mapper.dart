import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/interest.dart';

abstract final class InterestMapper {
  static Interest toDomain(InterestRow row) {
    return Interest(
      id: row.id,
      childId: row.childId,
      name: row.name,
      firstNoticed: row.firstNoticed,
      interestLevel: row.interestLevel,
      notes: row.notes,
      coverAssetId: row.coverAssetId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static InterestsCompanion toCompanion(Interest interest) {
    return InterestsCompanion(
      id: Value(interest.id),
      childId: Value(interest.childId),
      name: Value(interest.name),
      firstNoticed: Value(interest.firstNoticed),
      interestLevel: Value(interest.interestLevel),
      notes: Value(interest.notes),
      coverAssetId: Value(interest.coverAssetId),
      createdAt: Value(interest.createdAt),
      updatedAt: Value(interest.updatedAt),
      deletedAt: Value(interest.deletedAt),
    );
  }
}
