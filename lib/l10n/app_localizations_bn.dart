// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Shishur Dinlipi';

  @override
  String get appNameBn => 'শিশুর দিনলিপি';

  @override
  String get tagline => 'আপনার শিশুর গল্প, যত্নে সংরক্ষিত।';

  @override
  String get navHome => 'হোম';

  @override
  String get navTimeline => 'সময়রেখা';

  @override
  String get navAdd => 'যোগ করুন';

  @override
  String get navAlbums => 'অ্যালবাম';

  @override
  String get navMore => 'আরও';

  @override
  String get splashTitle => 'শিশুর দিনলিপি';

  @override
  String get splashLoading => 'আপনার জার্নাল প্রস্তুত হচ্ছে…';

  @override
  String get onboardingTitle =>
      'ছোট ছোট মুহূর্তগুলোই একদিন বড় স্মৃতি হয়ে থাকে।';

  @override
  String get onboardingContinue => 'এগিয়ে যান';

  @override
  String get chooseLanguageTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get privacyTitle => 'আপনার শিশুর স্মৃতি আপনার কাছেই থাকে';

  @override
  String get privacyPrivate =>
      'ডিফল্টে ব্যক্তিগত — আপনার ডিভাইসে নিরাপদে সংরক্ষিত।';

  @override
  String get privacyOffline => 'অফলাইনে কাজ করে — ইন্টারনেট লাগে না।';

  @override
  String get privacyControl =>
      'নিয়ন্ত্রণ আপনার — যেকোনো সময় এক্সপোর্ট, ব্যাকআপ বা মুছে ফেলুন।';

  @override
  String get privacyContinue => 'বুঝেছি';

  @override
  String get welcomeTitle => 'ছোট ছোট মুহূর্তগুলোই একদিন বড় স্মৃতি হয়ে থাকে।';

  @override
  String get welcomeCta => 'শিশুর প্রোফাইল তৈরি করুন';

  @override
  String get welcomeHighlightGrowth => 'বৃদ্ধি';

  @override
  String get welcomeHighlightHealth => 'স্বাস্থ্য';

  @override
  String get welcomeHighlightMilestones => 'মাইলফলক';

  @override
  String get welcomeHighlightPhotos => 'ছবি';

  @override
  String get createFirstChildTitle => 'প্রথম শিশু যোগ করুন';

  @override
  String get createFirstChildSubtitle => 'শুরু করতে কিছু মৌলিক তথ্য দিন।';

  @override
  String get addMoreDetailsLater => 'বিস্তারিত পরে যোগ করব';

  @override
  String get securityTitle => 'শিশুর জার্নাল সুরক্ষিত রাখুন';

  @override
  String get securitySubtitle =>
      'ঐচ্ছিক পিন বা বায়োমেট্রিক্স ব্যক্তিগত স্মৃতি রক্ষা করে।';

  @override
  String get securitySetPin => 'পিন সেট করুন';

  @override
  String get securityBiometrics => 'বায়োমেট্রিক্স চালু করুন';

  @override
  String get securityLater => 'পরে সেটআপ করব';

  @override
  String get setupCompleteTitle => 'সব প্রস্তুত!';

  @override
  String setupCompleteSubtitle(String name) {
    return '$name-এর জার্নাল তৈরি। সুন্দর মুহূর্তগুলো ধরে রাখা শুরু করুন।';
  }

  @override
  String get goToHome => 'হোমে যান';

  @override
  String get addFirstMemory => 'প্রথম স্মৃতি যোগ করুন';

  @override
  String get homeTitle => 'হোম';

  @override
  String get homePlaceholder => 'আপনার শিশুর গল্প এখান থেকে শুরু।';

  @override
  String get homeGreetingMorning => 'সুপ্রভাত';

  @override
  String get homeGreetingAfternoon => 'শুভ বিকাল';

  @override
  String get homeGreetingEvening => 'শুভ সন্ধ্যা';

  @override
  String homeAgeLine(String name, String age) {
    return '$name এখন $age';
  }

  @override
  String get growthSnapshot => 'বৃদ্ধির সারাংশ';

  @override
  String get growthEmpty => 'এখনো কোনো মাপ নেই। প্রথম উচ্চতা বা ওজন যোগ করুন।';

  @override
  String get quickAdd => 'দ্রুত যোগ';

  @override
  String get quickAddMemory => 'স্মৃতি';

  @override
  String get quickAddPhoto => 'ছবি';

  @override
  String get quickAddGrowth => 'বৃদ্ধি';

  @override
  String get quickAddMilestone => 'মাইলফলক';

  @override
  String get quickAddHealth => 'স্বাস্থ্য';

  @override
  String get quickAddAchievement => 'অর্জন';

  @override
  String get recentMemories => 'সাম্প্রতিক স্মৃতি';

  @override
  String get recentMemoriesEmpty =>
      'এখনো কোনো স্মৃতি নেই। প্রথম স্মৃতি যোগ করে গল্প শুরু করুন।';

  @override
  String get upcoming => 'আসন্ন';

  @override
  String get upcomingEmpty => 'এখনো কোনো রিমাইন্ডার নেই।';

  @override
  String get timelineTitle => 'সময়রেখা';

  @override
  String get timelinePlaceholder => 'স্মৃতি ও রেকর্ড এখানে দেখা যাবে।';

  @override
  String get addTitle => 'দ্রুত যোগ';

  @override
  String get addPlaceholder => 'কী যোগ করতে চান তা বেছে নিন।';

  @override
  String get albumsTitle => 'অ্যালবাম';

  @override
  String get albumsPlaceholder => 'বছরের স্মৃতিচারণ ও অ্যালবাম এখানে থাকবে।';

  @override
  String get moreTitle => 'আরও';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get settingsGeneral => 'সাধারণ';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsAppearance => 'চেহারা';

  @override
  String get settingsThemeSystem => 'সিস্টেম';

  @override
  String get settingsThemeLight => 'লাইট';

  @override
  String get settingsThemeDark => 'ডার্ক';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageBangla => 'বাংলা';

  @override
  String get settingsAbout => 'সম্পর্কে';

  @override
  String settingsVersion(String version) {
    return 'সংস্করণ $version';
  }

  @override
  String get commonRetry => 'আবার চেষ্টা';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get commonSave => 'সংরক্ষণ';

  @override
  String get commonContinue => 'এগিয়ে যান';

  @override
  String get commonGoBack => 'ফিরে যান';

  @override
  String get commonDelete => 'মুছুন';

  @override
  String get commonEdit => 'সম্পাদনা';

  @override
  String get commonSkip => 'এখন নয়';

  @override
  String get commonSearch => 'খুঁজুন';

  @override
  String get errorGeneric => 'কিছু একটা সমস্যা হয়েছে।';

  @override
  String get errorDatabase => 'জার্নাল ডাটাবেস খোলা যায়নি।';

  @override
  String get errorFile => 'ফাইল অ্যাক্সেস করা যায়নি।';

  @override
  String get errorValidation => 'চিহ্নিত ঘরগুলো যাচাই করুন।';

  @override
  String get errorPermission => 'এগিয়ে যেতে অনুমতি প্রয়োজন।';

  @override
  String get errorBackup => 'ব্যাকআপ ব্যর্থ হয়েছে।';

  @override
  String get errorRestore => 'পুনরুদ্ধার ব্যর্থ হয়েছে।';

  @override
  String get errorPdf => 'পিডিএফ তৈরি করা যায়নি।';

  @override
  String get childName => 'শিশুর নাম';

  @override
  String get childNickname => 'ডাকনাম';

  @override
  String get childDob => 'জন্ম তারিখ';

  @override
  String get childGender => 'লিঙ্গ';

  @override
  String get childGenderBoy => 'ছেলে';

  @override
  String get childGenderGirl => 'মেয়ে';

  @override
  String get childGenderOther => 'অন্যান্য';

  @override
  String get childBloodGroup => 'রক্তের গ্রুপ';

  @override
  String get childBirthWeight => 'জন্মের ওজন (কেজি)';

  @override
  String get childBirthHeight => 'জন্মের উচ্চতা (সেমি)';

  @override
  String get childBirthplace => 'জন্মস্থান';

  @override
  String get childSchool => 'স্কুল';

  @override
  String get childClass => 'ক্লাস';

  @override
  String get childNotes => 'নোট';

  @override
  String get childNameRequired => 'শিশুর নাম আবশ্যক।';

  @override
  String get childDobFuture => 'জন্ম তারিখ ভবিষ্যতে হতে পারে না।';

  @override
  String get saveChild => 'শিশু সংরক্ষণ';

  @override
  String get addChild => 'শিশু যোগ করুন';

  @override
  String get addAnotherChild => 'আরেকটি শিশু যোগ করুন';

  @override
  String get editChild => 'শিশু সম্পাদনা';

  @override
  String get childProfile => 'শিশুর প্রোফাইল';

  @override
  String get manageChildren => 'শিশু ব্যবস্থাপনা';

  @override
  String get selectChild => 'একজন শিশু বেছে নিন';

  @override
  String get childrenTitle => 'শিশুরা';

  @override
  String get noChildrenTitle => 'এখনো কোনো শিশু নেই';

  @override
  String get noChildrenMessage =>
      'গল্প সংরক্ষণ শুরু করতে একটি শিশুর প্রোফাইল যোগ করুন।';

  @override
  String get aboutSection => 'সম্পর্কে';

  @override
  String get deleteChildTitle => 'এই শিশু মুছবেন?';

  @override
  String deleteChildMessage(String name) {
    return 'এতে $name-এর জার্নাল এ ডিভাইস থেকে সরবে। আগে ব্যাকআপ নেওয়ার পরামর্শ। সহজে ফেরত আনা যাবে না।';
  }

  @override
  String get deleteChildConfirm => 'শিশু মুছুন';

  @override
  String get setAsSelected => 'নির্বাচিত করুন';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get chooseGallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get removePhoto => 'ছবি সরান';

  @override
  String get replacePhoto => 'ছবি বদলান';

  @override
  String get addPhotoTitle => 'একটি ছবি যোগ করুন';

  @override
  String get photoPermissionDenied =>
      'ছবি যোগ করতে চাইলেই কেবল ফটো অ্যাক্সেস লাগে।';

  @override
  String get cameraPermissionDenied =>
      'ছবি তুলতে চাইলেই কেবল ক্যামেরা অ্যাক্সেস লাগে।';

  @override
  String get basicSection => 'মৌলিক';

  @override
  String get birthSection => 'জন্ম';

  @override
  String get healthSection => 'স্বাস্থ্য';

  @override
  String get schoolSection => 'স্কুল';

  @override
  String get notesSection => 'নোট';

  @override
  String get addSubtitle => 'আজ কী সংরক্ষণ করতে চান বেছে নিন।';

  @override
  String get addGroupMemories => 'স্মৃতি';

  @override
  String get addGroupComingSoon => 'শীঘ্রই আসছে';

  @override
  String get addComingSoonMessage =>
      'স্কুল ও স্বাস্থ্য রেকর্ড পরের স্প্রিন্টে আসবে।';

  @override
  String get addComingSoonHealthOnly =>
      'স্বাস্থ্য রেকর্ড পরের স্প্রিন্টে আসবে।';

  @override
  String get addGroupSchool => 'স্কুল';

  @override
  String get addSchoolProfile => 'স্কুল যোগ করুন';

  @override
  String get editSchoolProfile => 'স্কুল সম্পাদনা';

  @override
  String get addSchoolProfileSubtitle => 'স্কুলের নাম, ক্লাস ও শিক্ষক।';

  @override
  String get addSchoolEvent => 'স্কুল ইভেন্ট যোগ করুন';

  @override
  String get editSchoolEvent => 'স্কুল ইভেন্ট সম্পাদনা';

  @override
  String get addSchoolEventSubtitle => 'প্রথম দিন, পরীক্ষা, সনদপত্র ও আরও।';

  @override
  String get addReportCardSubtitle => 'রিপোর্ট কার্ডের ছবি বা PDF যোগ করুন।';

  @override
  String get addGroupDevelopment => 'বিকাশ';

  @override
  String get schoolTitle => 'স্কুল';

  @override
  String get schoolCurrent => 'বর্তমান স্কুল';

  @override
  String get schoolCurrentBadge => 'বর্তমান';

  @override
  String get schoolEmpty => 'এখনো কোনো স্কুল প্রোফাইল নেই। প্রথমটি যোগ করুন।';

  @override
  String get schoolHistory => 'স্কুলের ইতিহাস';

  @override
  String get schoolEvents => 'স্কুল ইভেন্ট';

  @override
  String get schoolEventsEmpty => 'এখনো কোনো স্কুল ইভেন্ট নেই।';

  @override
  String get schoolRecentEvent => 'সাম্প্রতিক স্কুল ইভেন্ট';

  @override
  String get schoolTimeline => 'স্কুলের সময়রেখা';

  @override
  String get schoolAdd => 'যোগ করুন';

  @override
  String get schoolName => 'স্কুলের নাম';

  @override
  String get schoolNameRequired => 'স্কুলের নাম আবশ্যক।';

  @override
  String get schoolClass => 'ক্লাস';

  @override
  String get schoolTeacher => 'শিক্ষক';

  @override
  String get schoolStartDate => 'শুরুর তারিখ';

  @override
  String get schoolEndDate => 'শেষ তারিখ';

  @override
  String get schoolEndDateOptional => 'এখনো পড়ছে (শেষ তারিখ নেই)';

  @override
  String get schoolClearEndDate => 'শেষ তারিখ সরান';

  @override
  String get saveSchoolProfile => 'স্কুল সংরক্ষণ';

  @override
  String get deleteSchoolTitle => 'এই স্কুল মুছবেন?';

  @override
  String get deleteSchoolMessage => 'এই স্কুল প্রোফাইল এই ডিভাইস থেকে সরবে।';

  @override
  String get schoolEventType => 'ইভেন্টের ধরন';

  @override
  String get schoolEventFirstDay => 'প্রথম দিন';

  @override
  String get schoolEventExam => 'পরীক্ষা';

  @override
  String get schoolEventPerformance => 'স্কুল অনুষ্ঠান';

  @override
  String get schoolEventSports => 'খেলার ইভেন্ট';

  @override
  String get schoolEventCertificate => 'সনদপত্র';

  @override
  String get schoolEventPromotion => 'ক্লাস প্রমোশন';

  @override
  String get schoolEventProject => 'প্রজেক্ট';

  @override
  String get schoolEventReportCard => 'রিপোর্ট কার্ড';

  @override
  String get schoolEventCustom => 'কাস্টম';

  @override
  String get schoolEventTitleRequired => 'ইভেন্টের শিরোনাম আবশ্যক।';

  @override
  String get schoolLinkedProfile => 'সংযুক্ত স্কুল';

  @override
  String get schoolNoLinkedProfile => 'কোনোটি নয়';

  @override
  String get schoolAttachmentsHint =>
      'ছবি, সনদপত্র বা PDF রিপোর্ট কার্ড যোগ করুন।';

  @override
  String get saveSchoolEvent => 'স্কুল ইভেন্ট সংরক্ষণ';

  @override
  String get deleteSchoolEventTitle => 'এই স্কুল ইভেন্ট মুছবেন?';

  @override
  String get deleteSchoolEventMessage => 'এই স্কুল ইভেন্ট এই ডিভাইস থেকে সরবে।';

  @override
  String get attachmentsAndDocsTitle => 'ছবি ও নথি';

  @override
  String get addDocument => 'ফাইল যোগ';

  @override
  String get schoolDashboard => 'স্কুল ও অর্জন';

  @override
  String get commonSeeAll => 'সব দেখুন';

  @override
  String get commonAll => 'সব';

  @override
  String get addGrowth => 'বৃদ্ধি যোগ করুন';

  @override
  String get editGrowth => 'বৃদ্ধি সম্পাদনা';

  @override
  String get addGrowthSubtitle => 'উচ্চতা ও ওজন লিখুন।';

  @override
  String get addMilestone => 'মাইলস্টোন যোগ করুন';

  @override
  String get editMilestone => 'মাইলস্টোন সম্পাদনা';

  @override
  String get addMilestoneSubtitle => 'প্রথম হাঁটা, কথা ও আরও।';

  @override
  String get addFirstWord => 'প্রথম কথা যোগ করুন';

  @override
  String get editFirstWord => 'প্রথম কথা সম্পাদনা';

  @override
  String get addFirstWordSubtitle => 'প্রথম উচ্চারিত শব্দ রাখুন।';

  @override
  String get growthTitle => 'বৃদ্ধি';

  @override
  String get growthHistory => 'বৃদ্ধির ইতিহাস';

  @override
  String get growthDetail => 'পরিমাপ';

  @override
  String get growthHeight => 'উচ্চতা';

  @override
  String get growthWeight => 'ওজন';

  @override
  String get growthHeightCm => 'উচ্চতা (সেমি)';

  @override
  String get growthHeightFt => 'ফুট';

  @override
  String get growthHeightIn => 'ইঞ্চি';

  @override
  String get growthWeightKg => 'ওজন (কেজি)';

  @override
  String get growthWeightLb => 'ওজন (পাউন্ড)';

  @override
  String get growthNeedValue => 'উচ্চতা, ওজন বা দুটোই দিন।';

  @override
  String growthPreviousContext(String height, String weight) {
    return 'আগের: $height · $weight';
  }

  @override
  String get saveGrowth => 'পরিমাপ সংরক্ষণ';

  @override
  String get growthHeightChart => 'উচ্চতা';

  @override
  String get growthWeightChart => 'ওজন';

  @override
  String get growthRange6m => '৬ মাস';

  @override
  String get growthRange1y => '১ বছর';

  @override
  String get growthRangeAll => 'সব';

  @override
  String get growthChartNeedMore => 'চার্ট দেখতে অন্তত দুটি পরিমাপ লাগবে।';

  @override
  String get unitCm => 'উচ্চতা সেমিতে';

  @override
  String get unitFtIn => 'উচ্চতা ফুট/ইঞ্চিতে';

  @override
  String get unitKg => 'ওজন কেজিতে';

  @override
  String get unitLb => 'ওজন পাউন্ডে';

  @override
  String get deleteGrowthTitle => 'এই পরিমাপ মুছবেন?';

  @override
  String get deleteGrowthMessage => 'এই বৃদ্ধির রেকর্ড এই ডিভাইস থেকে সরবে।';

  @override
  String get milestonesTitle => 'মাইলস্টোন';

  @override
  String get milestoneCategories => 'বিভাগ';

  @override
  String get milestoneTemplates => 'দ্রুত মাইলস্টোন';

  @override
  String get recentMilestones => 'সাম্প্রতিক মাইলস্টোন';

  @override
  String get milestonesEmpty => 'এখনো কোনো মাইলস্টোন নেই। প্রথমটি উদযাপন করুন!';

  @override
  String get milestoneTitleField => 'শিরোনাম';

  @override
  String get milestoneTitleRequired => 'মাইলস্টোনের শিরোনাম আবশ্যক।';

  @override
  String get saveMilestone => 'মাইলস্টোন সংরক্ষণ';

  @override
  String get milestoneMovement => 'চলাফেরা';

  @override
  String get milestoneSpeech => 'কথা';

  @override
  String get milestoneSocial => 'সামাজিক';

  @override
  String get milestoneSelfCare => 'নিজের যত্ন';

  @override
  String get milestoneLearning => 'শেখা';

  @override
  String get milestoneCustom => 'কাস্টম';

  @override
  String get templateFirstCrawl => 'প্রথম হামাগুড়ি';

  @override
  String get templateFirstStand => 'প্রথম দাঁড়ানো';

  @override
  String get templateFirstStep => 'প্রথম পা';

  @override
  String get templateFirstWalk => 'প্রথম হাঁটা';

  @override
  String get templateFirstRun => 'প্রথম দৌড়';

  @override
  String get templateFirstBicycle => 'প্রথম সাইকেল';

  @override
  String get templateFirstWord => 'প্রথম কথা';

  @override
  String get templateFirstSentence => 'প্রথম বাক্য';

  @override
  String get templateWroteOwnName => 'নিজের নাম লেখা';

  @override
  String get deleteMilestoneTitle => 'এই মাইলস্টোন মুছবেন?';

  @override
  String get deleteMilestoneMessage => 'এই মাইলস্টোন এই ডিভাইস থেকে সরবে।';

  @override
  String get datePrecisionLabel => 'তারিখ কতটা নিশ্চিত?';

  @override
  String get datePrecisionExact => 'সঠিক তারিখ';

  @override
  String get datePrecisionMonth => 'শুধু মাস';

  @override
  String get datePrecisionYear => 'শুধু বছর';

  @override
  String get datePrecisionApproximate => 'আনুমানিক';

  @override
  String get datePrecisionUnknown => 'অজানা';

  @override
  String get datePrecisionPick => 'তারিখ বেছে নিন';

  @override
  String get datePrecisionPickMonth => 'মাস বেছে নিন';

  @override
  String get datePrecisionPickYear => 'বছর বেছে নিন';

  @override
  String get firstWordsTitle => 'প্রথম কথা';

  @override
  String get firstWordsEmpty => 'এখনো কোনো প্রথম কথা নেই।';

  @override
  String get firstWordDetail => 'প্রথম কথা';

  @override
  String get firstWordField => 'শব্দ';

  @override
  String get firstWordRequired => 'শব্দ আবশ্যক।';

  @override
  String get firstWordLanguage => 'ভাষা';

  @override
  String get firstWordLanguageHint => 'বাংলা, ইংরেজি…';

  @override
  String get firstWordContext => 'গল্প / প্রসঙ্গ';

  @override
  String get firstWordAudioPlaceholder => 'অডিও পরে আসবে';

  @override
  String get firstWordAudioHint => 'ভবিষ্যতে অডিও রেকর্ডের জন্য চিহ্নিত করুন।';

  @override
  String get saveFirstWord => 'প্রথম কথা সংরক্ষণ';

  @override
  String get deleteFirstWordTitle => 'এই প্রথম কথা মুছবেন?';

  @override
  String get deleteFirstWordMessage => 'এই প্রথম কথা এই ডিভাইস থেকে সরবে।';

  @override
  String get addMemory => 'স্মৃতি যোগ করুন';

  @override
  String get editMemory => 'স্মৃতি সম্পাদনা';

  @override
  String get addMemorySubtitle => 'গল্প, মুড ও ছবি লিখুন।';

  @override
  String get addFunnyMoment => 'মজার মুহূর্ত';

  @override
  String get editFunnyMoment => 'মজার মুহূর্ত সম্পাদনা';

  @override
  String get addFunnySubtitle => 'একটি উক্তি বা মজার গল্প রাখুন।';

  @override
  String get addAchievement => 'অর্জন';

  @override
  String get editAchievement => 'অর্জন সম্পাদনা';

  @override
  String get addAchievementSubtitle => 'গর্বের মুহূর্ত ছবিসহ উদযাপন করুন।';

  @override
  String get quickTemplates => 'দ্রুত টেমপ্লেট';

  @override
  String get templateSomethingFunny => 'কিছু মজার';

  @override
  String get templateSomethingNew => 'কিছু নতুন';

  @override
  String get templateProudMoment => 'গর্বের মুহূর্ত';

  @override
  String get templateDifficultDay => 'কঠিন দিন';

  @override
  String get templateFavoriteMoment => 'প্রিয় মুহূর্ত';

  @override
  String get templatePhotoMemory => 'ছবির স্মৃতি';

  @override
  String get memoryDate => 'তারিখ';

  @override
  String get memoryTitle => 'শিরোনাম';

  @override
  String get memoryStory => 'গল্প';

  @override
  String get memoryStoryRequired => 'সংরক্ষণ করতে শিরোনাম বা গল্প দিন।';

  @override
  String get memoryMood => 'মুড';

  @override
  String get memoryLocation => 'স্থান';

  @override
  String get memoryTags => 'ট্যাগ';

  @override
  String get memoryTagsHint => 'পরিবার, পার্ক, প্রথমবার';

  @override
  String get saveMemory => 'স্মৃতি সংরক্ষণ';

  @override
  String get favorite => 'প্রিয়';

  @override
  String get moodHappy => 'খুশি';

  @override
  String get moodCalm => 'শান্ত';

  @override
  String get moodProud => 'গর্বিত';

  @override
  String get moodSilly => 'আজেবাজে';

  @override
  String get moodTired => 'ক্লান্ত';

  @override
  String get moodSad => 'দুঃখিত';

  @override
  String get moodGrateful => 'কৃতজ্ঞ';

  @override
  String get attachmentsTitle => 'ছবি';

  @override
  String get attachmentsEmpty => 'এখনো কোনো ছবি নেই।';

  @override
  String get addPhotos => 'ছবি যোগ';

  @override
  String get funnyQuote => 'মজার উক্তি';

  @override
  String get funnyContentRequired => 'উক্তি, গল্প বা শিরোনাম দিন।';

  @override
  String get peoplePresent => 'কে কে ছিল';

  @override
  String get saveFunnyMoment => 'মজার মুহূর্ত সংরক্ষণ';

  @override
  String get achievementTitle => 'শিরোনাম';

  @override
  String get achievementTitleRequired => 'অর্জনের শিরোনাম আবশ্যক।';

  @override
  String get achievementCategory => 'বিভাগ';

  @override
  String get achievementDescription => 'বিবরণ';

  @override
  String get achievementAttachmentsHint => 'সনদপত্র বা উদযাপনের ছবি যোগ করুন।';

  @override
  String get saveAchievement => 'অর্জন সংরক্ষণ';

  @override
  String get categorySchool => 'স্কুল';

  @override
  String get categorySports => 'খেলা';

  @override
  String get categoryArts => 'শিল্প';

  @override
  String get categorySocial => 'সামাজিক';

  @override
  String get categoryPersonal => 'ব্যক্তিগত';

  @override
  String get categoryOther => 'অন্যান্য';

  @override
  String get deleteMemoryTitle => 'এই স্মৃতি মুছবেন?';

  @override
  String get deleteMemoryMessage => 'এই স্মৃতি এই ডিভাইস থেকে সরবে।';

  @override
  String get deleteFunnyTitle => 'এই মজার মুহূর্ত মুছবেন?';

  @override
  String get deleteFunnyMessage => 'এই মজার মুহূর্ত এই ডিভাইস থেকে সরবে।';

  @override
  String get deleteAchievementTitle => 'এই অর্জন মুছবেন?';

  @override
  String get deleteAchievementMessage => 'এই অর্জন এই ডিভাইস থেকে সরবে।';

  @override
  String get discardDraftTitle => 'পরিবর্তন বাতিল করবেন?';

  @override
  String get discardDraftMessage =>
      'অসংরক্ষিত পরিবর্তন আছে। এখন চলে গেলে সেগুলো হারিয়ে যাবে।';

  @override
  String get commonKeepEditing => 'সম্পাদনা চালিয়ে যান';

  @override
  String get commonDiscard => 'বাতিল';

  @override
  String get kindJournal => 'স্মৃতি';

  @override
  String get kindFunny => 'মজার';

  @override
  String get kindAchievement => 'অর্জন';
}
