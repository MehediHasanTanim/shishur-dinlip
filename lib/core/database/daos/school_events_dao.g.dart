// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_events_dao.dart';

// ignore_for_file: type=lint
mixin _$SchoolEventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SchoolEventsTable get schoolEvents => attachedDatabase.schoolEvents;
  SchoolEventsDaoManager get managers => SchoolEventsDaoManager(this);
}

class SchoolEventsDaoManager {
  final _$SchoolEventsDaoMixin _db;
  SchoolEventsDaoManager(this._db);
  $$SchoolEventsTableTableManager get schoolEvents =>
      $$SchoolEventsTableTableManager(_db.attachedDatabase, _db.schoolEvents);
}
