import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';

abstract final class ChildMapper {
  static Child toDomain(ChildRow row) {
    return Child(
      id: row.id,
      name: row.name,
      nickname: row.nickname,
      dateOfBirth: row.dateOfBirth,
      gender: row.gender,
      bloodGroup: row.bloodGroup,
      birthWeightKg: row.birthWeightKg,
      birthHeightCm: row.birthHeightCm,
      birthplace: row.birthplace,
      schoolName: row.schoolName,
      className: row.className,
      profilePhotoId: row.profilePhotoId,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static ChildrenCompanion toCompanion(Child child) {
    return ChildrenCompanion(
      id: Value(child.id),
      name: Value(child.name),
      nickname: Value(child.nickname),
      dateOfBirth: Value(child.dateOfBirth),
      gender: Value(child.gender),
      bloodGroup: Value(child.bloodGroup),
      birthWeightKg: Value(child.birthWeightKg),
      birthHeightCm: Value(child.birthHeightCm),
      birthplace: Value(child.birthplace),
      schoolName: Value(child.schoolName),
      className: Value(child.className),
      profilePhotoId: Value(child.profilePhotoId),
      notes: Value(child.notes),
      createdAt: Value(child.createdAt),
      updatedAt: Value(child.updatedAt),
      deletedAt: Value(child.deletedAt),
    );
  }
}
