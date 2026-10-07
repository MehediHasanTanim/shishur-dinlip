import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/medicine_schedules_table.dart';

part 'medicine_schedules_dao.g.dart';

@DriftAccessor(tables: [MedicineSchedules])
class MedicineSchedulesDao extends DatabaseAccessor<AppDatabase>
    with _$MedicineSchedulesDaoMixin {
  MedicineSchedulesDao(super.db);

  Future<List<MedicineScheduleRow>> forMedicine(String medicineId) {
    return (select(medicineSchedules)
          ..where(
            (t) => t.medicineId.equals(medicineId) & t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.timeOfDay)]))
        .get();
  }

  Future<void> upsert(MedicineSchedulesCompanion companion) {
    return into(medicineSchedules).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(medicineSchedules)..where((t) => t.id.equals(id))).write(
      MedicineSchedulesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<void> softDeleteForMedicine(String medicineId, DateTime deletedAt) {
    return (update(medicineSchedules)
          ..where(
            (t) => t.medicineId.equals(medicineId) & t.deletedAt.isNull(),
          ))
        .write(
          MedicineSchedulesCompanion(
            deletedAt: Value(deletedAt),
            updatedAt: Value(deletedAt),
          ),
        );
  }
}
