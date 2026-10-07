import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/audit_events_table.dart';

part 'audit_events_dao.g.dart';

@DriftAccessor(tables: [AuditEvents])
class AuditEventsDao extends DatabaseAccessor<AppDatabase>
    with _$AuditEventsDaoMixin {
  AuditEventsDao(super.db);

  Future<void> insertEvent(AuditEventsCompanion companion) {
    return into(auditEvents).insert(companion);
  }

  Future<List<AuditEventRow>> latest({int limit = 50}) {
    return (select(auditEvents)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }
}
