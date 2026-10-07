import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/growth_record_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class GrowthRepository implements Repository {
  Future<List<GrowthRecord>> forChild(String childId, {int? limit});
  Future<List<GrowthHistoryItem>> historyForChild(String childId);
  Future<GrowthRecord?> getById(String id);
  Future<GrowthRecord?> latestForChild(String childId);
  Future<GrowthRecord> save(GrowthRecord record);
  Future<void> softDelete(String id);
}

class DriftGrowthRepository extends RepositoryBase
    implements GrowthRepository {
  DriftGrowthRepository(super.db);

  @override
  Future<List<GrowthRecord>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.growthRecordsDao.forChild(childId, limit: limit);
      return rows.map(GrowthRecordMapper.toDomain).toList();
    }, operation: 'growth.forChild');
  }

  @override
  Future<List<GrowthHistoryItem>> historyForChild(String childId) {
    return guard(() async {
      final rows = await db.growthRecordsDao.forChild(childId);
      final records = rows.map(GrowthRecordMapper.toDomain).toList();
      // Chronological ascending for previous lookup, then reverse for UI.
      final ascending = [...records]
        ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
      final items = <GrowthHistoryItem>[];
      for (var i = 0; i < ascending.length; i++) {
        items.add(
          GrowthHistoryItem(
            record: ascending[i],
            previous: i == 0 ? null : ascending[i - 1],
          ),
        );
      }
      return items.reversed.toList();
    }, operation: 'growth.history');
  }

  @override
  Future<GrowthRecord?> getById(String id) {
    return guard(() async {
      final row = await db.growthRecordsDao.getById(id);
      return row == null ? null : GrowthRecordMapper.toDomain(row);
    }, operation: 'growth.getById');
  }

  @override
  Future<GrowthRecord?> latestForChild(String childId) {
    return guard(() async {
      final row = await db.growthRecordsDao.latestForChild(childId);
      return row == null ? null : GrowthRecordMapper.toDomain(row);
    }, operation: 'growth.latest');
  }

  @override
  Future<GrowthRecord> save(GrowthRecord record) {
    return guard(() async {
      if (!record.hasMeasurement) {
        throw const ValidationFailure(
          message: 'Enter height, weight, or both.',
        );
      }
      final today = DateTime.now();
      final measured = DateTime(
        record.measuredAt.year,
        record.measuredAt.month,
        record.measuredAt.day,
      );
      if (measured.isAfter(DateTime(today.year, today.month, today.day))) {
        throw const ValidationFailure(
          message: 'Measurement date cannot be in the future.',
        );
      }
      if (record.heightCm != null &&
          (record.heightCm! <= 0 || record.heightCm! > 250)) {
        throw const ValidationFailure(message: 'Height looks invalid.');
      }
      if (record.weightKg != null &&
          (record.weightKg! <= 0 || record.weightKg! > 200)) {
        throw const ValidationFailure(message: 'Weight looks invalid.');
      }

      final nowUtc = now();
      final id = record.id.isEmpty ? ids.next() : record.id;
      final existing = await db.growthRecordsDao.getById(id);
      final toSave = record.copyWith(
        id: id,
        measuredAt: measured,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.growthRecordsDao.upsert(GrowthRecordMapper.toCompanion(toSave));
      return toSave;
    }, operation: 'growth.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.growthRecordsDao.softDelete(id, now());
    }, operation: 'growth.softDelete');
  }
}
