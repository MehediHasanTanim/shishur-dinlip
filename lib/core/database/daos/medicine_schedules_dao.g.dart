// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_schedules_dao.dart';

// ignore_for_file: type=lint
mixin _$MedicineSchedulesDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicineSchedulesTable get medicineSchedules =>
      attachedDatabase.medicineSchedules;
  MedicineSchedulesDaoManager get managers => MedicineSchedulesDaoManager(this);
}

class MedicineSchedulesDaoManager {
  final _$MedicineSchedulesDaoMixin _db;
  MedicineSchedulesDaoManager(this._db);
  $$MedicineSchedulesTableTableManager get medicineSchedules =>
      $$MedicineSchedulesTableTableManager(
        _db.attachedDatabase,
        _db.medicineSchedules,
      );
}
