// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccinations_dao.dart';

// ignore_for_file: type=lint
mixin _$VaccinationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $VaccinationsTable get vaccinations => attachedDatabase.vaccinations;
  VaccinationsDaoManager get managers => VaccinationsDaoManager(this);
}

class VaccinationsDaoManager {
  final _$VaccinationsDaoMixin _db;
  VaccinationsDaoManager(this._db);
  $$VaccinationsTableTableManager get vaccinations =>
      $$VaccinationsTableTableManager(_db.attachedDatabase, _db.vaccinations);
}
