import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// Maps health domain keys to bilingual [AppLocalizations] getters.
String vaccinationStatusLabel(AppLocalizations l10n, String status) {
  return switch (status) {
    VaccinationStatuses.upcoming => l10n.vaccineStatusUpcoming,
    VaccinationStatuses.completed => l10n.vaccineStatusCompleted,
    VaccinationStatuses.delayed => l10n.vaccineStatusDelayed,
    VaccinationStatuses.skipped => l10n.vaccineStatusSkipped,
    _ => l10n.vaccineStatusUnknown,
  };
}

String medicineStatusLabel(AppLocalizations l10n, String status) {
  return switch (status) {
    MedicineStatuses.active => l10n.medicineStatusActive,
    MedicineStatuses.completed => l10n.medicineStatusCompleted,
    MedicineStatuses.stopped => l10n.medicineStatusStopped,
    MedicineStatuses.asNeeded => l10n.medicineStatusAsNeeded,
    _ => status,
  };
}

String illnessSymptomLabel(AppLocalizations l10n, String symptom) {
  return switch (symptom) {
    IllnessSymptoms.fever => l10n.symptomFever,
    IllnessSymptoms.cough => l10n.symptomCough,
    IllnessSymptoms.cold => l10n.symptomCold,
    IllnessSymptoms.vomiting => l10n.symptomVomiting,
    IllnessSymptoms.diarrhea => l10n.symptomDiarrhea,
    IllnessSymptoms.rash => l10n.symptomRash,
    IllnessSymptoms.headache => l10n.symptomHeadache,
    IllnessSymptoms.stomachPain => l10n.symptomStomachPain,
    IllnessSymptoms.breathingDifficulty => l10n.symptomBreathing,
    IllnessSymptoms.allergy => l10n.symptomAllergy,
    IllnessSymptoms.injury => l10n.symptomInjury,
    IllnessSymptoms.other => l10n.symptomOther,
    _ => symptom,
  };
}

String medicalDocumentTypeLabel(AppLocalizations l10n, String type) {
  return switch (type) {
    MedicalDocumentTypes.prescription => l10n.docTypePrescription,
    MedicalDocumentTypes.diagnosticReport => l10n.docTypeDiagnostic,
    MedicalDocumentTypes.vaccinationCard => l10n.docTypeVaccinationCard,
    MedicalDocumentTypes.dischargeSummary => l10n.docTypeDischarge,
    MedicalDocumentTypes.certificate => l10n.docTypeCertificate,
    MedicalDocumentTypes.other => l10n.docTypeOther,
    _ => type,
  };
}
