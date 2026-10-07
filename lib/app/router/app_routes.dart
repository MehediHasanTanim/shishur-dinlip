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
  static const more = '/more';
  static const settings = '/settings';
  static const children = '/children';
  static const childCreate = '/children/create';
  static const childEdit = '/children/:id/edit';
  static const childDetail = '/children/:id';

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
}
