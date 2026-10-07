import 'package:flutter/foundation.dart';

@immutable
class Child {
  const Child({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
    this.nickname,
    this.gender,
    this.bloodGroup,
    this.birthWeightKg,
    this.birthHeightCm,
    this.birthplace,
    this.schoolName,
    this.className,
    this.profilePhotoId,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String name;
  final String? nickname;
  final DateTime dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final double? birthWeightKg;
  final double? birthHeightCm;
  final String? birthplace;
  final String? schoolName;
  final String? className;
  final String? profilePhotoId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
}
