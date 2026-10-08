import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/allergy.dart';

abstract final class AllergyMapper {
  static Allergy toDomain(AllergyRow row) {
    return Allergy(
      id: row.id,
      childId: row.childId,
      allergen: row.allergen,
      allergyType: row.allergyType,
      reaction: row.reaction,
      severity: row.severity,
      firstObserved: row.firstObserved,
      doctorConfirmed: row.doctorConfirmed,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static AllergiesCompanion toCompanion(Allergy item) {
    return AllergiesCompanion(
      id: Value(item.id),
      childId: Value(item.childId),
      allergen: Value(item.allergen),
      allergyType: Value(item.allergyType),
      reaction: Value(item.reaction),
      severity: Value(item.severity),
      firstObserved: Value(item.firstObserved),
      doctorConfirmed: Value(item.doctorConfirmed),
      notes: Value(item.notes),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }
}
