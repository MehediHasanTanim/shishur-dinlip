import 'package:shishur_dinlipi/core/domain/models/allergy.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

String allergyTypeLabel(AppLocalizations l10n, String type) {
  return switch (type) {
    AllergyTypes.food => l10n.allergyTypeFood,
    AllergyTypes.medicine => l10n.allergyTypeMedicine,
    AllergyTypes.environmental => l10n.allergyTypeEnvironmental,
    _ => l10n.allergyTypeUnknown,
  };
}

String allergySeverityLabel(AppLocalizations l10n, String severity) {
  return switch (severity) {
    AllergySeverities.mild => l10n.allergySeverityMild,
    AllergySeverities.moderate => l10n.allergySeverityModerate,
    AllergySeverities.severe => l10n.allergySeveritySevere,
    _ => l10n.allergySeverityUnknown,
  };
}
