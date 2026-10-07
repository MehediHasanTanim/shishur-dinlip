// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_profiles_dao.dart';

// ignore_for_file: type=lint
mixin _$SchoolProfilesDaoMixin on DatabaseAccessor<AppDatabase> {
  $SchoolProfilesTable get schoolProfiles => attachedDatabase.schoolProfiles;
  SchoolProfilesDaoManager get managers => SchoolProfilesDaoManager(this);
}

class SchoolProfilesDaoManager {
  final _$SchoolProfilesDaoMixin _db;
  SchoolProfilesDaoManager(this._db);
  $$SchoolProfilesTableTableManager get schoolProfiles =>
      $$SchoolProfilesTableTableManager(
        _db.attachedDatabase,
        _db.schoolProfiles,
      );
}
