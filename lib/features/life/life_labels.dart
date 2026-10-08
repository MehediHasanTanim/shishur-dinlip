import 'package:shishur_dinlipi/core/domain/models/family_event.dart';
import 'package:shishur_dinlipi/core/domain/models/trip.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

String familyEventTypeLabel(AppLocalizations l10n, String type) {
  return switch (type) {
    FamilyEventTypes.eid => l10n.familyEventTypeEid,
    FamilyEventTypes.wedding => l10n.familyEventTypeWedding,
    FamilyEventTypes.vacation => l10n.familyEventTypeVacation,
    FamilyEventTypes.grandparentVisit => l10n.familyEventTypeGrandparent,
    FamilyEventTypes.newSibling => l10n.familyEventTypeSibling,
    FamilyEventTypes.movingHome => l10n.familyEventTypeMoving,
    FamilyEventTypes.firstFlight => l10n.familyEventTypeFirstFlight,
    FamilyEventTypes.firstBeach => l10n.familyEventTypeFirstBeach,
    FamilyEventTypes.gathering => l10n.familyEventTypeGathering,
    FamilyEventTypes.other => l10n.familyEventTypeOther,
    _ => type,
  };
}

String tripTypeLabel(AppLocalizations l10n, String type) {
  return switch (type) {
    TripTypes.vacation => l10n.tripTypeVacation,
    TripTypes.firstFlight => l10n.tripTypeFirstFlight,
    TripTypes.firstBeach => l10n.tripTypeFirstBeach,
    TripTypes.placeVisit => l10n.tripTypePlaceVisit,
    TripTypes.other => l10n.tripTypeOther,
    _ => type,
  };
}
