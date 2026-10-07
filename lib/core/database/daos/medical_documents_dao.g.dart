// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_documents_dao.dart';

// ignore_for_file: type=lint
mixin _$MedicalDocumentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicalDocumentsTable get medicalDocuments =>
      attachedDatabase.medicalDocuments;
  MedicalDocumentsDaoManager get managers => MedicalDocumentsDaoManager(this);
}

class MedicalDocumentsDaoManager {
  final _$MedicalDocumentsDaoMixin _db;
  MedicalDocumentsDaoManager(this._db);
  $$MedicalDocumentsTableTableManager get medicalDocuments =>
      $$MedicalDocumentsTableTableManager(
        _db.attachedDatabase,
        _db.medicalDocuments,
      );
}
