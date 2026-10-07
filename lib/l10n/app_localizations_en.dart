// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shishur Dinlipi';

  @override
  String get appNameBn => 'শিশুর দিনলিপি';

  @override
  String get tagline => 'Your child\'s story, preserved with care.';

  @override
  String get navHome => 'Home';

  @override
  String get navTimeline => 'Timeline';

  @override
  String get navAdd => 'Add';

  @override
  String get navAlbums => 'Albums';

  @override
  String get navMore => 'More';

  @override
  String get splashTitle => 'Shishur Dinlipi';

  @override
  String get splashLoading => 'Preparing your journal…';

  @override
  String get onboardingTitle =>
      'Preserve the little moments that become big memories.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get chooseLanguageTitle => 'Choose your language';

  @override
  String get privacyTitle => 'Your child\'s memories stay with you';

  @override
  String get privacyPrivate =>
      'Private by default — stored securely on your device.';

  @override
  String get privacyOffline => 'Works offline — no internet required.';

  @override
  String get privacyControl =>
      'You are in control — export, backup, or delete anytime.';

  @override
  String get privacyContinue => 'I understand';

  @override
  String get welcomeTitle =>
      'Preserve the little moments that become big memories.';

  @override
  String get welcomeCta => 'Create child profile';

  @override
  String get welcomeHighlightGrowth => 'Growth';

  @override
  String get welcomeHighlightHealth => 'Health';

  @override
  String get welcomeHighlightMilestones => 'Milestones';

  @override
  String get welcomeHighlightPhotos => 'Photos';

  @override
  String get createFirstChildTitle => 'Create your first child';

  @override
  String get createFirstChildSubtitle =>
      'Add some basic information to get started.';

  @override
  String get addMoreDetailsLater => 'Add more details later';

  @override
  String get securityTitle => 'Protect your child\'s journal';

  @override
  String get securitySubtitle =>
      'Optional PIN or biometrics keep private memories private.';

  @override
  String get securitySetPin => 'Set PIN';

  @override
  String get securityBiometrics => 'Enable biometrics';

  @override
  String get securityLater => 'Set up later';

  @override
  String get setupCompleteTitle => 'You\'re all set!';

  @override
  String setupCompleteSubtitle(String name) {
    return '$name\'s journal is ready. Start capturing beautiful moments.';
  }

  @override
  String get goToHome => 'Go to Home';

  @override
  String get addFirstMemory => 'Add first memory';

  @override
  String get homeTitle => 'Home';

  @override
  String get homePlaceholder => 'Your child\'s story starts here.';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String homeAgeLine(String name, String age) {
    return '$name is now $age';
  }

  @override
  String get growthSnapshot => 'Growth snapshot';

  @override
  String get growthEmpty =>
      'No measurements yet. Add the first height or weight.';

  @override
  String get quickAdd => 'Quick add';

  @override
  String get quickAddMemory => 'Memory';

  @override
  String get quickAddPhoto => 'Photo';

  @override
  String get quickAddGrowth => 'Growth';

  @override
  String get quickAddMilestone => 'Milestone';

  @override
  String get quickAddHealth => 'Health';

  @override
  String get quickAddAchievement => 'Achievement';

  @override
  String get recentMemories => 'Recent memories';

  @override
  String get recentMemoriesEmpty =>
      'No memories yet. Add your first memory and begin the story.';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get upcomingEmpty => 'No reminders yet.';

  @override
  String get timelineTitle => 'Timeline';

  @override
  String get timelinePlaceholder => 'Memories and records will appear here.';

  @override
  String get addTitle => 'Quick Add';

  @override
  String get addPlaceholder => 'Choose what you want to record.';

  @override
  String get albumsTitle => 'Albums';

  @override
  String get albumsPlaceholder => 'Year in Review and albums will live here.';

  @override
  String get moreTitle => 'More';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageBangla => 'বাংলা';

  @override
  String get settingsAbout => 'About';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonGoBack => 'Go Back';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonSkip => 'Skip for now';

  @override
  String get commonSearch => 'Search';

  @override
  String get errorGeneric => 'Something went wrong.';

  @override
  String get errorDatabase => 'Could not access the journal database.';

  @override
  String get errorFile => 'Could not access a file.';

  @override
  String get errorValidation => 'Please check the highlighted fields.';

  @override
  String get errorPermission => 'Permission is required to continue.';

  @override
  String get errorBackup => 'Backup failed.';

  @override
  String get errorRestore => 'Restore failed.';

  @override
  String get errorPdf => 'Could not generate the PDF.';

  @override
  String get childName => 'Child\'s name';

  @override
  String get childNickname => 'Nickname';

  @override
  String get childDob => 'Date of birth';

  @override
  String get childGender => 'Gender';

  @override
  String get childGenderBoy => 'Boy';

  @override
  String get childGenderGirl => 'Girl';

  @override
  String get childGenderOther => 'Other';

  @override
  String get childBloodGroup => 'Blood group';

  @override
  String get childBirthWeight => 'Birth weight (kg)';

  @override
  String get childBirthHeight => 'Birth height (cm)';

  @override
  String get childBirthplace => 'Birthplace';

  @override
  String get childSchool => 'School';

  @override
  String get childClass => 'Class';

  @override
  String get childNotes => 'Notes';

  @override
  String get childNameRequired => 'Child name is required.';

  @override
  String get childDobFuture => 'Date of birth cannot be in the future.';

  @override
  String get saveChild => 'Save child';

  @override
  String get addChild => 'Add child';

  @override
  String get addAnotherChild => 'Add another child';

  @override
  String get editChild => 'Edit child';

  @override
  String get childProfile => 'Child profile';

  @override
  String get manageChildren => 'Manage children';

  @override
  String get selectChild => 'Select a child';

  @override
  String get childrenTitle => 'Children';

  @override
  String get noChildrenTitle => 'No children yet';

  @override
  String get noChildrenMessage =>
      'Add a child profile to start preserving their story.';

  @override
  String get aboutSection => 'About';

  @override
  String get deleteChildTitle => 'Delete this child?';

  @override
  String deleteChildMessage(String name) {
    return 'This removes $name\'s journal entries from this device. Consider creating a backup first. This cannot be undone easily.';
  }

  @override
  String get deleteChildConfirm => 'Delete child';

  @override
  String get setAsSelected => 'Set as selected';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get replacePhoto => 'Replace photo';

  @override
  String get addPhotoTitle => 'Add a photo';

  @override
  String get photoPermissionDenied =>
      'Photo access is needed only when you choose to add a picture.';

  @override
  String get cameraPermissionDenied =>
      'Camera access is needed only when you choose to take a photo.';

  @override
  String get basicSection => 'Basic';

  @override
  String get birthSection => 'Birth';

  @override
  String get healthSection => 'Health';

  @override
  String get schoolSection => 'School';

  @override
  String get notesSection => 'Notes';

  @override
  String get addSubtitle => 'Choose what you want to preserve today.';

  @override
  String get addGroupMemories => 'Memories';

  @override
  String get addGroupComingSoon => 'Coming soon';

  @override
  String get addComingSoonMessage =>
      'School and health records arrive in later sprints.';

  @override
  String get addComingSoonHealthOnly =>
      'Health records arrive in later sprints.';

  @override
  String get addGroupSchool => 'School';

  @override
  String get addSchoolProfile => 'Add school';

  @override
  String get editSchoolProfile => 'Edit school';

  @override
  String get addSchoolProfileSubtitle => 'School name, class, and teacher.';

  @override
  String get addSchoolEvent => 'Add school event';

  @override
  String get editSchoolEvent => 'Edit school event';

  @override
  String get addSchoolEventSubtitle =>
      'First day, exams, certificates, and more.';

  @override
  String get addReportCardSubtitle => 'Attach a report card photo or PDF.';

  @override
  String get addGroupDevelopment => 'Development';

  @override
  String get schoolTitle => 'School';

  @override
  String get schoolCurrent => 'Current school';

  @override
  String get schoolCurrentBadge => 'Current';

  @override
  String get schoolEmpty => 'No school profile yet. Add the first one.';

  @override
  String get schoolHistory => 'School history';

  @override
  String get schoolEvents => 'School events';

  @override
  String get schoolEventsEmpty => 'No school events yet.';

  @override
  String get schoolRecentEvent => 'Recent school event';

  @override
  String get schoolTimeline => 'School timeline';

  @override
  String get schoolAdd => 'Add';

  @override
  String get schoolName => 'School name';

  @override
  String get schoolNameRequired => 'School name is required.';

  @override
  String get schoolClass => 'Class';

  @override
  String get schoolTeacher => 'Teacher';

  @override
  String get schoolStartDate => 'Start date';

  @override
  String get schoolEndDate => 'End date';

  @override
  String get schoolEndDateOptional => 'Still attending (no end date)';

  @override
  String get schoolClearEndDate => 'Clear end date';

  @override
  String get saveSchoolProfile => 'Save school';

  @override
  String get deleteSchoolTitle => 'Delete this school?';

  @override
  String get deleteSchoolMessage =>
      'This school profile will be removed from this device.';

  @override
  String get schoolEventType => 'Event type';

  @override
  String get schoolEventFirstDay => 'First day';

  @override
  String get schoolEventExam => 'Exam';

  @override
  String get schoolEventPerformance => 'School performance';

  @override
  String get schoolEventSports => 'Sports event';

  @override
  String get schoolEventCertificate => 'Certificate';

  @override
  String get schoolEventPromotion => 'Class promotion';

  @override
  String get schoolEventProject => 'Project';

  @override
  String get schoolEventReportCard => 'Report card';

  @override
  String get schoolEventCustom => 'Custom';

  @override
  String get schoolEventTitleRequired => 'Event title is required.';

  @override
  String get schoolLinkedProfile => 'Linked school';

  @override
  String get schoolNoLinkedProfile => 'None';

  @override
  String get schoolAttachmentsHint =>
      'Attach photos, certificates, or PDF report cards.';

  @override
  String get saveSchoolEvent => 'Save school event';

  @override
  String get deleteSchoolEventTitle => 'Delete this school event?';

  @override
  String get deleteSchoolEventMessage =>
      'This school event will be removed from this device.';

  @override
  String get attachmentsAndDocsTitle => 'Photos & documents';

  @override
  String get addDocument => 'Add file';

  @override
  String get schoolDashboard => 'School & achievements';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonAll => 'All';

  @override
  String get addGrowth => 'Add growth';

  @override
  String get editGrowth => 'Edit growth';

  @override
  String get addGrowthSubtitle => 'Record height and weight.';

  @override
  String get addMilestone => 'Add milestone';

  @override
  String get editMilestone => 'Edit milestone';

  @override
  String get addMilestoneSubtitle => 'First steps, words, and more.';

  @override
  String get addFirstWord => 'Add first word';

  @override
  String get editFirstWord => 'Edit first word';

  @override
  String get addFirstWordSubtitle => 'Capture the first spoken word.';

  @override
  String get growthTitle => 'Growth';

  @override
  String get growthHistory => 'Growth history';

  @override
  String get growthDetail => 'Measurement';

  @override
  String get growthHeight => 'Height';

  @override
  String get growthWeight => 'Weight';

  @override
  String get growthHeightCm => 'Height (cm)';

  @override
  String get growthHeightFt => 'Feet';

  @override
  String get growthHeightIn => 'Inches';

  @override
  String get growthWeightKg => 'Weight (kg)';

  @override
  String get growthWeightLb => 'Weight (lb)';

  @override
  String get growthNeedValue => 'Enter height, weight, or both.';

  @override
  String growthPreviousContext(String height, String weight) {
    return 'Previous: $height · $weight';
  }

  @override
  String get saveGrowth => 'Save measurement';

  @override
  String get growthHeightChart => 'Height';

  @override
  String get growthWeightChart => 'Weight';

  @override
  String get growthRange6m => '6 mo';

  @override
  String get growthRange1y => '1 yr';

  @override
  String get growthRangeAll => 'All';

  @override
  String get growthChartNeedMore =>
      'Add at least two measurements to see a chart.';

  @override
  String get unitCm => 'Height in cm';

  @override
  String get unitFtIn => 'Height in ft/in';

  @override
  String get unitKg => 'Weight in kg';

  @override
  String get unitLb => 'Weight in lb';

  @override
  String get deleteGrowthTitle => 'Delete this measurement?';

  @override
  String get deleteGrowthMessage =>
      'This growth record will be removed from this device.';

  @override
  String get milestonesTitle => 'Milestones';

  @override
  String get milestoneCategories => 'Categories';

  @override
  String get milestoneTemplates => 'Quick milestones';

  @override
  String get recentMilestones => 'Recent milestones';

  @override
  String get milestonesEmpty => 'No milestones yet. Celebrate a first!';

  @override
  String get milestoneTitleField => 'Title';

  @override
  String get milestoneTitleRequired => 'Milestone title is required.';

  @override
  String get saveMilestone => 'Save milestone';

  @override
  String get milestoneMovement => 'Movement';

  @override
  String get milestoneSpeech => 'Speech';

  @override
  String get milestoneSocial => 'Social';

  @override
  String get milestoneSelfCare => 'Self-care';

  @override
  String get milestoneLearning => 'Learning';

  @override
  String get milestoneCustom => 'Custom';

  @override
  String get templateFirstCrawl => 'First crawl';

  @override
  String get templateFirstStand => 'First stand';

  @override
  String get templateFirstStep => 'First step';

  @override
  String get templateFirstWalk => 'First walk';

  @override
  String get templateFirstRun => 'First run';

  @override
  String get templateFirstBicycle => 'First bicycle ride';

  @override
  String get templateFirstWord => 'First word';

  @override
  String get templateFirstSentence => 'First sentence';

  @override
  String get templateWroteOwnName => 'Wrote own name';

  @override
  String get deleteMilestoneTitle => 'Delete this milestone?';

  @override
  String get deleteMilestoneMessage =>
      'This milestone will be removed from this device.';

  @override
  String get datePrecisionLabel => 'How sure are you about the date?';

  @override
  String get datePrecisionExact => 'Exact date';

  @override
  String get datePrecisionMonth => 'Month only';

  @override
  String get datePrecisionYear => 'Year only';

  @override
  String get datePrecisionApproximate => 'Approximate';

  @override
  String get datePrecisionUnknown => 'Unknown';

  @override
  String get datePrecisionPick => 'Choose a date';

  @override
  String get datePrecisionPickMonth => 'Choose month';

  @override
  String get datePrecisionPickYear => 'Choose year';

  @override
  String get firstWordsTitle => 'First words';

  @override
  String get firstWordsEmpty => 'No first words yet.';

  @override
  String get firstWordDetail => 'First word';

  @override
  String get firstWordField => 'Word';

  @override
  String get firstWordRequired => 'Word is required.';

  @override
  String get firstWordLanguage => 'Language';

  @override
  String get firstWordLanguageHint => 'Bangla, English…';

  @override
  String get firstWordContext => 'Story / context';

  @override
  String get firstWordAudioPlaceholder => 'Audio coming later';

  @override
  String get firstWordAudioHint =>
      'Mark this for future audio recording support.';

  @override
  String get saveFirstWord => 'Save first word';

  @override
  String get deleteFirstWordTitle => 'Delete this first word?';

  @override
  String get deleteFirstWordMessage =>
      'This first word will be removed from this device.';

  @override
  String get addMemory => 'Add memory';

  @override
  String get editMemory => 'Edit memory';

  @override
  String get addMemorySubtitle => 'Write a story, mood, and photos.';

  @override
  String get addFunnyMoment => 'Funny moment';

  @override
  String get editFunnyMoment => 'Edit funny moment';

  @override
  String get addFunnySubtitle => 'Capture a quote or silly story.';

  @override
  String get addAchievement => 'Achievement';

  @override
  String get editAchievement => 'Edit achievement';

  @override
  String get addAchievementSubtitle => 'Celebrate a proud win with photos.';

  @override
  String get quickTemplates => 'Quick templates';

  @override
  String get templateSomethingFunny => 'Something funny';

  @override
  String get templateSomethingNew => 'Something new';

  @override
  String get templateProudMoment => 'Proud moment';

  @override
  String get templateDifficultDay => 'Difficult day';

  @override
  String get templateFavoriteMoment => 'Favorite moment';

  @override
  String get templatePhotoMemory => 'Photo memory';

  @override
  String get memoryDate => 'Date';

  @override
  String get memoryTitle => 'Title';

  @override
  String get memoryStory => 'Story';

  @override
  String get memoryStoryRequired => 'Add a title or story to save this memory.';

  @override
  String get memoryMood => 'Mood';

  @override
  String get memoryLocation => 'Location';

  @override
  String get memoryTags => 'Tags';

  @override
  String get memoryTagsHint => 'family, park, first time';

  @override
  String get saveMemory => 'Save memory';

  @override
  String get favorite => 'Favorite';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodProud => 'Proud';

  @override
  String get moodSilly => 'Silly';

  @override
  String get moodTired => 'Tired';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodGrateful => 'Grateful';

  @override
  String get attachmentsTitle => 'Photos';

  @override
  String get attachmentsEmpty => 'No photos yet.';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get funnyQuote => 'Funny quote';

  @override
  String get funnyContentRequired => 'Add a quote, story, or title.';

  @override
  String get peoplePresent => 'Who was there';

  @override
  String get saveFunnyMoment => 'Save funny moment';

  @override
  String get achievementTitle => 'Title';

  @override
  String get achievementTitleRequired => 'Achievement title is required.';

  @override
  String get achievementCategory => 'Category';

  @override
  String get achievementDescription => 'Description';

  @override
  String get achievementAttachmentsHint =>
      'Attach a certificate or celebration photo.';

  @override
  String get saveAchievement => 'Save achievement';

  @override
  String get categorySchool => 'School';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryArts => 'Arts';

  @override
  String get categorySocial => 'Social';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryOther => 'Other';

  @override
  String get deleteMemoryTitle => 'Delete this memory?';

  @override
  String get deleteMemoryMessage =>
      'This memory will be removed from this device.';

  @override
  String get deleteFunnyTitle => 'Delete this funny moment?';

  @override
  String get deleteFunnyMessage =>
      'This funny moment will be removed from this device.';

  @override
  String get deleteAchievementTitle => 'Delete this achievement?';

  @override
  String get deleteAchievementMessage =>
      'This achievement will be removed from this device.';

  @override
  String get discardDraftTitle => 'Discard changes?';

  @override
  String get discardDraftMessage =>
      'You have unsaved changes. If you leave now, they will be lost.';

  @override
  String get commonKeepEditing => 'Keep editing';

  @override
  String get commonDiscard => 'Discard';

  @override
  String get kindJournal => 'Memory';

  @override
  String get kindFunny => 'Funny';

  @override
  String get kindAchievement => 'Achievement';

  @override
  String get healthTitle => 'Health';

  @override
  String get healthSummary => 'Health summary';

  @override
  String get healthDisclaimerShort =>
      'Parent-entered notes — not a substitute for medical advice.';

  @override
  String get healthDisclaimerFull =>
      'Information in Shishur Dinlipi is entered by the parent or caregiver and should not replace official medical records or professional medical advice.';

  @override
  String get healthBloodGroup => 'Blood group';

  @override
  String get healthLatestGrowth => 'Latest growth';

  @override
  String get healthCurrentMedicine => 'Current medicine';

  @override
  String get healthRecentIllness => 'Recent illness';

  @override
  String get healthVaccination => 'Vaccination';

  @override
  String get healthLastDoctorVisit => 'Last doctor visit';

  @override
  String get healthUpcoming => 'Upcoming';

  @override
  String get healthGridVaccinations => 'Vaccinations';

  @override
  String get healthGridIllness => 'Illness history';

  @override
  String get healthGridMedicines => 'Medicines';

  @override
  String get healthGridDoctorVisits => 'Doctor visits';

  @override
  String get healthGridDocuments => 'Documents';

  @override
  String get healthEmpty => 'No health records yet. Add the first one.';

  @override
  String get healthAdd => 'Add';

  @override
  String get commonNone => 'None';

  @override
  String get commonNotes => 'Notes';

  @override
  String get vaccinationTitle => 'Vaccinations';

  @override
  String get vaccinationsEmpty => 'No vaccinations yet.';

  @override
  String get addVaccination => 'Add vaccination';

  @override
  String get editVaccination => 'Edit vaccination';

  @override
  String get vaccineName => 'Vaccine name';

  @override
  String get vaccineNameRequired => 'Vaccine name is required.';

  @override
  String get vaccineDose => 'Dose';

  @override
  String get vaccineScheduledDate => 'Scheduled date';

  @override
  String get vaccineGivenDate => 'Given date';

  @override
  String get vaccineProvider => 'Provider';

  @override
  String get vaccineClinic => 'Clinic';

  @override
  String get vaccineBatch => 'Batch number';

  @override
  String get vaccineStatus => 'Status';

  @override
  String get vaccineStatusUpcoming => 'Upcoming';

  @override
  String get vaccineStatusCompleted => 'Completed';

  @override
  String get vaccineStatusDelayed => 'Delayed';

  @override
  String get vaccineStatusSkipped => 'Skipped';

  @override
  String get vaccineStatusUnknown => 'Unknown';

  @override
  String get saveVaccination => 'Save vaccination';

  @override
  String get deleteVaccinationTitle => 'Delete this vaccination?';

  @override
  String get deleteVaccinationMessage =>
      'This vaccination record will be removed from this device.';

  @override
  String get vaccineAttachmentsHint =>
      'Attach a vaccination card photo or PDF.';

  @override
  String get illnessTitle => 'Illness history';

  @override
  String get illnessesEmpty => 'No illness episodes yet.';

  @override
  String get addIllness => 'Add illness';

  @override
  String get editIllness => 'Edit illness';

  @override
  String get illnessTitleField => 'Title';

  @override
  String get illnessTitleRequired => 'Illness title is required.';

  @override
  String get illnessStartDate => 'Start date';

  @override
  String get illnessEndDate => 'End date';

  @override
  String get illnessOngoing => 'Still recovering (no end date)';

  @override
  String get illnessClearEndDate => 'Clear end date';

  @override
  String get illnessSymptoms => 'Symptoms';

  @override
  String get illnessTemperature => 'Max temperature (°C)';

  @override
  String get illnessDiagnosis => 'Diagnosis';

  @override
  String get illnessRecoveryNote => 'Recovery note';

  @override
  String get illnessLinkedVisit => 'Linked doctor visit';

  @override
  String get illnessNoLinkedVisit => 'None';

  @override
  String get saveIllness => 'Save illness';

  @override
  String get deleteIllnessTitle => 'Delete this illness?';

  @override
  String get deleteIllnessMessage =>
      'This illness record will be removed from this device.';

  @override
  String get illnessAttachmentsHint =>
      'Attach photos or documents from this illness.';

  @override
  String get symptomFever => 'Fever';

  @override
  String get symptomCough => 'Cough';

  @override
  String get symptomCold => 'Cold';

  @override
  String get symptomVomiting => 'Vomiting';

  @override
  String get symptomDiarrhea => 'Diarrhea';

  @override
  String get symptomRash => 'Rash';

  @override
  String get symptomHeadache => 'Headache';

  @override
  String get symptomStomachPain => 'Stomach pain';

  @override
  String get symptomBreathing => 'Breathing difficulty';

  @override
  String get symptomAllergy => 'Allergy';

  @override
  String get symptomInjury => 'Injury';

  @override
  String get symptomOther => 'Other';

  @override
  String get medicineTitle => 'Medicines';

  @override
  String get medicinesEmpty => 'No medicines yet.';

  @override
  String get addMedicine => 'Add medicine';

  @override
  String get editMedicine => 'Edit medicine';

  @override
  String get medicineName => 'Medicine name';

  @override
  String get medicineNameRequired => 'Medicine name is required.';

  @override
  String get medicineStrength => 'Strength';

  @override
  String get medicineDose => 'Dose';

  @override
  String get medicineFrequency => 'Frequency';

  @override
  String get medicineStartDate => 'Start date';

  @override
  String get medicineEndDate => 'End date';

  @override
  String get medicineReason => 'Reason';

  @override
  String get medicinePrescriber => 'Prescriber';

  @override
  String get medicineStatus => 'Status';

  @override
  String get medicineStatusActive => 'Active';

  @override
  String get medicineStatusCompleted => 'Completed';

  @override
  String get medicineStatusStopped => 'Stopped';

  @override
  String get medicineStatusAsNeeded => 'As needed';

  @override
  String get medicineSchedule => 'Schedule';

  @override
  String get medicineAddScheduleTime => 'Add time';

  @override
  String get saveMedicine => 'Save medicine';

  @override
  String get deleteMedicineTitle => 'Delete this medicine?';

  @override
  String get deleteMedicineMessage =>
      'This medicine record will be removed from this device.';

  @override
  String get doctorVisitTitle => 'Doctor visits';

  @override
  String get doctorVisitsEmpty => 'No doctor visits yet.';

  @override
  String get addDoctorVisit => 'Add doctor visit';

  @override
  String get editDoctorVisit => 'Edit doctor visit';

  @override
  String get doctorName => 'Doctor';

  @override
  String get doctorNameRequired => 'Doctor name is required.';

  @override
  String get doctorSpecialty => 'Specialty';

  @override
  String get doctorHospital => 'Chamber / hospital';

  @override
  String get doctorReason => 'Reason';

  @override
  String get doctorSymptoms => 'Symptoms';

  @override
  String get doctorDiagnosis => 'Diagnosis';

  @override
  String get doctorTests => 'Tests advised';

  @override
  String get doctorFollowUp => 'Follow-up date';

  @override
  String get saveDoctorVisit => 'Save visit';

  @override
  String get deleteDoctorVisitTitle => 'Delete this visit?';

  @override
  String get deleteDoctorVisitMessage =>
      'This doctor visit will be removed from this device.';

  @override
  String get doctorAttachmentsHint => 'Attach a prescription photo or PDF.';

  @override
  String get medicalDocsTitle => 'Medical documents';

  @override
  String get medicalDocsEmpty => 'No medical documents yet.';

  @override
  String get addMedicalDocument => 'Add document';

  @override
  String get editMedicalDocument => 'Edit document';

  @override
  String get medicalDocType => 'Document type';

  @override
  String get medicalDocTitle => 'Title';

  @override
  String get medicalDocTitleRequired => 'Document title is required.';

  @override
  String get medicalDocDate => 'Document date';

  @override
  String get medicalDocNotes => 'Notes';

  @override
  String get medicalDocFileRequired => 'A file is required.';

  @override
  String get medicalDocPickFile => 'Choose file';

  @override
  String get saveMedicalDocument => 'Save document';

  @override
  String get deleteMedicalDocumentTitle => 'Delete this document?';

  @override
  String get deleteMedicalDocumentMessage =>
      'This medical document will be removed from this device.';

  @override
  String get docTypePrescription => 'Prescription';

  @override
  String get docTypeDiagnostic => 'Diagnostic report';

  @override
  String get docTypeVaccinationCard => 'Vaccination card';

  @override
  String get docTypeDischarge => 'Discharge summary';

  @override
  String get docTypeCertificate => 'Medical certificate';

  @override
  String get docTypeOther => 'Other';

  @override
  String get timelineEmpty => 'No timeline entries yet.';

  @override
  String get timelineFilterAll => 'All';

  @override
  String get timelineFilterMemories => 'Memories';

  @override
  String get timelineFilterGrowth => 'Growth';

  @override
  String get timelineFilterMilestones => 'Milestones';

  @override
  String get timelineFilterHealth => 'Health';

  @override
  String get timelineFilterSchool => 'School';

  @override
  String get timelineFilterAchievements => 'Achievements';

  @override
  String get timelineFilterPhotos => 'Photos';

  @override
  String get timelineFilterFunny => 'Funny';

  @override
  String get timelineTypeJournal => 'Memory';

  @override
  String get timelineTypeFunny => 'Funny';

  @override
  String get timelineTypeAchievement => 'Achievement';

  @override
  String get timelineTypeGrowth => 'Growth';

  @override
  String get timelineTypeMilestone => 'Milestone';

  @override
  String get timelineTypeSchool => 'School';

  @override
  String get timelineTypeVaccination => 'Vaccination';

  @override
  String get timelineTypeIllness => 'Illness';

  @override
  String get timelineTypeDoctor => 'Doctor visit';

  @override
  String get timelineTypeBirthday => 'Birthday';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarNoEvents => 'No events on this day.';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get remindersEmpty => 'No reminders yet.';

  @override
  String get addReminder => 'Add reminder';

  @override
  String get editReminder => 'Edit reminder';

  @override
  String get reminderTitleField => 'Title';

  @override
  String get reminderTitleRequired => 'Title is required.';

  @override
  String get reminderType => 'Type';

  @override
  String get reminderDateTime => 'Date & time';

  @override
  String get reminderRepeat => 'Repeat';

  @override
  String get reminderEnabled => 'Notifications on';

  @override
  String get reminderNotes => 'Notes';

  @override
  String get saveReminder => 'Save reminder';

  @override
  String get deleteReminderTitle => 'Delete this reminder?';

  @override
  String get deleteReminderMessage =>
      'This reminder will be removed from this device.';

  @override
  String get reminderTypeVaccination => 'Vaccination';

  @override
  String get reminderTypeMedicine => 'Medicine';

  @override
  String get reminderTypeDoctorFollowUp => 'Doctor follow-up';

  @override
  String get reminderTypeBirthday => 'Birthday';

  @override
  String get reminderTypeWeeklyMemory => 'Weekly memory';

  @override
  String get reminderTypeBackup => 'Backup';

  @override
  String get reminderTypeCustom => 'Custom';

  @override
  String get reminderRepeatNone => 'Does not repeat';

  @override
  String get reminderRepeatDaily => 'Daily';

  @override
  String get reminderRepeatWeekly => 'Weekly';

  @override
  String get reminderRepeatYearly => 'Yearly';

  @override
  String get reminderRepeatMonthly => 'Monthly';

  @override
  String get onThisDayTitle => 'On this day';

  @override
  String get onThisDayEmpty => 'Nothing from past years on this day yet.';

  @override
  String onThisDayYearsAgo(int years) {
    return '$years years ago';
  }

  @override
  String get upcomingReminders => 'Upcoming reminders';

  @override
  String get notificationPermissionTitle => 'Turn on reminders?';

  @override
  String get notificationPermissionBody =>
      'Shishur Dinlipi can remind you about vaccinations, medicines, follow-up visits and important memories.';

  @override
  String get notificationAllow => 'Allow notifications';

  @override
  String get notificationNotNow => 'Not now';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search memories, health, school…';

  @override
  String get searchEmpty => 'No matching records.';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchFilterAll => 'All';

  @override
  String get searchTypeJournal => 'Memories';

  @override
  String get searchTypeMilestone => 'Milestones';

  @override
  String get searchTypeMedicine => 'Medicines';

  @override
  String get searchTypeDoctor => 'Doctors';

  @override
  String get searchTypeIllness => 'Illnesses';

  @override
  String get searchTypeSchool => 'School';

  @override
  String get searchTypeAchievement => 'Achievements';

  @override
  String get searchFromDate => 'From';

  @override
  String get searchToDate => 'To';

  @override
  String get searchClearDates => 'Clear dates';

  @override
  String get photosTitle => 'Photos';

  @override
  String get photosEmpty => 'No photos yet.';

  @override
  String get photosFavorites => 'Favorites';

  @override
  String get photosByYear => 'By year';

  @override
  String get photosByAge => 'By age';

  @override
  String get photosByCategory => 'By category';

  @override
  String get photosAll => 'All';

  @override
  String get photoMissing => 'This photo or file is no longer available.';

  @override
  String get photoFavorite => 'Favorite';

  @override
  String get photoUnfavorite => 'Remove favorite';

  @override
  String get albumsEmpty => 'No albums yet. Create a custom album.';

  @override
  String get addAlbum => 'Create album';

  @override
  String get editAlbum => 'Edit album';

  @override
  String get albumTitleField => 'Album title';

  @override
  String get albumTitleRequired => 'Album title is required.';

  @override
  String get albumTheme => 'Theme';

  @override
  String get albumCover => 'Cover photo';

  @override
  String get albumAddPhotos => 'Add photos';

  @override
  String get albumNoItems => 'No items in this album yet.';

  @override
  String get saveAlbum => 'Save album';

  @override
  String get deleteAlbumTitle => 'Delete this album?';

  @override
  String get deleteAlbumMessage =>
      'This album will be removed from this device.';

  @override
  String get albumThemeMinimal => 'Minimal';

  @override
  String get albumThemePlayful => 'Playful';

  @override
  String get albumThemeColorful => 'Colorful';

  @override
  String get albumThemeElegant => 'Elegant';

  @override
  String get tagsTitle => 'Tags';

  @override
  String get tagsAddHint => 'Add a tag';

  @override
  String get tagsEmpty => 'No tags yet.';

  @override
  String get yearReviewTitle => 'Year in Review';

  @override
  String get yearReviewSubtitle =>
      'Create a yearly memory album — entirely offline.';

  @override
  String get yearReviewPickYear => 'Choose a year';

  @override
  String get yearReviewEmptyYears =>
      'Add a child profile to start a Year in Review.';

  @override
  String yearReviewOpenYear(String name, int year) {
    return 'Open $name\'s $year review';
  }

  @override
  String get yearReviewEditorTitle => 'Edit Year in Review';

  @override
  String get yearReviewTheme => 'Theme';

  @override
  String get yearReviewLanguage => 'PDF language';

  @override
  String get yearReviewIncludeHealth => 'Include health highlights';

  @override
  String get yearReviewParentLetter => 'Parent letter';

  @override
  String get yearReviewParentLetterHint =>
      'Write a short letter to your child…';

  @override
  String get yearReviewCover => 'Cover photo';

  @override
  String get yearReviewNoCover => 'No cover';

  @override
  String get yearReviewNoCoverPhotos =>
      'No photos this year to use as a cover.';

  @override
  String get yearReviewEditCaption => 'Edit caption';

  @override
  String get yearReviewGenerate => 'Generate PDF';

  @override
  String get yearReviewSaved => 'Preferences saved.';

  @override
  String get yearReviewGeneratingTitle => 'Creating your album';

  @override
  String get yearReviewStagePreparing => 'Preparing memories…';

  @override
  String get yearReviewStagePhotos => 'Processing photos…';

  @override
  String get yearReviewStageBuilding => 'Building pages…';

  @override
  String get yearReviewStageSaving => 'Saving PDF…';

  @override
  String get yearReviewStageComplete => 'Complete';

  @override
  String get yearReviewStageFailed => 'Could not create the PDF';

  @override
  String get yearReviewPdfReady => 'Your Year in Review PDF is ready.';

  @override
  String get yearReviewPreview => 'Preview';

  @override
  String get yearReviewShare => 'Share';

  @override
  String get yearReviewPrint => 'Print';

  @override
  String get yearReviewSavedToExports =>
      'Saved on this device in your exports folder.';

  @override
  String get yearReviewSectionGrowth => 'Growth';

  @override
  String get yearReviewSectionMilestones => 'Milestones';

  @override
  String get yearReviewSectionSchool => 'School';

  @override
  String get yearReviewSectionAchievements => 'Achievements';

  @override
  String get yearReviewSectionFunny => 'Funny moments';

  @override
  String get yearReviewSectionPhotos => 'Photos';

  @override
  String get yearReviewSectionBirthday => 'Birthday';

  @override
  String get yearReviewSectionJournals => 'Journal highlights';

  @override
  String get yearReviewSectionHealth => 'Health';
}
