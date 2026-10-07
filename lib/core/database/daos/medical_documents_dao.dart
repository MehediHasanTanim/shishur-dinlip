import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/medical_documents_table.dart';

part 'medical_documents_dao.g.dart';

@DriftAccessor(tables: [MedicalDocuments])
class MedicalDocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalDocumentsDaoMixin {
  MedicalDocumentsDao(super.db);

  Future<List<MedicalDocumentRow>> forChild(
    String childId, {
    String? documentType,
    int? limit,
  }) {
    final query = select(medicalDocuments)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull());
    if (documentType != null) {
      query.where((t) => t.documentType.equals(documentType));
    }
    query.orderBy([
      (t) => OrderingTerm.desc(t.documentDate),
      (t) => OrderingTerm.desc(t.createdAt),
    ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<MedicalDocumentRow?> getById(String id) {
    return (select(medicalDocuments)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(MedicalDocumentsCompanion companion) {
    return into(medicalDocuments).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(medicalDocuments)..where((t) => t.id.equals(id))).write(
      MedicalDocumentsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
