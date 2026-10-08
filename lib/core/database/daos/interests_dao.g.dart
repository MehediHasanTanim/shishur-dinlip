// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_dao.dart';

// ignore_for_file: type=lint
mixin _$InterestsDaoMixin on DatabaseAccessor<AppDatabase> {
  $InterestsTable get interests => attachedDatabase.interests;
  InterestsDaoManager get managers => InterestsDaoManager(this);
}

class InterestsDaoManager {
  final _$InterestsDaoMixin _db;
  InterestsDaoManager(this._db);
  $$InterestsTableTableManager get interests =>
      $$InterestsTableTableManager(_db.attachedDatabase, _db.interests);
}
