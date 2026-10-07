// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_dao.dart';

// ignore_for_file: type=lint
mixin _$ChildrenDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChildrenTable get children => attachedDatabase.children;
  ChildrenDaoManager get managers => ChildrenDaoManager(this);
}

class ChildrenDaoManager {
  final _$ChildrenDaoMixin _db;
  ChildrenDaoManager(this._db);
  $$ChildrenTableTableManager get children =>
      $$ChildrenTableTableManager(_db.attachedDatabase, _db.children);
}
