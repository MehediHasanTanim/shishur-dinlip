// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_events_dao.dart';

// ignore_for_file: type=lint
mixin _$FamilyEventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FamilyEventsTable get familyEvents => attachedDatabase.familyEvents;
  FamilyEventsDaoManager get managers => FamilyEventsDaoManager(this);
}

class FamilyEventsDaoManager {
  final _$FamilyEventsDaoMixin _db;
  FamilyEventsDaoManager(this._db);
  $$FamilyEventsTableTableManager get familyEvents =>
      $$FamilyEventsTableTableManager(_db.attachedDatabase, _db.familyEvents);
}
