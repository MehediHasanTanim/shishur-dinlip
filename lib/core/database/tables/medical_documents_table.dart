import 'package:drift/drift.dart';

@DataClassName('MedicalDocumentRow')
class MedicalDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text()();
  TextColumn get documentType => text()();
  TextColumn get title => text()();
  DateTimeColumn get documentDate => dateTime().nullable()();
  TextColumn get illnessId => text().nullable()();
  TextColumn get doctorVisitId => text().nullable()();
  TextColumn get vaccinationId => text().nullable()();
  TextColumn get mediaAssetId => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
