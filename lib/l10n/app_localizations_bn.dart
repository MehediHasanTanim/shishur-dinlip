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
}
