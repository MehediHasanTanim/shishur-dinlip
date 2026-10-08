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

  @override
  String get healthTitle => 'স্বাস্থ্য';

  @override
  String get healthSummary => 'স্বাস্থ্য সারসংক্ষেপ';

  @override
  String get healthDisclaimerShort =>
      'অভিভাবকের নোট — চিকিৎসা পরামর্শের বিকল্প নয়।';

  @override
  String get healthDisclaimerFull =>
      'শিশুর দিনলিপিতে তথ্য অভিভাবক বা যত্নকারী লিখে রাখেন। এটি অফিসিয়াল মেডিকেল রেকর্ড বা পেশাদার চিকিৎসা পরামর্শের বিকল্প নয়।';

  @override
  String get healthBloodGroup => 'রক্তের গ্রুপ';

  @override
  String get healthLatestGrowth => 'সর্বশেষ বৃদ্ধি';

  @override
  String get healthCurrentMedicine => 'চলতি ওষুধ';

  @override
  String get healthRecentIllness => 'সাম্প্রতিক অসুস্থতা';

  @override
  String get healthVaccination => 'টিকা';

  @override
  String get healthLastDoctorVisit => 'শেষ ডাক্তার দেখা';

  @override
  String get healthUpcoming => 'আসন্ন';

  @override
  String get healthGridVaccinations => 'টিকা';

  @override
  String get healthGridIllness => 'অসুস্থতার ইতিহাস';

  @override
  String get healthGridMedicines => 'ওষুধ';

  @override
  String get healthGridDoctorVisits => 'ডাক্তার দেখা';

  @override
  String get healthGridDocuments => 'নথি';

  @override
  String get healthEmpty => 'এখনো কোনো স্বাস্থ্য রেকর্ড নেই। প্রথমটি যোগ করুন।';

  @override
  String get healthAdd => 'যোগ করুন';

  @override
  String get commonNone => 'নেই';

  @override
  String get commonNotes => 'নোট';

  @override
  String get vaccinationTitle => 'টিকা';

  @override
  String get vaccinationsEmpty => 'এখনো কোনো টিকা নেই।';

  @override
  String get addVaccination => 'টিকা যোগ করুন';

  @override
  String get editVaccination => 'টিকা সম্পাদনা';

  @override
  String get vaccineName => 'টিকার নাম';

  @override
  String get vaccineNameRequired => 'টিকার নাম আবশ্যক।';

  @override
  String get vaccineDose => 'ডোজ';

  @override
  String get vaccineScheduledDate => 'নির্ধারিত তারিখ';

  @override
  String get vaccineGivenDate => 'দেওয়ার তারিখ';

  @override
  String get vaccineProvider => 'প্রদানকারী';

  @override
  String get vaccineClinic => 'ক্লিনিক';

  @override
  String get vaccineBatch => 'ব্যাচ নম্বর';

  @override
  String get vaccineStatus => 'অবস্থা';

  @override
  String get vaccineStatusUpcoming => 'আসন্ন';

  @override
  String get vaccineStatusCompleted => 'সম্পন্ন';

  @override
  String get vaccineStatusDelayed => 'বিলম্বিত';

  @override
  String get vaccineStatusSkipped => 'বাদ';

  @override
  String get vaccineStatusUnknown => 'অজানা';

  @override
  String get saveVaccination => 'টিকা সংরক্ষণ';

  @override
  String get deleteVaccinationTitle => 'এই টিকা মুছবেন?';

  @override
  String get deleteVaccinationMessage => 'এই টিকার রেকর্ড এই ডিভাইস থেকে সরবে।';

  @override
  String get vaccineAttachmentsHint => 'টিকা কার্ডের ছবি বা PDF যোগ করুন।';

  @override
  String get illnessTitle => 'অসুস্থতার ইতিহাস';

  @override
  String get illnessesEmpty => 'এখনো কোনো অসুস্থতার রেকর্ড নেই।';

  @override
  String get addIllness => 'অসুস্থতা যোগ করুন';

  @override
  String get editIllness => 'অসুস্থতা সম্পাদনা';

  @override
  String get illnessTitleField => 'শিরোনাম';

  @override
  String get illnessTitleRequired => 'অসুস্থতার শিরোনাম আবশ্যক।';

  @override
  String get illnessStartDate => 'শুরুর তারিখ';

  @override
  String get illnessEndDate => 'শেষ তারিখ';

  @override
  String get illnessOngoing => 'এখনো সুস্থ হয়নি (শেষ তারিখ নেই)';

  @override
  String get illnessClearEndDate => 'শেষ তারিখ সরান';

  @override
  String get illnessSymptoms => 'লক্ষণ';

  @override
  String get illnessTemperature => 'সর্বোচ্চ তাপমাত্রা (°C)';

  @override
  String get illnessDiagnosis => 'রোগ নির্ণয়';

  @override
  String get illnessRecoveryNote => 'সুস্থ হওয়ার নোট';

  @override
  String get illnessLinkedVisit => 'সংযুক্ত ডাক্তার দেখা';

  @override
  String get illnessNoLinkedVisit => 'নেই';

  @override
  String get saveIllness => 'অসুস্থতা সংরক্ষণ';

  @override
  String get deleteIllnessTitle => 'এই অসুস্থতা মুছবেন?';

  @override
  String get deleteIllnessMessage => 'এই অসুস্থতার রেকর্ড এই ডিভাইস থেকে সরবে।';

  @override
  String get illnessAttachmentsHint => 'এই অসুস্থতার ছবি বা নথি যোগ করুন।';

  @override
  String get symptomFever => 'জ্বর';

  @override
  String get symptomCough => 'কাশি';

  @override
  String get symptomCold => 'সর্দি';

  @override
  String get symptomVomiting => 'বমি';

  @override
  String get symptomDiarrhea => 'ডায়রিয়া';

  @override
  String get symptomRash => 'র‍্যাশ';

  @override
  String get symptomHeadache => 'মাথাব্যথা';

  @override
  String get symptomStomachPain => 'পেটব্যথা';

  @override
  String get symptomBreathing => 'শ্বাসকষ্ট';

  @override
  String get symptomAllergy => 'অ্যালার্জি';

  @override
  String get symptomInjury => 'আঘাত';

  @override
  String get symptomOther => 'অন্যান্য';

  @override
  String get medicineTitle => 'ওষুধ';

  @override
  String get medicinesEmpty => 'এখনো কোনো ওষুধ নেই।';

  @override
  String get addMedicine => 'ওষুধ যোগ করুন';

  @override
  String get editMedicine => 'ওষুধ সম্পাদনা';

  @override
  String get medicineName => 'ওষুধের নাম';

  @override
  String get medicineNameRequired => 'ওষুধের নাম আবশ্যক।';

  @override
  String get medicineStrength => 'শক্তি';

  @override
  String get medicineDose => 'ডোজ';

  @override
  String get medicineFrequency => 'পরিমাণ/সময়';

  @override
  String get medicineStartDate => 'শুরুর তারিখ';

  @override
  String get medicineEndDate => 'শেষ তারিখ';

  @override
  String get medicineReason => 'কারণ';

  @override
  String get medicinePrescriber => 'প্রেসক্রাইবার';

  @override
  String get medicineStatus => 'অবস্থা';

  @override
  String get medicineStatusActive => 'চলমান';

  @override
  String get medicineStatusCompleted => 'সম্পন্ন';

  @override
  String get medicineStatusStopped => 'বন্ধ';

  @override
  String get medicineStatusAsNeeded => 'প্রয়োজনমতো';

  @override
  String get medicineSchedule => 'সময়সূচি';

  @override
  String get medicineAddScheduleTime => 'সময় যোগ করুন';

  @override
  String get saveMedicine => 'ওষুধ সংরক্ষণ';

  @override
  String get deleteMedicineTitle => 'এই ওষুধ মুছবেন?';

  @override
  String get deleteMedicineMessage => 'এই ওষুধের রেকর্ড এই ডিভাইস থেকে সরবে।';

  @override
  String get doctorVisitTitle => 'ডাক্তার দেখা';

  @override
  String get doctorVisitsEmpty => 'এখনো কোনো ডাক্তার দেখা নেই।';

  @override
  String get addDoctorVisit => 'ডাক্তার দেখা যোগ করুন';

  @override
  String get editDoctorVisit => 'ডাক্তার দেখা সম্পাদনা';

  @override
  String get doctorName => 'ডাক্তার';

  @override
  String get doctorNameRequired => 'ডাক্তারের নাম আবশ্যক।';

  @override
  String get doctorSpecialty => 'বিশেষত্ব';

  @override
  String get doctorHospital => 'চেম্বার / হাসপাতাল';

  @override
  String get doctorReason => 'কারণ';

  @override
  String get doctorSymptoms => 'লক্ষণ';

  @override
  String get doctorDiagnosis => 'রোগ নির্ণয়';

  @override
  String get doctorTests => 'পরীক্ষা পরামর্শ';

  @override
  String get doctorFollowUp => 'ফলো-আপ তারিখ';

  @override
  String get saveDoctorVisit => 'দেখা সংরক্ষণ';

  @override
  String get deleteDoctorVisitTitle => 'এই দেখা মুছবেন?';

  @override
  String get deleteDoctorVisitMessage => 'এই ডাক্তার দেখা এই ডিভাইস থেকে সরবে।';

  @override
  String get doctorAttachmentsHint => 'প্রেসক্রিপশনের ছবি বা PDF যোগ করুন।';

  @override
  String get medicalDocsTitle => 'মেডিকেল নথি';

  @override
  String get medicalDocsEmpty => 'এখনো কোনো মেডিকেল নথি নেই।';

  @override
  String get addMedicalDocument => 'নথি যোগ করুন';

  @override
  String get editMedicalDocument => 'নথি সম্পাদনা';

  @override
  String get medicalDocType => 'নথির ধরন';

  @override
  String get medicalDocTitle => 'শিরোনাম';

  @override
  String get medicalDocTitleRequired => 'নথির শিরোনাম আবশ্যক।';

  @override
  String get medicalDocDate => 'নথির তারিখ';

  @override
  String get medicalDocNotes => 'নোট';

  @override
  String get medicalDocFileRequired => 'একটি ফাইল আবশ্যক।';

  @override
  String get medicalDocPickFile => 'ফাইল বেছে নিন';

  @override
  String get saveMedicalDocument => 'নথি সংরক্ষণ';

  @override
  String get deleteMedicalDocumentTitle => 'এই নথি মুছবেন?';

  @override
  String get deleteMedicalDocumentMessage =>
      'এই মেডিকেল নথি এই ডিভাইস থেকে সরবে।';

  @override
  String get docTypePrescription => 'প্রেসক্রিপশন';

  @override
  String get docTypeDiagnostic => 'ডায়াগনস্টিক রিপোর্ট';

  @override
  String get docTypeVaccinationCard => 'টিকা কার্ড';

  @override
  String get docTypeDischarge => 'ডিসচার্জ সামারি';

  @override
  String get docTypeCertificate => 'মেডিকেল সনদ';

  @override
  String get docTypeOther => 'অন্যান্য';

  @override
  String get timelineEmpty => 'এখনো কোনো সময়রেখার এন্ট্রি নেই।';

  @override
  String get timelineFilterAll => 'সব';

  @override
  String get timelineFilterMemories => 'স্মৃতি';

  @override
  String get timelineFilterGrowth => 'বৃদ্ধি';

  @override
  String get timelineFilterMilestones => 'মাইলফলক';

  @override
  String get timelineFilterHealth => 'স্বাস্থ্য';

  @override
  String get timelineFilterSchool => 'স্কুল';

  @override
  String get timelineFilterAchievements => 'অর্জন';

  @override
  String get timelineFilterPhotos => 'ছবি';

  @override
  String get timelineFilterFunny => 'মজার';

  @override
  String get timelineTypeJournal => 'স্মৃতি';

  @override
  String get timelineTypeFunny => 'মজার মুহূর্ত';

  @override
  String get timelineTypeAchievement => 'অর্জন';

  @override
  String get timelineTypeGrowth => 'বৃদ্ধি';

  @override
  String get timelineTypeMilestone => 'মাইলফলক';

  @override
  String get timelineTypeSchool => 'স্কুল';

  @override
  String get timelineTypeVaccination => 'টিকা';

  @override
  String get timelineTypeIllness => 'অসুস্থতা';

  @override
  String get timelineTypeDoctor => 'ডাক্তার দেখা';

  @override
  String get timelineTypeBirthday => 'জন্মদিন';

  @override
  String get calendarTitle => 'ক্যালেন্ডার';

  @override
  String get calendarNoEvents => 'এই দিনে কোনো ইভেন্ট নেই।';

  @override
  String get remindersTitle => 'রিমাইন্ডার';

  @override
  String get remindersEmpty => 'এখনো কোনো রিমাইন্ডার নেই।';

  @override
  String get addReminder => 'রিমাইন্ডার যোগ করুন';

  @override
  String get editReminder => 'রিমাইন্ডার সম্পাদনা';

  @override
  String get reminderTitleField => 'শিরোনাম';

  @override
  String get reminderTitleRequired => 'শিরোনাম আবশ্যক।';

  @override
  String get reminderType => 'ধরন';

  @override
  String get reminderDateTime => 'তারিখ ও সময়';

  @override
  String get reminderRepeat => 'পুনরাবৃত্তি';

  @override
  String get reminderEnabled => 'বিজ্ঞপ্তি চালু';

  @override
  String get reminderNotes => 'নোট';

  @override
  String get saveReminder => 'রিমাইন্ডার সংরক্ষণ';

  @override
  String get deleteReminderTitle => 'এই রিমাইন্ডার মুছবেন?';

  @override
  String get deleteReminderMessage => 'এই রিমাইন্ডার এই ডিভাইস থেকে সরবে।';

  @override
  String get reminderTypeVaccination => 'টিকা';

  @override
  String get reminderTypeMedicine => 'ওষুধ';

  @override
  String get reminderTypeDoctorFollowUp => 'ডাক্তার ফলো-আপ';

  @override
  String get reminderTypeBirthday => 'জন্মদিন';

  @override
  String get reminderTypeWeeklyMemory => 'সাপ্তাহিক স্মৃতি';

  @override
  String get reminderTypeBackup => 'ব্যাকআপ';

  @override
  String get reminderTypeCustom => 'কাস্টম';

  @override
  String get reminderRepeatNone => 'পুনরাবৃত্তি নেই';

  @override
  String get reminderRepeatDaily => 'প্রতিদিন';

  @override
  String get reminderRepeatWeekly => 'সাপ্তাহিক';

  @override
  String get reminderRepeatYearly => 'বার্ষিক';

  @override
  String get reminderRepeatMonthly => 'মাসিক';

  @override
  String get onThisDayTitle => 'আজকের দিনে';

  @override
  String get onThisDayEmpty => 'আগের বছরগুলোর এই দিনে এখনো কিছু নেই।';

  @override
  String onThisDayYearsAgo(int years) {
    return '$years বছর আগে';
  }

  @override
  String get upcomingReminders => 'আসন্ন রিমাইন্ডার';

  @override
  String get notificationPermissionTitle => 'রিমাইন্ডার চালু করবেন?';

  @override
  String get notificationPermissionBody =>
      'শিশুর দিনলিপি টিকা, ওষুধ, ফলো-আপ ও গুরুত্বপূর্ণ স্মৃতির কথা মনে করিয়ে দিতে পারে।';

  @override
  String get notificationAllow => 'বিজ্ঞপ্তি অনুমতি দিন';

  @override
  String get notificationNotNow => 'এখন নয়';

  @override
  String get searchTitle => 'খোঁজ';

  @override
  String get searchHint => 'স্মৃতি, স্বাস্থ্য, স্কুল খুঁজুন…';

  @override
  String get searchEmpty => 'কোনো মিল পাওয়া যায়নি।';

  @override
  String get searchRecent => 'সাম্প্রতিক খোঁজ';

  @override
  String get searchFilterAll => 'সব';

  @override
  String get searchTypeJournal => 'স্মৃতি';

  @override
  String get searchTypeMilestone => 'মাইলফলক';

  @override
  String get searchTypeMedicine => 'ওষুধ';

  @override
  String get searchTypeDoctor => 'ডাক্তার';

  @override
  String get searchTypeIllness => 'অসুস্থতা';

  @override
  String get searchTypeSchool => 'স্কুল';

  @override
  String get searchTypeAchievement => 'অর্জন';

  @override
  String get searchFromDate => 'শুরু';

  @override
  String get searchToDate => 'শেষ';

  @override
  String get searchClearDates => 'তারিখ সরান';

  @override
  String get searchFilterAllTags => 'সব ট্যাগ';

  @override
  String get photosTitle => 'ছবি';

  @override
  String get photosEmpty => 'এখনো কোনো ছবি নেই।';

  @override
  String get photosFavorites => 'পছন্দ';

  @override
  String get photosByYear => 'বছর অনুযায়ী';

  @override
  String get photosByAge => 'বয়স অনুযায়ী';

  @override
  String get photosByCategory => 'বিভাগ অনুযায়ী';

  @override
  String get photosAll => 'সব';

  @override
  String get photoMissing => 'এই ছবি বা ফাইল আর পাওয়া যাচ্ছে না।';

  @override
  String get photoFavorite => 'পছন্দে যোগ';

  @override
  String get photoUnfavorite => 'পছন্দ থেকে সরান';

  @override
  String get albumsEmpty =>
      'এখনো কোনো অ্যালবাম নেই। একটি কাস্টম অ্যালবাম তৈরি করুন।';

  @override
  String get addAlbum => 'অ্যালবাম তৈরি';

  @override
  String get editAlbum => 'অ্যালবাম সম্পাদনা';

  @override
  String get albumTitleField => 'অ্যালবামের শিরোনাম';

  @override
  String get albumTitleRequired => 'অ্যালবামের শিরোনাম আবশ্যক।';

  @override
  String get albumTheme => 'থিম';

  @override
  String get albumCover => 'কভার ছবি';

  @override
  String get albumAddPhotos => 'ছবি যোগ করুন';

  @override
  String get albumNoItems => 'এই অ্যালবামে এখনো কিছু নেই।';

  @override
  String get saveAlbum => 'অ্যালবাম সংরক্ষণ';

  @override
  String get deleteAlbumTitle => 'এই অ্যালবাম মুছবেন?';

  @override
  String get deleteAlbumMessage => 'এই অ্যালবাম এই ডিভাইস থেকে সরবে।';

  @override
  String get albumThemeMinimal => 'মিনিমাল';

  @override
  String get albumThemePlayful => 'খেলাধুলা';

  @override
  String get albumThemeColorful => 'রঙিন';

  @override
  String get albumThemeElegant => 'এলিগ্যান্ট';

  @override
  String get tagsTitle => 'ট্যাগ';

  @override
  String get tagsAddHint => 'ট্যাগ যোগ করুন';

  @override
  String get tagsEmpty => 'এখনো কোনো ট্যাগ নেই।';

  @override
  String get yearReviewTitle => 'বছরের স্মৃতিচারণ';

  @override
  String get yearReviewSubtitle =>
      'বছরের স্মৃতির অ্যালবাম তৈরি করুন — সম্পূর্ণ অফলাইনে।';

  @override
  String get yearReviewPickYear => 'বছর বেছে নিন';

  @override
  String get yearReviewEmptyYears =>
      'বছরের স্মৃতিচারণ শুরু করতে শিশুর প্রোফাইল যোগ করুন।';

  @override
  String yearReviewOpenYear(String name, int year) {
    return '$name-এর $year সালের স্মৃতিচারণ খুলুন';
  }

  @override
  String get yearReviewEditorTitle => 'স্মৃতিচারণ সম্পাদনা';

  @override
  String get yearReviewTheme => 'থিম';

  @override
  String get yearReviewLanguage => 'পিডিএফের ভাষা';

  @override
  String get yearReviewIncludeHealth => 'স্বাস্থ্যের হাইলাইট অন্তর্ভুক্ত করুন';

  @override
  String get yearReviewParentLetter => 'বাবা-মার চিঠি';

  @override
  String get yearReviewParentLetterHint => 'আপনার শিশুকে একটি ছোট চিঠি লিখুন…';

  @override
  String get yearReviewCover => 'কভার ছবি';

  @override
  String get yearReviewNoCover => 'কভার নেই';

  @override
  String get yearReviewNoCoverPhotos =>
      'এই বছর কভার হিসেবে ব্যবহারের মতো কোনো ছবি নেই।';

  @override
  String get yearReviewEditCaption => 'ক্যাপশন সম্পাদনা';

  @override
  String get yearReviewGenerate => 'পিডিএফ তৈরি করুন';

  @override
  String get yearReviewSaved => 'পছন্দসমূহ সংরক্ষিত।';

  @override
  String get yearReviewGeneratingTitle => 'আপনার অ্যালবাম তৈরি হচ্ছে';

  @override
  String get yearReviewStagePreparing => 'স্মৃতি প্রস্তুত করা হচ্ছে…';

  @override
  String get yearReviewStagePhotos => 'ছবি প্রক্রিয়াকরণ…';

  @override
  String get yearReviewStageBuilding => 'পৃষ্ঠা তৈরি হচ্ছে…';

  @override
  String get yearReviewStageSaving => 'পিডিএফ সংরক্ষণ…';

  @override
  String get yearReviewStageComplete => 'সম্পন্ন';

  @override
  String get yearReviewStageFailed => 'পিডিএফ তৈরি করা যায়নি';

  @override
  String get yearReviewPdfReady => 'আপনার বছরের স্মৃতিচারণ পিডিএফ তৈরি।';

  @override
  String get yearReviewPreview => 'প্রিভিউ';

  @override
  String get yearReviewShare => 'শেয়ার';

  @override
  String get yearReviewPrint => 'প্রিন্ট';

  @override
  String get yearReviewSavedToExports =>
      'এই ডিভাইসের এক্সপোর্ট ফোল্ডারে সংরক্ষিত।';

  @override
  String get yearReviewSectionGrowth => 'বৃদ্ধি';

  @override
  String get yearReviewSectionMilestones => 'মাইলস্টোন';

  @override
  String get yearReviewSectionSchool => 'স্কুল';

  @override
  String get yearReviewSectionAchievements => 'অর্জন';

  @override
  String get yearReviewSectionFunny => 'মজার মুহূর্ত';

  @override
  String get yearReviewSectionPhotos => 'ছবি';

  @override
  String get yearReviewSectionBirthday => 'জন্মদিন';

  @override
  String get yearReviewSectionJournals => 'স্মৃতির হাইলাইট';

  @override
  String get yearReviewSectionHealth => 'স্বাস্থ্য';

  @override
  String get unlockTitle => 'জার্নাল আনলক';

  @override
  String get unlockSubtitle => 'ব্যক্তিগত স্মৃতি খুলতে আপনার পিন দিন।';

  @override
  String get unlockPinLabel => 'পিন';

  @override
  String get unlockCta => 'আনলক';

  @override
  String get unlockBiometric => 'বায়োমেট্রিক্স ব্যবহার করুন';

  @override
  String get unlockPinWrong => 'পিন ভুল।';

  @override
  String get securitySettingsTitle => 'গোপনীয়তা ও নিরাপত্তা';

  @override
  String get securityAppLock => 'অ্যাপ লক';

  @override
  String get securityConfirmPin => 'পিন নিশ্চিত করুন';

  @override
  String get securityCurrentPin => 'বর্তমান পিন';

  @override
  String get securityNewPin => 'নতুন পিন';

  @override
  String get securityChangePin => 'পিন পরিবর্তন';

  @override
  String get securityRemovePin => 'পিন সরান';

  @override
  String get securityPinMismatch => 'পিন মিলছে না।';

  @override
  String get securityPinSet => 'পিন সেট হয়েছে।';

  @override
  String get securityPinChanged => 'পিন আপডেট হয়েছে।';

  @override
  String get securityPinRemoved => 'পিন সরানো হয়েছে।';

  @override
  String get securityDisableBiometrics => 'বায়োমেট্রিক্স বন্ধ করুন';

  @override
  String get securityBiometricsHint =>
      'Face ID বা ফিংগারপ্রিন্ট দিয়ে আনলক। ব্যর্থ হলে পিন ব্যবহার হবে।';

  @override
  String get securityAutoLock => 'অটো-লক';

  @override
  String get securityAutoLockImmediate => 'তৎক্ষণাৎ';

  @override
  String get securityAutoLock1m => '১ মিনিট পর';

  @override
  String get securityAutoLock5m => '৫ মিনিট পর';

  @override
  String get securityAutoLock15m => '১৫ মিনিট পর';

  @override
  String get securityLockNow => 'এখনই লক করুন';

  @override
  String get securityEncryptionTitle => 'স্থানীয় এনক্রিপশন';

  @override
  String get securityEncryptionBody =>
      'আপনার ডাটাবেস এই ডিভাইসে এনক্রিপ্ট করা থাকে। এনক্রিপশন কী সিস্টেম কিচেইনে থাকে এবং ফোন ছাড়ে না।';

  @override
  String get backupTitle => 'ব্যাকআপ ও রিস্টোর';

  @override
  String get backupSubtitle =>
      'জার্নাল, ছবি ও স্বাস্থ্য রেকর্ডের এনক্রিপ্টেড অফলাইন ব্যাকআপ তৈরি করুন।';

  @override
  String get backupPassword => 'ব্যাকআপ পাসওয়ার্ড';

  @override
  String get backupPasswordConfirm => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get backupCreate => 'ব্যাকআপ তৈরি';

  @override
  String get backupCreated => 'ব্যাকআপ তৈরি হয়েছে।';

  @override
  String get backupRestoreCta => 'রিস্টোর';

  @override
  String get backupHistory => 'স্থানীয় ব্যাকআপ';

  @override
  String get backupHistoryEmpty => 'এখনো কোনো স্থানীয় ব্যাকআপ নেই।';

  @override
  String get backupStagePreparing => 'প্রস্তুত হচ্ছে…';

  @override
  String get backupStageDatabase => 'ডাটাবেস স্ন্যাপশট…';

  @override
  String get backupStageMedia => 'ছবি ও নথি সংগ্রহ…';

  @override
  String get backupStageArchive => 'আর্কাইভ তৈরি…';

  @override
  String get backupStageEncrypting => 'এনক্রিপ্ট হচ্ছে…';

  @override
  String get backupStageSaving => 'সংরক্ষণ…';

  @override
  String get backupStageComplete => 'সম্পন্ন';

  @override
  String get backupStageFailed => 'ব্যাকআপ ব্যর্থ';

  @override
  String get cloudBackupTitle => 'ক্লাউড ব্যাকআপ';

  @override
  String get cloudBackupSubtitle =>
      'ঐচ্ছিক। ইতিমধ্যে এনক্রিপ্ট করা ব্যাকআপ আপনার নিজের ক্লাউড অ্যাকাউন্টে তুলুন। অ্যাপের জন্য ক্লাউড বাধ্যতামূলক নয়।';

  @override
  String get cloudBackupConnect => 'সংযুক্ত করুন';

  @override
  String get cloudBackupDisconnect => 'সংযোগ ছাড়ুন';

  @override
  String get cloudBackupConnected => 'সংযুক্ত';

  @override
  String get cloudBackupNotConfigured => 'এই বিল্ডে কনফিগার করা নেই';

  @override
  String get cloudBackupUnsupported => 'এখনো উপলব্ধ নয়';

  @override
  String get cloudBackupUploadLatest => 'সর্বশেষ স্থানীয় ব্যাকআপ আপলোড';

  @override
  String get cloudBackupUploaded => 'ক্লাউডে আপলোড হয়েছে।';

  @override
  String get cloudBackupRemoteEmpty => 'এখনো কোনো রিমোট ব্যাকআপ নেই।';

  @override
  String get cloudBackupRefresh => 'রিফ্রেশ';

  @override
  String get cloudBackupDownload => 'ডাউনলোড';

  @override
  String get cloudBackupDelete => 'মুছুন';

  @override
  String get cloudBackupDeleted => 'রিমোট ব্যাকআপ মুছে ফেলা হয়েছে।';

  @override
  String get cloudBackupDownloaded =>
      'ডাউনলোড হয়েছে। রিস্টোর স্ক্রিন থেকে পুনরুদ্ধার করতে পারবেন।';

  @override
  String get cloudProviderGoogleDrive => 'গুগল ড্রাইভ';

  @override
  String get cloudProviderOneDrive => 'ওয়ানড্রাইভ';

  @override
  String get cloudProviderDropbox => 'ড্রপবক্স';

  @override
  String get cloudProviderICloud => 'আইক্লাউড';

  @override
  String get cloudProviderLocal => 'এই ডিভাইস';

  @override
  String get restoreTitle => 'ব্যাকআপ রিস্টোর';

  @override
  String get restoreSubtitle =>
      'একটি এনক্রিপ্টেড .sdjbackup ফাইল বেছে নিন। বর্তমান ডেটার সেফটি ব্যাকআপ আগে নেওয়া যায়।';

  @override
  String get restorePick => 'ব্যাকআপ ফাইল বেছে নিন';

  @override
  String get restoreValidate => 'ব্যাকআপ যাচাই';

  @override
  String get restorePreviewTitle => 'ব্যাকআপ সারাংশ';

  @override
  String restorePreviewChildren(int count) {
    return '$count জন শিশু';
  }

  @override
  String restorePreviewAssets(int count) {
    return '$countটি মিডিয়া ফাইল';
  }

  @override
  String restorePreviewSchema(int version) {
    return 'স্কিমা সংস্করণ $version';
  }

  @override
  String restorePreviewApp(String version) {
    return 'অ্যাপ $version';
  }

  @override
  String get restoreSafetyPassword => 'সেফটি ব্যাকআপ পাসওয়ার্ড (ঐচ্ছিক)';

  @override
  String get restoreSafetyPasswordHint =>
      'ওভাররাইটের আগে বর্তমান ডেটার ব্যাকআপ তৈরি করে।';

  @override
  String get restoreConfirmTitle => 'সব ডেটা প্রতিস্থাপন করবেন?';

  @override
  String get restoreConfirmBody =>
      'এই ডিভাইসের জার্নাল, ছবি ও সেটিংস ব্যাকআপ দিয়ে প্রতিস্থাপিত হবে।';

  @override
  String get restoreConfirmCta => 'রিস্টোর';

  @override
  String get restoreCommit => 'এখনই রিস্টোর';

  @override
  String get restoreRestartRequired =>
      'রিস্টোর সম্পন্ন। অ্যাপ সম্পূর্ণ বন্ধ করে আবার খুলুন।';

  @override
  String get restoreStageReading => 'ব্যাকআপ পড়া হচ্ছে…';

  @override
  String get restoreStageDecrypting => 'ডিক্রিপ্ট হচ্ছে…';

  @override
  String get restoreStageValidating => 'অখণ্ডতা যাচাই…';

  @override
  String get restoreStagePreview => 'প্রিভিউ প্রস্তুত';

  @override
  String get restoreStageSafety => 'সেফটি ব্যাকআপ…';

  @override
  String get restoreStageRestoring => 'ফাইল রিস্টোর…';

  @override
  String get restoreStageMigrating => 'মাইগ্রেশন চলছে…';

  @override
  String get restoreStageRebuilding => 'রিমাইন্ডার পুনর্নির্মাণ…';

  @override
  String get restoreStageComplete => 'সম্পন্ন';

  @override
  String get restoreStageFailed => 'রিস্টোর ব্যর্থ';

  @override
  String get stateLoading => 'লোড হচ্ছে…';

  @override
  String get stateSaveProgress => 'সংরক্ষণ হচ্ছে…';

  @override
  String get stateSaveSuccess => 'সংরক্ষিত।';

  @override
  String get stateSaveFailure => 'সংরক্ষণ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get stateNoSearchResults => 'কোনো মিল পাওয়া যায়নি।';

  @override
  String get statePermissionDenied => 'এগিয়ে যেতে অনুমতি প্রয়োজন।';

  @override
  String get stateNotificationDenied =>
      'নোটিফিকেশন বন্ধ আছে। সিস্টেম সেটিংস থেকে চালু করতে পারেন।';

  @override
  String get stateMigration => 'আপনার জার্নাল আপডেট হচ্ছে…';

  @override
  String get stateStorageAlmostFull =>
      'স্টোরেজ প্রায় ভরে গেছে। জায়গা খালি করুন বা এক্সপোর্ট মুছুন।';

  @override
  String get storageTitle => 'স্টোরেজ';

  @override
  String storageTotal(String size) {
    return 'ব্যবহার $size';
  }

  @override
  String get storageAlmostFull => 'এই ডিভাইসের স্টোরেজ প্রায় ভরে যাচ্ছে।';

  @override
  String storageFileCount(int count) {
    return '$countটি ফাইল';
  }

  @override
  String get storageOrphans => 'অরফান মিডিয়া';

  @override
  String storageOrphanCount(int count) {
    return '$countটি আইটেম দেখা দরকার';
  }

  @override
  String get storageExports => 'তৈরি পিডিএফ';

  @override
  String storageExportCount(int count) {
    return '$countটি এক্সপোর্ট রাখা আছে';
  }

  @override
  String get storageCleanupTemp => 'সাময়িক ফাইল পরিষ্কার';

  @override
  String get storageCleanupExports => 'পুরনো পিডিএফ এক্সপোর্ট মুছুন';

  @override
  String get storageCleanupOrphans => 'অরফান মিডিয়া মুছুন';

  @override
  String get storageTempCleaned => 'সাময়িক ফাইল পরিষ্কার হয়েছে।';

  @override
  String storageExportsCleaned(int count) {
    return '$countটি পুরনো এক্সপোর্ট সরানো হয়েছে।';
  }

  @override
  String storageOrphansCleaned(int count) {
    return '$countটি অরফান মিডিয়া সরানো হয়েছে।';
  }

  @override
  String get storageCatDatabase => 'ডাটাবেস';

  @override
  String get storageCatImages => 'ছবি';

  @override
  String get storageCatThumbnails => 'থাম্বনেইল';

  @override
  String get storageCatDocuments => 'নথি';

  @override
  String get storageCatPdf => 'পিডিএফ এক্সপোর্ট';

  @override
  String get storageCatAlbumImages => 'অ্যালবাম ছবি';

  @override
  String get storageCatBackups => 'ব্যাকআপ';

  @override
  String get storageCatTemp => 'সাময়িক';

  @override
  String get birthdaysTitle => 'জন্মদিন';

  @override
  String get birthdayDetailTitle => 'জন্মদিন';

  @override
  String get addBirthday => 'জন্মদিন যোগ করুন';

  @override
  String get editBirthday => 'জন্মদিন সম্পাদনা';

  @override
  String get birthdayAge => 'বয়স';

  @override
  String get birthdayDate => 'জন্মদিনের তারিখ';

  @override
  String get birthdayLocation => 'স্থান';

  @override
  String get birthdayTheme => 'থিম';

  @override
  String get birthdayFavoriteGift => 'প্রিয় উপহার';

  @override
  String get birthdayGuests => 'অতিথি';

  @override
  String get birthdayParentMessage => 'বাবা-মার বার্তা';

  @override
  String get birthdayNotes => 'নোট';

  @override
  String get birthdayInterview => 'বার্ষিক সাক্ষাৎকার';

  @override
  String get birthdayInterviewTitle => 'জন্মদিনের সাক্ষাৎকার';

  @override
  String get birthdayCompareTitle => 'বয়স অনুযায়ী তুলনা';

  @override
  String get birthdayAlbumCreate => 'জন্মদিনের অ্যালবাম তৈরি';

  @override
  String get birthdayAlbumReady => 'জন্মদিনের অ্যালবাম প্রস্তুত।';

  @override
  String get birthdayPdfGenerate => 'জন্মদিনের পিডিএফ তৈরি';

  @override
  String get birthdayPdfReady => 'জন্মদিনের পিডিএফ প্রস্তুত।';

  @override
  String get birthdayEmpty => 'এখনো কোনো জন্মদিনের স্মৃতি নেই।';

  @override
  String get birthdayEmptyHint =>
      'প্রতি বছরের উৎসব ও সাক্ষাৎকারের উত্তর সংরক্ষণ করুন।';

  @override
  String get birthdayQFavoriteFood => 'প্রিয় খাবার?';

  @override
  String get birthdayQFavoriteColor => 'প্রিয় রং?';

  @override
  String get birthdayQFavoriteCartoon => 'প্রিয় কার্টুন?';

  @override
  String get birthdayQFavoriteBook => 'প্রিয় বই?';

  @override
  String get birthdayQFavoriteGame => 'প্রিয় খেলা?';

  @override
  String get birthdayQFavoriteFriend => 'প্রিয় বন্ধু?';

  @override
  String get birthdayQWantToBe => 'বড় হয়ে কী হতে চাও?';

  @override
  String get birthdayQMakesHappy => 'কী তোমাকে খুশি করে?';

  @override
  String get favoritesTitle => 'প্রিয় বিষয়';

  @override
  String get addFavorite => 'প্রিয় যোগ করুন';

  @override
  String get editFavorite => 'প্রিয় সম্পাদনা';

  @override
  String get favoriteCategory => 'ক্যাটাগরি';

  @override
  String get favoriteValue => 'মান';

  @override
  String get favoriteStartDate => 'শুরুর তারিখ';

  @override
  String get favoriteEndDate => 'শেষ তারিখ (ঐচ্ছিক)';

  @override
  String get favoriteNotes => 'নোট';

  @override
  String get favoriteEmpty => 'এখনো কোনো প্রিয় নেই।';

  @override
  String get favoriteEmptyHint =>
      'খাবার, রং, বইসহ প্রিয় বিষয়গুলো বছর ধরে রাখুন।';

  @override
  String get favoriteCurrent => 'বর্তমান';

  @override
  String get favoriteHistory => 'ইতিহাস';

  @override
  String get favoriteCatFood => 'খাবার';

  @override
  String get favoriteCatColor => 'রং';

  @override
  String get favoriteCatCartoon => 'কার্টুন';

  @override
  String get favoriteCatBook => 'বই';

  @override
  String get favoriteCatGame => 'খেলা';

  @override
  String get favoriteCatFriend => 'বন্ধু';

  @override
  String get searchTypeBirthday => 'জন্মদিন';

  @override
  String get searchTypeFavorite => 'প্রিয়';

  @override
  String get addGroupMemoriesExtra => 'জন্মদিন ও প্রিয়';

  @override
  String get addBirthdaySubtitle => 'পার্টি, উপহার ও বার্ষিক সাক্ষাৎকার';

  @override
  String get addFavoriteSubtitle => 'খাবার, রং, কার্টুন, বই, খেলা, বন্ধু';

  @override
  String get interestsTitle => 'আগ্রহ';

  @override
  String get addInterest => 'আগ্রহ যোগ করুন';

  @override
  String get editInterest => 'আগ্রহ সম্পাদনা';

  @override
  String get interestName => 'আগ্রহ';

  @override
  String get interestFirstNoticed => 'প্রথম লক্ষ করা';

  @override
  String get interestLevel => 'আগ্রহের মাত্রা';

  @override
  String get interestNotes => 'নোট';

  @override
  String get interestEmpty => 'এখনো কোনো আগ্রহ নেই।';

  @override
  String get interestEmptyHint =>
      'আঁকা, খেলা, সঙ্গীতসহ বেড়ে ওঠার আগ্রহগুলো রাখুন।';

  @override
  String interestLevelLabel(int level) {
    return 'মাত্রা $level';
  }

  @override
  String get familyEventsTitle => 'পারিবারিক অনুষ্ঠান';

  @override
  String get addFamilyEvent => 'পারিবারিক অনুষ্ঠান যোগ';

  @override
  String get editFamilyEvent => 'অনুষ্ঠান সম্পাদনা';

  @override
  String get familyEventType => 'ধরন';

  @override
  String get familyEventTitle => 'শিরোনাম';

  @override
  String get familyEventDate => 'তারিখ';

  @override
  String get familyEventLocation => 'স্থান';

  @override
  String get familyEventStory => 'গল্প';

  @override
  String get familyEventReaction => 'শিশুর প্রতিক্রিয়া';

  @override
  String get familyEventEmpty => 'এখনো কোনো পারিবারিক অনুষ্ঠান নেই।';

  @override
  String get familyEventEmptyHint =>
      'ঈদ, বিয়ে, সফর ও বিশেষ মুহূর্ত সংরক্ষণ করুন।';

  @override
  String get familyEventAlbumCreate => 'অনুষ্ঠানের অ্যালবাম তৈরি';

  @override
  String get familyEventAlbumReady => 'পারিবারিক অ্যালবাম প্রস্তুত।';

  @override
  String get familyEventTypeEid => 'ঈদ';

  @override
  String get familyEventTypeWedding => 'বিয়ে';

  @override
  String get familyEventTypeVacation => 'পারিবারিক ছুটি';

  @override
  String get familyEventTypeGrandparent => 'দাদা-দাদি/নানা-নানির সফর';

  @override
  String get familyEventTypeSibling => 'নতুন ভাইবোন';

  @override
  String get familyEventTypeMoving => 'ঘর বদল';

  @override
  String get familyEventTypeFirstFlight => 'প্রথম বিমানযাত্রা';

  @override
  String get familyEventTypeFirstBeach => 'প্রথম সমুদ্রসৈকত';

  @override
  String get familyEventTypeGathering => 'মিলনমেলা';

  @override
  String get familyEventTypeOther => 'অন্যান্য';

  @override
  String get tripsTitle => 'ভ্রমণ ও স্থান';

  @override
  String get addTrip => 'ভ্রমণ যোগ করুন';

  @override
  String get editTrip => 'ভ্রমণ সম্পাদনা';

  @override
  String get tripType => 'ভ্রমণের ধরন';

  @override
  String get tripTitle => 'শিরোনাম';

  @override
  String get tripPlace => 'স্থান';

  @override
  String get tripStartDate => 'শুরুর তারিখ';

  @override
  String get tripEndDate => 'শেষ তারিখ (ঐচ্ছিক)';

  @override
  String get tripStory => 'গল্প';

  @override
  String get tripReaction => 'শিশুর প্রতিক্রিয়া';

  @override
  String get tripEmpty => 'এখনো কোনো ভ্রমণ নেই।';

  @override
  String get tripEmptyHint =>
      'ছুটি, প্রথম ফ্লাইট, সৈকত ও ঘুরে দেখা স্থানগুলো রাখুন।';

  @override
  String get tripAlbumCreate => 'ভ্রমণের অ্যালবাম তৈরি';

  @override
  String get tripAlbumReady => 'ভ্রমণ অ্যালবাম প্রস্তুত।';

  @override
  String get tripTypeVacation => 'ছুটির ভ্রমণ';

  @override
  String get tripTypeFirstFlight => 'প্রথম বিমানযাত্রা';

  @override
  String get tripTypeFirstBeach => 'প্রথম সৈকত';

  @override
  String get tripTypePlaceVisit => 'স্থান পরিদর্শন';

  @override
  String get tripTypeOther => 'অন্যান্য';

  @override
  String get timelineTypeFamilyEvent => 'পারিবারিক অনুষ্ঠান';

  @override
  String get timelineTypeTrip => 'ভ্রমণ';

  @override
  String get searchTypeInterest => 'আগ্রহ';

  @override
  String get searchTypeFamilyEvent => 'পারিবারিক অনুষ্ঠান';

  @override
  String get searchTypeTrip => 'ভ্রমণ';

  @override
  String get homeInterests => 'বেড়ে ওঠা আগ্রহ';

  @override
  String get homeFamilyEvents => 'পারিবারিক মুহূর্ত';

  @override
  String get homeTrips => 'ভ্রমণ ও স্থান';

  @override
  String get addInterestSubtitle => 'শখ ও আগ্রহ';

  @override
  String get addFamilyEventSubtitle => 'ঈদ, বিয়ে, সফর, প্রথমবার';

  @override
  String get addTripSubtitle => 'ভ্রমণ, স্থান, সৈকত, ফ্লাইট';
}
