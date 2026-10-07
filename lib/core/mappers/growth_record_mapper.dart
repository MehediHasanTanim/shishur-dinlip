import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';

abstract final class GrowthRecordMapper {
  static GrowthRecord toDomain(GrowthRecordRow row) {
    return GrowthRecord(
      id: row.id,
      childId: row.childId,
      measuredAt: row.measuredAt,
      heightCm: row.heightCm,
      weightKg: row.weightKg,
      measurementLocation: row.measurementLocation,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static GrowthRecordsCompanion toCompanion(GrowthRecord record) {
    return GrowthRecordsCompanion(
      id: Value(record.id),
      childId: Value(record.childId),
      measuredAt: Value(record.measuredAt),
      heightCm: Value(record.heightCm),
      weightKg: Value(record.weightKg),
      measurementLocation: Value(record.measurementLocation),
      notes: Value(record.notes),
      createdAt: Value(record.createdAt),
      updatedAt: Value(record.updatedAt),
      deletedAt: Value(record.deletedAt),
    );
  }
}
