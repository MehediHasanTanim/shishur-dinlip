import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/doctor_visit.dart';
import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/doctor_visits_repository.dart';
import 'package:shishur_dinlipi/core/repository/illness_episodes_repository.dart';
import 'package:shishur_dinlipi/core/repository/medical_documents_repository.dart';
import 'package:shishur_dinlipi/core/repository/medicines_repository.dart';
import 'package:shishur_dinlipi/core/repository/vaccinations_repository.dart';
import 'package:shishur_dinlipi/l10n/app_localizations_bn.dart';
import 'package:shishur_dinlipi/l10n/app_localizations_en.dart';

void main() {
  late AppDatabase db;
  late Directory root;
  late VaccinationsRepository vaccinations;
  late IllnessEpisodesRepository illnesses;
  late MedicinesRepository medicines;
  late DoctorVisitsRepository visits;
  late MedicalDocumentsRepository documents;
  late AttachmentRepository attachments;
  late String childId;

  setUp(() async {
    db = AppDatabase.memory();
    root = await Directory.systemTemp.createTemp('sd_health_');
    final storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    final media = MediaService(db, storage: storage);
    attachments = DriftAttachmentRepository(
      db,
      mediaService: media,
      storage: storage,
    );
    vaccinations = DriftVaccinationsRepository(db, attachments: attachments);
    illnesses = DriftIllnessEpisodesRepository(db, attachments: attachments);
    medicines = DriftMedicinesRepository(db);
    visits = DriftDoctorVisitsRepository(db, attachments: attachments);
    documents = DriftMedicalDocumentsRepository(db, media: media);

    final now = DateTime.now().toUtc();
    final child = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2018, 1, 1),
        bloodGroup: 'B+',
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;
  });

  tearDown(() async {
    await db.close();
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('ongoing and completed illness; missing diagnosis allowed', () async {
    final now = DateTime.now().toUtc();
    final ongoing = await illnesses.save(
      episode: IllnessEpisode(
        id: '',
        childId: childId,
        title: 'জ্বর',
        startDate: DateTime(2026, 9, 1),
        symptoms: const [IllnessSymptoms.fever, IllnessSymptoms.cough],
        maxTemperatureC: 38.5,
        notes: 'বাংলা নোট — পর্যবেক্ষণ চলছে',
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(ongoing.isOngoing, isTrue);
    expect(ongoing.diagnosis, isNull);
    expect(ongoing.notes, contains('বাংলা'));

    final completed = await illnesses.save(
      episode: IllnessEpisode(
        id: '',
        childId: childId,
        title: 'Cold',
        startDate: DateTime(2026, 8, 1),
        endDate: DateTime(2026, 8, 5),
        diagnosis: 'Viral',
        recoveryNote: 'Fully recovered',
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(completed.isOngoing, isFalse);

    final list = await illnesses.forChild(childId);
    expect(list, hasLength(2));
    expect(await illnesses.latestForChild(childId), isNotNull);
  });

  test('active and stopped medicine with schedule', () async {
    final now = DateTime.now().toUtc();
    final active = await medicines.save(
      Medicine(
        id: '',
        childId: childId,
        name: 'Paracetamol',
        strength: '250mg',
        dosage: '5ml',
        frequencyText: '3 times daily',
        status: MedicineStatuses.active,
        startDate: DateTime(2026, 9, 1),
        schedules: [
          MedicineSchedule(
            id: '',
            medicineId: '',
            timeOfDay: '08:00',
            createdAt: now,
            updatedAt: now,
          ),
          MedicineSchedule(
            id: '',
            medicineId: '',
            timeOfDay: '20:00',
            createdAt: now,
            updatedAt: now,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(active.isActive, isTrue);
    expect(active.schedules, hasLength(2));

    final stopped = await medicines.save(
      active.copyWith(
        status: MedicineStatuses.stopped,
        endDate: DateTime(2026, 9, 7),
        updatedAt: now,
      ),
    );
    expect(stopped.status, MedicineStatuses.stopped);
    expect(await medicines.activeForChild(childId), isEmpty);
  });

  test('vaccine scheduled vs completed', () async {
    final now = DateTime.now().toUtc();
    final upcoming = await vaccinations.save(
      vaccination: Vaccination(
        id: '',
        childId: childId,
        vaccineName: 'MMR',
        doseLabel: '1st',
        scheduledDate: DateTime.now().add(const Duration(days: 14)),
        status: VaccinationStatuses.upcoming,
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(upcoming.status, VaccinationStatuses.upcoming);
    expect(await vaccinations.upcomingForChild(childId), isNotEmpty);

    final done = await vaccinations.save(
      vaccination: Vaccination(
        id: '',
        childId: childId,
        vaccineName: 'Hepatitis B',
        givenDate: DateTime(2025, 1, 10),
        status: VaccinationStatuses.completed,
        clinicName: 'City Clinic',
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(done.status, VaccinationStatuses.completed);
    final completed = await vaccinations.forChild(
      childId,
      status: VaccinationStatuses.completed,
    );
    expect(completed.any((v) => v.vaccineName == 'Hepatitis B'), isTrue);
  });

  test('doctor visit attachment and medical document', () async {
    final now = DateTime.now().toUtc();
    final pdf = await _writeBytes(
      root,
      'rx.pdf',
      Uint8List.fromList('%PDF-1.4 prescription'.codeUnits),
    );

    final visit = await visits.save(
      visit: DoctorVisit(
        id: '',
        childId: childId,
        visitDate: DateTime(2026, 9, 15),
        doctorName: 'Dr. Rahman',
        specialty: 'Pediatrics',
        diagnosis: null,
        createdAt: now,
        updatedAt: now,
      ),
      attachments: [
        AttachmentDraft(
          localKey: '1',
          pendingPath: pdf.path,
          displayName: 'rx.pdf',
          isDocument: true,
        ),
      ],
    );
    expect(visit.diagnosis, isNull);
    final linked = await attachments.forEntity(
      entityType: EntityTypes.doctorVisit,
      entityId: visit.id,
    );
    expect(linked, hasLength(1));

    final doc = await documents.save(
      document: MedicalDocument(
        id: '',
        childId: childId,
        documentType: MedicalDocumentTypes.prescription,
        title: 'Clinic Rx',
        mediaAssetId: '',
        doctorVisitId: visit.id,
        documentDate: DateTime(2026, 9, 15),
        createdAt: now,
        updatedAt: now,
      ),
      pendingFilePath: pdf.path,
      isDocument: true,
    );
    expect(doc.mediaAssetId, isNotEmpty);
    expect(doc.media, isNotNull);
  });

  test('health disclaimer strings exist EN and BN', () {
    final en = AppLocalizationsEn();
    final bn = AppLocalizationsBn();
    expect(en.healthDisclaimerShort, isNotEmpty);
    expect(bn.healthDisclaimerShort, isNotEmpty);
    expect(en.healthDisclaimerFull, contains('Shishur Dinlipi'));
    expect(bn.healthDisclaimerFull, contains('শিশুর দিনলিপি'));
  });
}

Future<File> _writeBytes(Directory root, String name, List<int> bytes) async {
  final file = File(p.join(root.path, name));
  await file.writeAsBytes(bytes);
  return file;
}
