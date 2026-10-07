// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_events_dao.dart';

// ignore_for_file: type=lint
mixin _$AuditEventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AuditEventsTable get auditEvents => attachedDatabase.auditEvents;
  AuditEventsDaoManager get managers => AuditEventsDaoManager(this);
}

class AuditEventsDaoManager {
  final _$AuditEventsDaoMixin _db;
  AuditEventsDaoManager(this._db);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db.attachedDatabase, _db.auditEvents);
}
