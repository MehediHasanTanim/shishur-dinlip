import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Shishur Dinlipi'**
  String get appName;

  /// No description provided for @appNameBn.
  ///
  /// In en, this message translates to:
  /// **'শিশুর দিনলিপি'**
  String get appNameBn;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s story, preserved with care.'**
  String get tagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navTimeline;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// No description provided for @navAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get navAlbums;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Shishur Dinlipi'**
  String get splashTitle;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing your journal…'**
  String get splashLoading;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve the little moments that become big memories.'**
  String get onboardingTitle;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguageTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s memories stay with you'**
  String get privacyTitle;

  /// No description provided for @privacyPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private by default — stored securely on your device.'**
  String get privacyPrivate;

  /// No description provided for @privacyOffline.
  ///
  /// In en, this message translates to:
  /// **'Works offline — no internet required.'**
  String get privacyOffline;

  /// No description provided for @privacyControl.
  ///
  /// In en, this message translates to:
  /// **'You are in control — export, backup, or delete anytime.'**
  String get privacyControl;

  /// No description provided for @privacyContinue.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get privacyContinue;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve the little moments that become big memories.'**
  String get welcomeTitle;

  /// No description provided for @welcomeCta.
  ///
  /// In en, this message translates to:
  /// **'Create child profile'**
  String get welcomeCta;

  /// No description provided for @welcomeHighlightGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get welcomeHighlightGrowth;

  /// No description provided for @welcomeHighlightHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get welcomeHighlightHealth;

  /// No description provided for @welcomeHighlightMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get welcomeHighlightMilestones;

  /// No description provided for @welcomeHighlightPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get welcomeHighlightPhotos;

  /// No description provided for @createFirstChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first child'**
  String get createFirstChildTitle;

  /// No description provided for @createFirstChildSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add some basic information to get started.'**
  String get createFirstChildSubtitle;

  /// No description provided for @addMoreDetailsLater.
  ///
  /// In en, this message translates to:
  /// **'Add more details later'**
  String get addMoreDetailsLater;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your child\'s journal'**
  String get securityTitle;

  /// No description provided for @securitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional PIN or biometrics keep private memories private.'**
  String get securitySubtitle;

  /// No description provided for @securitySetPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get securitySetPin;

  /// No description provided for @securityBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Enable biometrics'**
  String get securityBiometrics;

  /// No description provided for @securityLater.
  ///
  /// In en, this message translates to:
  /// **'Set up later'**
  String get securityLater;

  /// No description provided for @setupCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get setupCompleteTitle;

  /// No description provided for @setupCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s journal is ready. Start capturing beautiful moments.'**
  String setupCompleteSubtitle(String name);

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @addFirstMemory.
  ///
  /// In en, this message translates to:
  /// **'Add first memory'**
  String get addFirstMemory;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s story starts here.'**
  String get homePlaceholder;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeAgeLine.
  ///
  /// In en, this message translates to:
  /// **'{name} is now {age}'**
  String homeAgeLine(String name, String age);

  /// No description provided for @growthSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Growth snapshot'**
  String get growthSnapshot;

  /// No description provided for @growthEmpty.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet. Add the first height or weight.'**
  String get growthEmpty;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick add'**
  String get quickAdd;

  /// No description provided for @quickAddMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get quickAddMemory;

  /// No description provided for @quickAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get quickAddPhoto;

  /// No description provided for @quickAddGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get quickAddGrowth;

  /// No description provided for @quickAddMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get quickAddMilestone;

  /// No description provided for @quickAddHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get quickAddHealth;

  /// No description provided for @quickAddAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get quickAddAchievement;

  /// No description provided for @recentMemories.
  ///
  /// In en, this message translates to:
  /// **'Recent memories'**
  String get recentMemories;

  /// No description provided for @recentMemoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No memories yet. Add your first memory and begin the story.'**
  String get recentMemoriesEmpty;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @upcomingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet.'**
  String get upcomingEmpty;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTitle;

  /// No description provided for @timelinePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Memories and records will appear here.'**
  String get timelinePlaceholder;

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get addTitle;

  /// No description provided for @addPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to record.'**
  String get addPlaceholder;

  /// No description provided for @albumsTitle.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albumsTitle;

  /// No description provided for @albumsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Year in Review and albums will live here.'**
  String get albumsPlaceholder;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageBangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get settingsLanguageBangla;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get commonGoBack;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get commonSkip;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorGeneric;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Could not access the journal database.'**
  String get errorDatabase;

  /// No description provided for @errorFile.
  ///
  /// In en, this message translates to:
  /// **'Could not access a file.'**
  String get errorFile;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted fields.'**
  String get errorValidation;

  /// No description provided for @errorPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission is required to continue.'**
  String get errorPermission;

  /// No description provided for @errorBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup failed.'**
  String get errorBackup;

  /// No description provided for @errorRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore failed.'**
  String get errorRestore;

  /// No description provided for @errorPdf.
  ///
  /// In en, this message translates to:
  /// **'Could not generate the PDF.'**
  String get errorPdf;

  /// No description provided for @childName.
  ///
  /// In en, this message translates to:
  /// **'Child\'s name'**
  String get childName;

  /// No description provided for @childNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get childNickname;

  /// No description provided for @childDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get childDob;

  /// No description provided for @childGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get childGender;

  /// No description provided for @childGenderBoy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get childGenderBoy;

  /// No description provided for @childGenderGirl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get childGenderGirl;

  /// No description provided for @childGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get childGenderOther;

  /// No description provided for @childBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get childBloodGroup;

  /// No description provided for @childBirthWeight.
  ///
  /// In en, this message translates to:
  /// **'Birth weight (kg)'**
  String get childBirthWeight;

  /// No description provided for @childBirthHeight.
  ///
  /// In en, this message translates to:
  /// **'Birth height (cm)'**
  String get childBirthHeight;

  /// No description provided for @childBirthplace.
  ///
  /// In en, this message translates to:
  /// **'Birthplace'**
  String get childBirthplace;

  /// No description provided for @childSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get childSchool;

  /// No description provided for @childClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get childClass;

  /// No description provided for @childNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get childNotes;

  /// No description provided for @childNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Child name is required.'**
  String get childNameRequired;

  /// No description provided for @childDobFuture.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future.'**
  String get childDobFuture;

  /// No description provided for @saveChild.
  ///
  /// In en, this message translates to:
  /// **'Save child'**
  String get saveChild;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add child'**
  String get addChild;

  /// No description provided for @addAnotherChild.
  ///
  /// In en, this message translates to:
  /// **'Add another child'**
  String get addAnotherChild;

  /// No description provided for @editChild.
  ///
  /// In en, this message translates to:
  /// **'Edit child'**
  String get editChild;

  /// No description provided for @childProfile.
  ///
  /// In en, this message translates to:
  /// **'Child profile'**
  String get childProfile;

  /// No description provided for @manageChildren.
  ///
  /// In en, this message translates to:
  /// **'Manage children'**
  String get manageChildren;

  /// No description provided for @selectChild.
  ///
  /// In en, this message translates to:
  /// **'Select a child'**
  String get selectChild;

  /// No description provided for @childrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get childrenTitle;

  /// No description provided for @noChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'No children yet'**
  String get noChildrenTitle;

  /// No description provided for @noChildrenMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a child profile to start preserving their story.'**
  String get noChildrenMessage;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @deleteChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this child?'**
  String get deleteChildTitle;

  /// No description provided for @deleteChildMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes {name}\'s journal entries from this device. Consider creating a backup first. This cannot be undone easily.'**
  String deleteChildMessage(String name);

  /// No description provided for @deleteChildConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete child'**
  String get deleteChildConfirm;

  /// No description provided for @setAsSelected.
  ///
  /// In en, this message translates to:
  /// **'Set as selected'**
  String get setAsSelected;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @replacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Replace photo'**
  String get replacePhoto;

  /// No description provided for @addPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhotoTitle;

  /// No description provided for @photoPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Photo access is needed only when you choose to add a picture.'**
  String get photoPermissionDenied;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access is needed only when you choose to take a photo.'**
  String get cameraPermissionDenied;

  /// No description provided for @basicSection.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basicSection;

  /// No description provided for @birthSection.
  ///
  /// In en, this message translates to:
  /// **'Birth'**
  String get birthSection;

  /// No description provided for @healthSection.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthSection;

  /// No description provided for @schoolSection.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolSection;

  /// No description provided for @notesSection.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesSection;

  /// No description provided for @addSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to preserve today.'**
  String get addSubtitle;

  /// No description provided for @addGroupMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get addGroupMemories;

  /// No description provided for @addGroupComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get addGroupComingSoon;

  /// No description provided for @addComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Growth, milestones, and health records arrive in later sprints.'**
  String get addComingSoonMessage;

  /// No description provided for @addMemory.
  ///
  /// In en, this message translates to:
  /// **'Add memory'**
  String get addMemory;

  /// No description provided for @editMemory.
  ///
  /// In en, this message translates to:
  /// **'Edit memory'**
  String get editMemory;

  /// No description provided for @addMemorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write a story, mood, and photos.'**
  String get addMemorySubtitle;

  /// No description provided for @addFunnyMoment.
  ///
  /// In en, this message translates to:
  /// **'Funny moment'**
  String get addFunnyMoment;

  /// No description provided for @editFunnyMoment.
  ///
  /// In en, this message translates to:
  /// **'Edit funny moment'**
  String get editFunnyMoment;

  /// No description provided for @addFunnySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture a quote or silly story.'**
  String get addFunnySubtitle;

  /// No description provided for @addAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get addAchievement;

  /// No description provided for @editAchievement.
  ///
  /// In en, this message translates to:
  /// **'Edit achievement'**
  String get editAchievement;

  /// No description provided for @addAchievementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Celebrate a proud win with photos.'**
  String get addAchievementSubtitle;

  /// No description provided for @quickTemplates.
  ///
  /// In en, this message translates to:
  /// **'Quick templates'**
  String get quickTemplates;

  /// No description provided for @templateSomethingFunny.
  ///
  /// In en, this message translates to:
  /// **'Something funny'**
  String get templateSomethingFunny;

  /// No description provided for @templateSomethingNew.
  ///
  /// In en, this message translates to:
  /// **'Something new'**
  String get templateSomethingNew;

  /// No description provided for @templateProudMoment.
  ///
  /// In en, this message translates to:
  /// **'Proud moment'**
  String get templateProudMoment;

  /// No description provided for @templateDifficultDay.
  ///
  /// In en, this message translates to:
  /// **'Difficult day'**
  String get templateDifficultDay;

  /// No description provided for @templateFavoriteMoment.
  ///
  /// In en, this message translates to:
  /// **'Favorite moment'**
  String get templateFavoriteMoment;

  /// No description provided for @templatePhotoMemory.
  ///
  /// In en, this message translates to:
  /// **'Photo memory'**
  String get templatePhotoMemory;

  /// No description provided for @memoryDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get memoryDate;

  /// No description provided for @memoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get memoryTitle;

  /// No description provided for @memoryStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get memoryStory;

  /// No description provided for @memoryStoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a title or story to save this memory.'**
  String get memoryStoryRequired;

  /// No description provided for @memoryMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get memoryMood;

  /// No description provided for @memoryLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get memoryLocation;

  /// No description provided for @memoryTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get memoryTags;

  /// No description provided for @memoryTagsHint.
  ///
  /// In en, this message translates to:
  /// **'family, park, first time'**
  String get memoryTagsHint;

  /// No description provided for @saveMemory.
  ///
  /// In en, this message translates to:
  /// **'Save memory'**
  String get saveMemory;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get moodCalm;

  /// No description provided for @moodProud.
  ///
  /// In en, this message translates to:
  /// **'Proud'**
  String get moodProud;

  /// No description provided for @moodSilly.
  ///
  /// In en, this message translates to:
  /// **'Silly'**
  String get moodSilly;

  /// No description provided for @moodTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get moodTired;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// No description provided for @moodGrateful.
  ///
  /// In en, this message translates to:
  /// **'Grateful'**
  String get moodGrateful;

  /// No description provided for @attachmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get attachmentsTitle;

  /// No description provided for @attachmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos yet.'**
  String get attachmentsEmpty;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @funnyQuote.
  ///
  /// In en, this message translates to:
  /// **'Funny quote'**
  String get funnyQuote;

  /// No description provided for @funnyContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a quote, story, or title.'**
  String get funnyContentRequired;

  /// No description provided for @peoplePresent.
  ///
  /// In en, this message translates to:
  /// **'Who was there'**
  String get peoplePresent;

  /// No description provided for @saveFunnyMoment.
  ///
  /// In en, this message translates to:
  /// **'Save funny moment'**
  String get saveFunnyMoment;

  /// No description provided for @achievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get achievementTitle;

  /// No description provided for @achievementTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Achievement title is required.'**
  String get achievementTitleRequired;

  /// No description provided for @achievementCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get achievementCategory;

  /// No description provided for @achievementDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get achievementDescription;

  /// No description provided for @achievementAttachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attach a certificate or celebration photo.'**
  String get achievementAttachmentsHint;

  /// No description provided for @saveAchievement.
  ///
  /// In en, this message translates to:
  /// **'Save achievement'**
  String get saveAchievement;

  /// No description provided for @categorySchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get categorySchool;

  /// No description provided for @categorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get categorySports;

  /// No description provided for @categoryArts.
  ///
  /// In en, this message translates to:
  /// **'Arts'**
  String get categoryArts;

  /// No description provided for @categorySocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get categorySocial;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @deleteMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this memory?'**
  String get deleteMemoryTitle;

  /// No description provided for @deleteMemoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This memory will be removed from this device.'**
  String get deleteMemoryMessage;

  /// No description provided for @deleteFunnyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this funny moment?'**
  String get deleteFunnyTitle;

  /// No description provided for @deleteFunnyMessage.
  ///
  /// In en, this message translates to:
  /// **'This funny moment will be removed from this device.'**
  String get deleteFunnyMessage;

  /// No description provided for @deleteAchievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this achievement?'**
  String get deleteAchievementTitle;

  /// No description provided for @deleteAchievementMessage.
  ///
  /// In en, this message translates to:
  /// **'This achievement will be removed from this device.'**
  String get deleteAchievementMessage;

  /// No description provided for @discardDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardDraftTitle;

  /// No description provided for @discardDraftMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. If you leave now, they will be lost.'**
  String get discardDraftMessage;

  /// No description provided for @commonKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get commonKeepEditing;

  /// No description provided for @commonDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get commonDiscard;

  /// No description provided for @kindJournal.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get kindJournal;

  /// No description provided for @kindFunny.
  ///
  /// In en, this message translates to:
  /// **'Funny'**
  String get kindFunny;

  /// No description provided for @kindAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get kindAchievement;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
