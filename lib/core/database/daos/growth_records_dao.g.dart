// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_records_dao.dart';

// ignore_for_file: type=lint
mixin _$GrowthRecordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $GrowthRecordsTable get growthRecords => attachedDatabase.growthRecords;
  GrowthRecordsDaoManager get managers => GrowthRecordsDaoManager(this);
}

class GrowthRecordsDaoManager {
  final _$GrowthRecordsDaoMixin _db;
  GrowthRecordsDaoManager(this._db);
  $$GrowthRecordsTableTableManager get growthRecords =>
      $$GrowthRecordsTableTableManager(_db.attachedDatabase, _db.growthRecords);
}
