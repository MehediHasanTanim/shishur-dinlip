// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funny_moments_dao.dart';

// ignore_for_file: type=lint
mixin _$FunnyMomentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FunnyMomentsTable get funnyMoments => attachedDatabase.funnyMoments;
  FunnyMomentsDaoManager get managers => FunnyMomentsDaoManager(this);
}

class FunnyMomentsDaoManager {
  final _$FunnyMomentsDaoMixin _db;
  FunnyMomentsDaoManager(this._db);
  $$FunnyMomentsTableTableManager get funnyMoments =>
      $$FunnyMomentsTableTableManager(_db.attachedDatabase, _db.funnyMoments);
}
