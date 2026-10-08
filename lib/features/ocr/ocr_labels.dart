import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

String ocrScanTypeLabel(AppLocalizations l10n, OcrScanType type) {
  return switch (type) {
    OcrScanType.vaccinationCard => l10n.ocrTypeVaccinationCard,
    OcrScanType.prescription => l10n.ocrTypePrescription,
    OcrScanType.diagnosticReport => l10n.ocrTypeDiagnosticReport,
  };
}

String ocrScanTypeSubtitle(AppLocalizations l10n, OcrScanType type) {
  return switch (type) {
    OcrScanType.vaccinationCard => l10n.ocrTypeVaccinationCardSubtitle,
    OcrScanType.prescription => l10n.ocrTypePrescriptionSubtitle,
    OcrScanType.diagnosticReport => l10n.ocrTypeDiagnosticReportSubtitle,
  };
}

String ocrFieldLabel(AppLocalizations l10n, String labelKey) {
  return switch (labelKey) {
    'ocrFieldVaccineName' => l10n.ocrFieldVaccineName,
    'ocrFieldDose' => l10n.ocrFieldDose,
    'ocrFieldGivenDate' => l10n.ocrFieldGivenDate,
    'ocrFieldBatch' => l10n.ocrFieldBatch,
    'ocrFieldClinic' => l10n.ocrFieldClinic,
    'ocrFieldMedicineName' => l10n.ocrFieldMedicineName,
    'ocrFieldStrength' => l10n.ocrFieldStrength,
    'ocrFieldDosage' => l10n.ocrFieldDosage,
    'ocrFieldFrequency' => l10n.ocrFieldFrequency,
    'ocrFieldPrescribedBy' => l10n.ocrFieldPrescribedBy,
    'ocrFieldStartDate' => l10n.ocrFieldStartDate,
    'ocrFieldDocumentTitle' => l10n.ocrFieldDocumentTitle,
    'ocrFieldDocumentDate' => l10n.ocrFieldDocumentDate,
    'ocrFieldFacility' => l10n.ocrFieldFacility,
    'ocrFieldFindings' => l10n.ocrFieldFindings,
    'ocrFieldNotes' => l10n.ocrFieldNotes,
    _ => labelKey,
  };
}
