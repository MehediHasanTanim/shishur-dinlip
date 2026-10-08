abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const onboardingLanguage = '/onboarding/language';
  static const onboardingPrivacy = '/onboarding/privacy';
  static const onboardingWelcome = '/onboarding/welcome';
  static const onboardingCreateChild = '/onboarding/create-child';
  static const onboardingSecurity = '/onboarding/security';
  static const onboardingComplete = '/onboarding/complete';
  static const home = '/home';
  static const timeline = '/timeline';
  static const add = '/add';
  static const albums = '/albums';
  static const albumCreate = '/albums/create';
  static const yearReview = '/year-review';
  static const more = '/more';
  static const settings = '/settings';
  static const security = '/settings/security';
  static const unlock = '/unlock';
  static const backup = '/backup';
  static const restore = '/backup/restore';
  static const storage = '/settings/storage';
  static const children = '/children';
  static const childCreate = '/children/create';
  static const childEdit = '/children/:id/edit';
  static const childDetail = '/children/:id';

  static const search = '/search';
  static const photos = '/photos';

  static const journalCreate = '/journal/create';
  static const funnyCreate = '/funny/create';
  static const achievementCreate = '/achievements/create';

  static const growth = '/growth';
  static const growthHistory = '/growth/history';
  static const growthCreate = '/growth/create';
  static const milestones = '/milestones';
  static const milestoneCreate = '/milestones/create';
  static const firstWords = '/first-words';
  static const firstWordCreate = '/first-words/create';

  static const school = '/school';
  static const schoolTimeline = '/school/timeline';
  static const schoolProfileCreate = '/school/profiles/create';
  static const schoolEventCreate = '/school/events/create';

  static const health = '/health';
  static const vaccinations = '/health/vaccinations';
  static const vaccinationCreate = '/health/vaccinations/create';
  static const illnesses = '/health/illnesses';
  static const illnessCreate = '/health/illnesses/create';
  static const medicines = '/health/medicines';
  static const medicineCreate = '/health/medicines/create';
  static const doctorVisits = '/health/doctor-visits';
  static const doctorVisitCreate = '/health/doctor-visits/create';
  static const medicalDocuments = '/health/documents';
  static const medicalDocumentCreate = '/health/documents/create';

  static const ocrScan = '/health/ocr';
  static const ocrCapture = '/health/ocr/capture/:type';
  static const ocrReview = '/health/ocr/review';

  static const calendar = '/calendar';
  static const reminders = '/reminders';
  static const reminderCreate = '/reminders/create';
  static const reminderDetail = '/reminders/:id';
  static const reminderEdit = '/reminders/:id/edit';

  static const birthdays = '/birthdays';
  static const birthdayCreate = '/birthdays/create';
  static const birthdayCompare = '/birthdays/compare';
  static const favorites = '/favorites';
  static const favoriteCreate = '/favorites/create';

  static const interests = '/interests';
  static const interestCreate = '/interests/create';
  static const familyEvents = '/family-events';
  static const familyEventCreate = '/family-events/create';
  static const trips = '/trips';
  static const tripCreate = '/trips/create';

  static String childDetailPath(String id) => '/children/$id';
  static String childEditPath(String id) => '/children/$id/edit';

  static String journalCreatePath({String? template}) {
    if (template == null || template.isEmpty) return journalCreate;
    return '$journalCreate?template=$template';
  }

  static String journalDetailPath(String id) => '/journal/$id';
  static String journalEditPath(String id) => '/journal/$id/edit';
  static String funnyDetailPath(String id) => '/funny/$id';
  static String funnyEditPath(String id) => '/funny/$id/edit';
  static String achievementDetailPath(String id) => '/achievements/$id';
  static String achievementEditPath(String id) => '/achievements/$id/edit';

  static String growthDetailPath(String id) => '/growth/$id';
  static String growthEditPath(String id) => '/growth/$id/edit';

  static String milestoneCreatePath({String? template, String? category}) {
    final params = <String, String>{};
    if (template != null && template.isNotEmpty) {
      params['template'] = template;
    }
    if (category != null && category.isNotEmpty) {
      params['category'] = category;
    }
    if (params.isEmpty) return milestoneCreate;
    return Uri(path: milestoneCreate, queryParameters: params).toString();
  }

  static String milestoneDetailPath(String id) => '/milestones/$id';
  static String milestoneEditPath(String id) => '/milestones/$id/edit';
  static String milestonesByCategoryPath(String category) =>
      '/milestones/category/$category';

  static String firstWordDetailPath(String id) => '/first-words/$id';
  static String firstWordEditPath(String id) => '/first-words/$id/edit';

  static String schoolProfileDetailPath(String id) => '/school/profiles/$id';
  static String schoolProfileEditPath(String id) => '/school/profiles/$id/edit';
  static String schoolEventDetailPath(String id) => '/school/events/$id';
  static String schoolEventEditPath(String id) => '/school/events/$id/edit';

  static String schoolEventCreatePath({
    String? schoolProfileId,
    String? eventType,
  }) {
    final params = <String, String>{};
    if (schoolProfileId != null && schoolProfileId.isNotEmpty) {
      params['schoolProfileId'] = schoolProfileId;
    }
    if (eventType != null && eventType.isNotEmpty) {
      params['eventType'] = eventType;
    }
    if (params.isEmpty) return schoolEventCreate;
    return Uri(path: schoolEventCreate, queryParameters: params).toString();
  }

  static String vaccinationDetailPath(String id) => '/health/vaccinations/$id';
  static String vaccinationEditPath(String id) =>
      '/health/vaccinations/$id/edit';
  static String illnessDetailPath(String id) => '/health/illnesses/$id';
  static String illnessEditPath(String id) => '/health/illnesses/$id/edit';
  static String medicineDetailPath(String id) => '/health/medicines/$id';
  static String medicineEditPath(String id) => '/health/medicines/$id/edit';
  static String doctorVisitDetailPath(String id) =>
      '/health/doctor-visits/$id';
  static String doctorVisitEditPath(String id) =>
      '/health/doctor-visits/$id/edit';
  static String medicalDocumentDetailPath(String id) =>
      '/health/documents/$id';
  static String medicalDocumentEditPath(String id) =>
      '/health/documents/$id/edit';

  static String ocrCapturePath(String type) => '/health/ocr/capture/$type';

  static String reminderDetailPath(String id) => '/reminders/$id';
  static String reminderEditPath(String id) => '/reminders/$id/edit';

  static String photoDetailPath(String id) => '/photos/$id';
  static String albumDetailPath(String id) => '/albums/$id';
  static String albumEditPath(String id) => '/albums/$id/edit';

  static String yearReviewEditorPath(int year) => '/year-review/$year';
  static String yearReviewGeneratePath(int year) =>
      '/year-review/$year/generate';

  static String birthdayDetailPath(String id) => '/birthdays/$id';
  static String birthdayEditPath(String id) => '/birthdays/$id/edit';
  static String birthdayInterviewPath(String id) => '/birthdays/$id/interview';
  static String favoriteEditPath(String id) => '/favorites/$id/edit';

  static String interestDetailPath(String id) => '/interests/$id';
  static String interestEditPath(String id) => '/interests/$id/edit';
  static String familyEventDetailPath(String id) => '/family-events/$id';
  static String familyEventEditPath(String id) => '/family-events/$id/edit';
  static String familyEventCreatePath({String? type}) {
    if (type == null || type.isEmpty) return familyEventCreate;
    return Uri(path: familyEventCreate, queryParameters: {'type': type})
        .toString();
  }

  static String tripDetailPath(String id) => '/trips/$id';
  static String tripEditPath(String id) => '/trips/$id/edit';
  static String tripCreatePath({String? type}) {
    if (type == null || type.isEmpty) return tripCreate;
    return Uri(path: tripCreate, queryParameters: {'type': type}).toString();
  }
}
