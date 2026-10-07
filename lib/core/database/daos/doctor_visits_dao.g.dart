// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_visits_dao.dart';

// ignore_for_file: type=lint
mixin _$DoctorVisitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DoctorVisitsTable get doctorVisits => attachedDatabase.doctorVisits;
  DoctorVisitsDaoManager get managers => DoctorVisitsDaoManager(this);
}

class DoctorVisitsDaoManager {
  final _$DoctorVisitsDaoMixin _db;
  DoctorVisitsDaoManager(this._db);
  $$DoctorVisitsTableTableManager get doctorVisits =>
      $$DoctorVisitsTableTableManager(_db.attachedDatabase, _db.doctorVisits);
}
