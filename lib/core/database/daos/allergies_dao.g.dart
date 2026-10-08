// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allergies_dao.dart';

// ignore_for_file: type=lint
mixin _$AllergiesDaoMixin on DatabaseAccessor<AppDatabase> {
  $AllergiesTable get allergies => attachedDatabase.allergies;
  AllergiesDaoManager get managers => AllergiesDaoManager(this);
}

class AllergiesDaoManager {
  final _$AllergiesDaoMixin _db;
  AllergiesDaoManager(this._db);
  $$AllergiesTableTableManager get allergies =>
      $$AllergiesTableTableManager(_db.attachedDatabase, _db.allergies);
}
