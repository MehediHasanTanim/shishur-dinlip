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

  String get displayName {
    final nick = nickname?.trim();
    if (nick != null && nick.isNotEmpty) return nick;
    return name;
  }

  Child copyWith({
    String? id,
    String? name,
    String? nickname,
    bool clearNickname = false,
    DateTime? dateOfBirth,
    String? gender,
    bool clearGender = false,
    String? bloodGroup,
    bool clearBloodGroup = false,
    double? birthWeightKg,
    bool clearBirthWeightKg = false,
    double? birthHeightCm,
    bool clearBirthHeightCm = false,
    String? birthplace,
    bool clearBirthplace = false,
    String? schoolName,
    bool clearSchoolName = false,
    String? className,
    bool clearClassName = false,
    String? profilePhotoId,
    bool clearProfilePhotoId = false,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: clearGender ? null : (gender ?? this.gender),
      bloodGroup: clearBloodGroup ? null : (bloodGroup ?? this.bloodGroup),
      birthWeightKg: clearBirthWeightKg
          ? null
          : (birthWeightKg ?? this.birthWeightKg),
      birthHeightCm: clearBirthHeightCm
          ? null
          : (birthHeightCm ?? this.birthHeightCm),
      birthplace: clearBirthplace ? null : (birthplace ?? this.birthplace),
      schoolName: clearSchoolName ? null : (schoolName ?? this.schoolName),
      className: clearClassName ? null : (className ?? this.className),
      profilePhotoId: clearProfilePhotoId
          ? null
          : (profilePhotoId ?? this.profilePhotoId),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

/// Optional gender values stored as lowercase tokens.
abstract final class ChildGender {
  static const boy = 'boy';
  static const girl = 'girl';
  static const other = 'other';
}
