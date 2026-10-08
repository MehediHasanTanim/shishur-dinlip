import 'package:flutter/foundation.dart';

@immutable
class Interest {
  const Interest({
    required this.id,
    required this.childId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.firstNoticed,
    this.interestLevel,
    this.notes,
    this.coverAssetId,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String name;
  final DateTime? firstNoticed;
  /// 1..5
  final int? interestLevel;
  final String? notes;
  final String? coverAssetId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Interest copyWith({
    String? id,
    String? childId,
    String? name,
    DateTime? firstNoticed,
    bool clearFirstNoticed = false,
    int? interestLevel,
    bool clearInterestLevel = false,
    String? notes,
    bool clearNotes = false,
    String? coverAssetId,
    bool clearCoverAssetId = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Interest(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      name: name ?? this.name,
      firstNoticed: clearFirstNoticed
          ? null
          : (firstNoticed ?? this.firstNoticed),
      interestLevel: clearInterestLevel
          ? null
          : (interestLevel ?? this.interestLevel),
      notes: clearNotes ? null : (notes ?? this.notes),
      coverAssetId: clearCoverAssetId
          ? null
          : (coverAssetId ?? this.coverAssetId),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
