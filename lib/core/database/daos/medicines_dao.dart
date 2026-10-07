import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/medicines_table.dart';

part 'medicines_dao.g.dart';

@DriftAccessor(tables: [Medicines])
class MedicinesDao extends DatabaseAccessor<AppDatabase>
    with _$MedicinesDaoMixin {
  MedicinesDao(super.db);

  Future<List<MedicineRow>> forChild(
    String childId, {
    String? status,
    String? illnessId,
    int? limit,
  }) {
    final query = select(medicines)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull());
    if (status != null) {
      query.where((t) => t.status.equals(status));
    }
    if (illnessId != null) {
      query.where((t) => t.illnessId.equals(illnessId));
    }
    query.orderBy([
      (t) => OrderingTerm.desc(t.startDate),
      (t) => OrderingTerm.desc(t.createdAt),
    ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<MedicineRow?> getById(String id) {
    return (select(medicines)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<List<MedicineRow>> activeForChild(String childId) {
    return forChild(childId, status: 'active');
  }

  Future<void> upsert(MedicinesCompanion companion) {
    return into(medicines).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(medicines)..where((t) => t.id.equals(id))).write(
      MedicinesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
