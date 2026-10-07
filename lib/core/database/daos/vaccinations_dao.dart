import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/vaccinations_table.dart';

part 'vaccinations_dao.g.dart';

@DriftAccessor(tables: [Vaccinations])
class VaccinationsDao extends DatabaseAccessor<AppDatabase>
    with _$VaccinationsDaoMixin {
  VaccinationsDao(super.db);

  Future<List<VaccinationRow>> forChild(
    String childId, {
    String? status,
    int? limit,
  }) {
    final query = select(vaccinations)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull());
    if (status != null) {
      query.where((t) => t.status.equals(status));
    }
    query.orderBy([
      (t) => OrderingTerm(
        expression: coalesce([t.givenDate, t.scheduledDate, t.createdAt]),
        mode: OrderingMode.desc,
      ),
    ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<VaccinationRow?> getById(String id) {
    return (select(vaccinations)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<List<VaccinationRow>> upcomingForChild(String childId, {int? limit}) {
    final today = DateTime.now();
    final from = DateTime(today.year, today.month, today.day);
    final query = select(vaccinations)
      ..where(
        (t) =>
            t.childId.equals(childId) &
            t.deletedAt.isNull() &
            t.status.equals('upcoming') &
            t.scheduledDate.isNotNull() &
            t.scheduledDate.isBiggerOrEqualValue(from),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.scheduledDate)]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<void> upsert(VaccinationsCompanion companion) {
    return into(vaccinations).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(vaccinations)..where((t) => t.id.equals(id))).write(
      VaccinationsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
