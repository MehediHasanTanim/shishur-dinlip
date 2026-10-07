import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/doctor_visits_table.dart';

part 'doctor_visits_dao.g.dart';

@DriftAccessor(tables: [DoctorVisits])
class DoctorVisitsDao extends DatabaseAccessor<AppDatabase>
    with _$DoctorVisitsDaoMixin {
  DoctorVisitsDao(super.db);

  Future<List<DoctorVisitRow>> forChild(String childId, {int? limit}) {
    final query = select(doctorVisits)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.visitDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<DoctorVisitRow?> getById(String id) {
    return (select(doctorVisits)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<DoctorVisitRow?> latestForChild(String childId) {
    return (select(doctorVisits)
          ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.visitDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<DoctorVisitRow>> upcomingFollowUps(
    String childId, {
    int? limit,
  }) {
    final today = DateTime.now();
    final from = DateTime(today.year, today.month, today.day);
    final query = select(doctorVisits)
      ..where(
        (t) =>
            t.childId.equals(childId) &
            t.deletedAt.isNull() &
            t.followUpDate.isNotNull() &
            t.followUpDate.isBiggerOrEqualValue(from),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.followUpDate)]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<void> upsert(DoctorVisitsCompanion companion) {
    return into(doctorVisits).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(doctorVisits)..where((t) => t.id.equals(id))).write(
      DoctorVisitsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
