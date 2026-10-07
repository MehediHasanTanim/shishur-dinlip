// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestones_dao.dart';

// ignore_for_file: type=lint
mixin _$MilestonesDaoMixin on DatabaseAccessor<AppDatabase> {
  $MilestonesTable get milestones => attachedDatabase.milestones;
  MilestonesDaoManager get managers => MilestonesDaoManager(this);
}

class MilestonesDaoManager {
  final _$MilestonesDaoMixin _db;
  MilestonesDaoManager(this._db);
  $$MilestonesTableTableManager get milestones =>
      $$MilestonesTableTableManager(_db.attachedDatabase, _db.milestones);
}
