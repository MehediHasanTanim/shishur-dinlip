import 'package:flutter/foundation.dart';

@immutable
class GrowthRecord {
  const GrowthRecord({
    required this.id,
    required this.childId,
    required this.measuredAt,
    required this.createdAt,
    required this.updatedAt,
    this.heightCm,
    this.weightKg,
    this.measurementLocation,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final DateTime measuredAt;
  final double? heightCm;
  final double? weightKg;
  final String? measurementLocation;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get hasMeasurement => heightCm != null || weightKg != null;

  GrowthRecord copyWith({
    String? id,
    String? childId,
    DateTime? measuredAt,
    double? heightCm,
    bool clearHeightCm = false,
    double? weightKg,
    bool clearWeightKg = false,
    String? measurementLocation,
    bool clearMeasurementLocation = false,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return GrowthRecord(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      measuredAt: measuredAt ?? this.measuredAt,
      heightCm: clearHeightCm ? null : (heightCm ?? this.heightCm),
      weightKg: clearWeightKg ? null : (weightKg ?? this.weightKg),
      measurementLocation: clearMeasurementLocation
          ? null
          : (measurementLocation ?? this.measurementLocation),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

@immutable
class GrowthHistoryItem {
  const GrowthHistoryItem({
    required this.record,
    this.previous,
  });

  final GrowthRecord record;
  final GrowthRecord? previous;

  double? get heightDeltaCm {
    if (record.heightCm == null || previous?.heightCm == null) return null;
    return record.heightCm! - previous!.heightCm!;
  }

  double? get weightDeltaKg {
    if (record.weightKg == null || previous?.weightKg == null) return null;
    return record.weightKg! - previous!.weightKg!;
  }
}
