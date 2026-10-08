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
  /// **'School and health records arrive in later sprints.'**
  String get addComingSoonMessage;

  /// No description provided for @addComingSoonHealthOnly.
  ///
  /// In en, this message translates to:
  /// **'Health records arrive in later sprints.'**
  String get addComingSoonHealthOnly;

  /// No description provided for @addGroupSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get addGroupSchool;

  /// No description provided for @addSchoolProfile.
  ///
  /// In en, this message translates to:
  /// **'Add school'**
  String get addSchoolProfile;

  /// No description provided for @editSchoolProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit school'**
  String get editSchoolProfile;

  /// No description provided for @addSchoolProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'School name, class, and teacher.'**
  String get addSchoolProfileSubtitle;

  /// No description provided for @addSchoolEvent.
  ///
  /// In en, this message translates to:
  /// **'Add school event'**
  String get addSchoolEvent;

  /// No description provided for @editSchoolEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit school event'**
  String get editSchoolEvent;

  /// No description provided for @addSchoolEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'First day, exams, certificates, and more.'**
  String get addSchoolEventSubtitle;

  /// No description provided for @addReportCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attach a report card photo or PDF.'**
  String get addReportCardSubtitle;

  /// No description provided for @addGroupDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get addGroupDevelopment;

  /// No description provided for @schoolTitle.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolTitle;

  /// No description provided for @schoolCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current school'**
  String get schoolCurrent;

  /// No description provided for @schoolCurrentBadge.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get schoolCurrentBadge;

  /// No description provided for @schoolEmpty.
  ///
  /// In en, this message translates to:
  /// **'No school profile yet. Add the first one.'**
  String get schoolEmpty;

  /// No description provided for @schoolHistory.
  ///
  /// In en, this message translates to:
  /// **'School history'**
  String get schoolHistory;

  /// No description provided for @schoolEvents.
  ///
  /// In en, this message translates to:
  /// **'School events'**
  String get schoolEvents;

  /// No description provided for @schoolEventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No school events yet.'**
  String get schoolEventsEmpty;

  /// No description provided for @schoolRecentEvent.
  ///
  /// In en, this message translates to:
  /// **'Recent school event'**
  String get schoolRecentEvent;

  /// No description provided for @schoolTimeline.
  ///
  /// In en, this message translates to:
  /// **'School timeline'**
  String get schoolTimeline;

  /// No description provided for @schoolAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get schoolAdd;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'School name'**
  String get schoolName;

  /// No description provided for @schoolNameRequired.
  ///
  /// In en, this message translates to:
  /// **'School name is required.'**
  String get schoolNameRequired;

  /// No description provided for @schoolClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get schoolClass;

  /// No description provided for @schoolTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get schoolTeacher;

  /// No description provided for @schoolStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get schoolStartDate;

  /// No description provided for @schoolEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get schoolEndDate;

  /// No description provided for @schoolEndDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Still attending (no end date)'**
  String get schoolEndDateOptional;

  /// No description provided for @schoolClearEndDate.
  ///
  /// In en, this message translates to:
  /// **'Clear end date'**
  String get schoolClearEndDate;

  /// No description provided for @saveSchoolProfile.
  ///
  /// In en, this message translates to:
  /// **'Save school'**
  String get saveSchoolProfile;

  /// No description provided for @deleteSchoolTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this school?'**
  String get deleteSchoolTitle;

  /// No description provided for @deleteSchoolMessage.
  ///
  /// In en, this message translates to:
  /// **'This school profile will be removed from this device.'**
  String get deleteSchoolMessage;

  /// No description provided for @schoolEventType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get schoolEventType;

  /// No description provided for @schoolEventFirstDay.
  ///
  /// In en, this message translates to:
  /// **'First day'**
  String get schoolEventFirstDay;

  /// No description provided for @schoolEventExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get schoolEventExam;

  /// No description provided for @schoolEventPerformance.
  ///
  /// In en, this message translates to:
  /// **'School performance'**
  String get schoolEventPerformance;

  /// No description provided for @schoolEventSports.
  ///
  /// In en, this message translates to:
  /// **'Sports event'**
  String get schoolEventSports;

  /// No description provided for @schoolEventCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get schoolEventCertificate;

  /// No description provided for @schoolEventPromotion.
  ///
  /// In en, this message translates to:
  /// **'Class promotion'**
  String get schoolEventPromotion;

  /// No description provided for @schoolEventProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get schoolEventProject;

  /// No description provided for @schoolEventReportCard.
  ///
  /// In en, this message translates to:
  /// **'Report card'**
  String get schoolEventReportCard;

  /// No description provided for @schoolEventCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get schoolEventCustom;

  /// No description provided for @schoolEventTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Event title is required.'**
  String get schoolEventTitleRequired;

  /// No description provided for @schoolLinkedProfile.
  ///
  /// In en, this message translates to:
  /// **'Linked school'**
  String get schoolLinkedProfile;

  /// No description provided for @schoolNoLinkedProfile.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get schoolNoLinkedProfile;

  /// No description provided for @schoolAttachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attach photos, certificates, or PDF report cards.'**
  String get schoolAttachmentsHint;

  /// No description provided for @saveSchoolEvent.
  ///
  /// In en, this message translates to:
  /// **'Save school event'**
  String get saveSchoolEvent;

  /// No description provided for @deleteSchoolEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this school event?'**
  String get deleteSchoolEventTitle;

  /// No description provided for @deleteSchoolEventMessage.
  ///
  /// In en, this message translates to:
  /// **'This school event will be removed from this device.'**
  String get deleteSchoolEventMessage;

  /// No description provided for @attachmentsAndDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos & documents'**
  String get attachmentsAndDocsTitle;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add file'**
  String get addDocument;

  /// No description provided for @schoolDashboard.
  ///
  /// In en, this message translates to:
  /// **'School & achievements'**
  String get schoolDashboard;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @addGrowth.
  ///
  /// In en, this message translates to:
  /// **'Add growth'**
  String get addGrowth;

  /// No description provided for @editGrowth.
  ///
  /// In en, this message translates to:
  /// **'Edit growth'**
  String get editGrowth;

  /// No description provided for @addGrowthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record height and weight.'**
  String get addGrowthSubtitle;

  /// No description provided for @addMilestone.
  ///
  /// In en, this message translates to:
  /// **'Add milestone'**
  String get addMilestone;

  /// No description provided for @editMilestone.
  ///
  /// In en, this message translates to:
  /// **'Edit milestone'**
  String get editMilestone;

  /// No description provided for @addMilestoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'First steps, words, and more.'**
  String get addMilestoneSubtitle;

  /// No description provided for @addFirstWord.
  ///
  /// In en, this message translates to:
  /// **'Add first word'**
  String get addFirstWord;

  /// No description provided for @editFirstWord.
  ///
  /// In en, this message translates to:
  /// **'Edit first word'**
  String get editFirstWord;

  /// No description provided for @addFirstWordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture the first spoken word.'**
  String get addFirstWordSubtitle;

  /// No description provided for @growthTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growthTitle;

  /// No description provided for @growthHistory.
  ///
  /// In en, this message translates to:
  /// **'Growth history'**
  String get growthHistory;

  /// No description provided for @growthDetail.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get growthDetail;

  /// No description provided for @growthHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get growthHeight;

  /// No description provided for @growthWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get growthWeight;

  /// No description provided for @growthHeightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get growthHeightCm;

  /// No description provided for @growthHeightFt.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get growthHeightFt;

  /// No description provided for @growthHeightIn.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get growthHeightIn;

  /// No description provided for @growthWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get growthWeightKg;

  /// No description provided for @growthWeightLb.
  ///
  /// In en, this message translates to:
  /// **'Weight (lb)'**
  String get growthWeightLb;

  /// No description provided for @growthNeedValue.
  ///
  /// In en, this message translates to:
  /// **'Enter height, weight, or both.'**
  String get growthNeedValue;

  /// No description provided for @growthPreviousContext.
  ///
  /// In en, this message translates to:
  /// **'Previous: {height} · {weight}'**
  String growthPreviousContext(String height, String weight);

  /// No description provided for @saveGrowth.
  ///
  /// In en, this message translates to:
  /// **'Save measurement'**
  String get saveGrowth;

  /// No description provided for @growthHeightChart.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get growthHeightChart;

  /// No description provided for @growthWeightChart.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get growthWeightChart;

  /// No description provided for @growthRange6m.
  ///
  /// In en, this message translates to:
  /// **'6 mo'**
  String get growthRange6m;

  /// No description provided for @growthRange1y.
  ///
  /// In en, this message translates to:
  /// **'1 yr'**
  String get growthRange1y;

  /// No description provided for @growthRangeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get growthRangeAll;

  /// No description provided for @growthChartNeedMore.
  ///
  /// In en, this message translates to:
  /// **'Add at least two measurements to see a chart.'**
  String get growthChartNeedMore;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'Height in cm'**
  String get unitCm;

  /// No description provided for @unitFtIn.
  ///
  /// In en, this message translates to:
  /// **'Height in ft/in'**
  String get unitFtIn;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'Weight in kg'**
  String get unitKg;

  /// No description provided for @unitLb.
  ///
  /// In en, this message translates to:
  /// **'Weight in lb'**
  String get unitLb;

  /// No description provided for @deleteGrowthTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this measurement?'**
  String get deleteGrowthTitle;

  /// No description provided for @deleteGrowthMessage.
  ///
  /// In en, this message translates to:
  /// **'This growth record will be removed from this device.'**
  String get deleteGrowthMessage;

  /// No description provided for @milestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestonesTitle;

  /// No description provided for @milestoneCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get milestoneCategories;

  /// No description provided for @milestoneTemplates.
  ///
  /// In en, this message translates to:
  /// **'Quick milestones'**
  String get milestoneTemplates;

  /// No description provided for @recentMilestones.
  ///
  /// In en, this message translates to:
  /// **'Recent milestones'**
  String get recentMilestones;

  /// No description provided for @milestonesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No milestones yet. Celebrate a first!'**
  String get milestonesEmpty;

  /// No description provided for @milestoneTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get milestoneTitleField;

  /// No description provided for @milestoneTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Milestone title is required.'**
  String get milestoneTitleRequired;

  /// No description provided for @saveMilestone.
  ///
  /// In en, this message translates to:
  /// **'Save milestone'**
  String get saveMilestone;

  /// No description provided for @milestoneMovement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get milestoneMovement;

  /// No description provided for @milestoneSpeech.
  ///
  /// In en, this message translates to:
  /// **'Speech'**
  String get milestoneSpeech;

  /// No description provided for @milestoneSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get milestoneSocial;

  /// No description provided for @milestoneSelfCare.
  ///
  /// In en, this message translates to:
  /// **'Self-care'**
  String get milestoneSelfCare;

  /// No description provided for @milestoneLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get milestoneLearning;

  /// No description provided for @milestoneCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get milestoneCustom;

  /// No description provided for @templateFirstCrawl.
  ///
  /// In en, this message translates to:
  /// **'First crawl'**
  String get templateFirstCrawl;

  /// No description provided for @templateFirstStand.
  ///
  /// In en, this message translates to:
  /// **'First stand'**
  String get templateFirstStand;

  /// No description provided for @templateFirstStep.
  ///
  /// In en, this message translates to:
  /// **'First step'**
  String get templateFirstStep;

  /// No description provided for @templateFirstWalk.
  ///
  /// In en, this message translates to:
  /// **'First walk'**
  String get templateFirstWalk;

  /// No description provided for @templateFirstRun.
  ///
  /// In en, this message translates to:
  /// **'First run'**
  String get templateFirstRun;

  /// No description provided for @templateFirstBicycle.
  ///
  /// In en, this message translates to:
  /// **'First bicycle ride'**
  String get templateFirstBicycle;

  /// No description provided for @templateFirstWord.
  ///
  /// In en, this message translates to:
  /// **'First word'**
  String get templateFirstWord;

  /// No description provided for @templateFirstSentence.
  ///
  /// In en, this message translates to:
  /// **'First sentence'**
  String get templateFirstSentence;

  /// No description provided for @templateWroteOwnName.
  ///
  /// In en, this message translates to:
  /// **'Wrote own name'**
  String get templateWroteOwnName;

  /// No description provided for @deleteMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this milestone?'**
  String get deleteMilestoneTitle;

  /// No description provided for @deleteMilestoneMessage.
  ///
  /// In en, this message translates to:
  /// **'This milestone will be removed from this device.'**
  String get deleteMilestoneMessage;

  /// No description provided for @datePrecisionLabel.
  ///
  /// In en, this message translates to:
  /// **'How sure are you about the date?'**
  String get datePrecisionLabel;

  /// No description provided for @datePrecisionExact.
  ///
  /// In en, this message translates to:
  /// **'Exact date'**
  String get datePrecisionExact;

  /// No description provided for @datePrecisionMonth.
  ///
  /// In en, this message translates to:
  /// **'Month only'**
  String get datePrecisionMonth;

  /// No description provided for @datePrecisionYear.
  ///
  /// In en, this message translates to:
  /// **'Year only'**
  String get datePrecisionYear;

  /// No description provided for @datePrecisionApproximate.
  ///
  /// In en, this message translates to:
  /// **'Approximate'**
  String get datePrecisionApproximate;

  /// No description provided for @datePrecisionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get datePrecisionUnknown;

  /// No description provided for @datePrecisionPick.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get datePrecisionPick;

  /// No description provided for @datePrecisionPickMonth.
  ///
  /// In en, this message translates to:
  /// **'Choose month'**
  String get datePrecisionPickMonth;

  /// No description provided for @datePrecisionPickYear.
  ///
  /// In en, this message translates to:
  /// **'Choose year'**
  String get datePrecisionPickYear;

  /// No description provided for @firstWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'First words'**
  String get firstWordsTitle;

  /// No description provided for @firstWordsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No first words yet.'**
  String get firstWordsEmpty;

  /// No description provided for @firstWordDetail.
  ///
  /// In en, this message translates to:
  /// **'First word'**
  String get firstWordDetail;

  /// No description provided for @firstWordField.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get firstWordField;

  /// No description provided for @firstWordRequired.
  ///
  /// In en, this message translates to:
  /// **'Word is required.'**
  String get firstWordRequired;

  /// No description provided for @firstWordLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get firstWordLanguage;

  /// No description provided for @firstWordLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Bangla, English…'**
  String get firstWordLanguageHint;

  /// No description provided for @firstWordContext.
  ///
  /// In en, this message translates to:
  /// **'Story / context'**
  String get firstWordContext;

  /// No description provided for @firstWordAudioPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Audio coming later'**
  String get firstWordAudioPlaceholder;

  /// No description provided for @firstWordAudioHint.
  ///
  /// In en, this message translates to:
  /// **'Mark this for future audio recording support.'**
  String get firstWordAudioHint;

  /// No description provided for @saveFirstWord.
  ///
  /// In en, this message translates to:
  /// **'Save first word'**
  String get saveFirstWord;

  /// No description provided for @deleteFirstWordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this first word?'**
  String get deleteFirstWordTitle;

  /// No description provided for @deleteFirstWordMessage.
  ///
  /// In en, this message translates to:
  /// **'This first word will be removed from this device.'**
  String get deleteFirstWordMessage;

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

  /// No description provided for @healthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthTitle;

  /// No description provided for @healthSummary.
  ///
  /// In en, this message translates to:
  /// **'Health summary'**
  String get healthSummary;

  /// No description provided for @healthDisclaimerShort.
  ///
  /// In en, this message translates to:
  /// **'Parent-entered notes — not a substitute for medical advice.'**
  String get healthDisclaimerShort;

  /// No description provided for @healthDisclaimerFull.
  ///
  /// In en, this message translates to:
  /// **'Information in Shishur Dinlipi is entered by the parent or caregiver and should not replace official medical records or professional medical advice.'**
  String get healthDisclaimerFull;

  /// No description provided for @healthBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get healthBloodGroup;

  /// No description provided for @healthLatestGrowth.
  ///
  /// In en, this message translates to:
  /// **'Latest growth'**
  String get healthLatestGrowth;

  /// No description provided for @healthCurrentMedicine.
  ///
  /// In en, this message translates to:
  /// **'Current medicine'**
  String get healthCurrentMedicine;

  /// No description provided for @healthRecentIllness.
  ///
  /// In en, this message translates to:
  /// **'Recent illness'**
  String get healthRecentIllness;

  /// No description provided for @healthVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get healthVaccination;

  /// No description provided for @healthLastDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Last doctor visit'**
  String get healthLastDoctorVisit;

  /// No description provided for @healthUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get healthUpcoming;

  /// No description provided for @healthGridVaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get healthGridVaccinations;

  /// No description provided for @healthGridIllness.
  ///
  /// In en, this message translates to:
  /// **'Illness history'**
  String get healthGridIllness;

  /// No description provided for @healthGridMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get healthGridMedicines;

  /// No description provided for @healthGridDoctorVisits.
  ///
  /// In en, this message translates to:
  /// **'Doctor visits'**
  String get healthGridDoctorVisits;

  /// No description provided for @healthGridDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get healthGridDocuments;

  /// No description provided for @healthEmpty.
  ///
  /// In en, this message translates to:
  /// **'No health records yet. Add the first one.'**
  String get healthEmpty;

  /// No description provided for @healthAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get healthAdd;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get commonNotes;

  /// No description provided for @vaccinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vaccinationTitle;

  /// No description provided for @vaccinationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No vaccinations yet.'**
  String get vaccinationsEmpty;

  /// No description provided for @addVaccination.
  ///
  /// In en, this message translates to:
  /// **'Add vaccination'**
  String get addVaccination;

  /// No description provided for @editVaccination.
  ///
  /// In en, this message translates to:
  /// **'Edit vaccination'**
  String get editVaccination;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine name'**
  String get vaccineName;

  /// No description provided for @vaccineNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Vaccine name is required.'**
  String get vaccineNameRequired;

  /// No description provided for @vaccineDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get vaccineDose;

  /// No description provided for @vaccineScheduledDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled date'**
  String get vaccineScheduledDate;

  /// No description provided for @vaccineGivenDate.
  ///
  /// In en, this message translates to:
  /// **'Given date'**
  String get vaccineGivenDate;

  /// No description provided for @vaccineProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get vaccineProvider;

  /// No description provided for @vaccineClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get vaccineClinic;

  /// No description provided for @vaccineBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch number'**
  String get vaccineBatch;

  /// No description provided for @vaccineStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get vaccineStatus;

  /// No description provided for @vaccineStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get vaccineStatusUpcoming;

  /// No description provided for @vaccineStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get vaccineStatusCompleted;

  /// No description provided for @vaccineStatusDelayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get vaccineStatusDelayed;

  /// No description provided for @vaccineStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get vaccineStatusSkipped;

  /// No description provided for @vaccineStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get vaccineStatusUnknown;

  /// No description provided for @saveVaccination.
  ///
  /// In en, this message translates to:
  /// **'Save vaccination'**
  String get saveVaccination;

  /// No description provided for @deleteVaccinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this vaccination?'**
  String get deleteVaccinationTitle;

  /// No description provided for @deleteVaccinationMessage.
  ///
  /// In en, this message translates to:
  /// **'This vaccination record will be removed from this device.'**
  String get deleteVaccinationMessage;

  /// No description provided for @vaccineAttachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attach a vaccination card photo or PDF.'**
  String get vaccineAttachmentsHint;

  /// No description provided for @illnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Illness history'**
  String get illnessTitle;

  /// No description provided for @illnessesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No illness episodes yet.'**
  String get illnessesEmpty;

  /// No description provided for @addIllness.
  ///
  /// In en, this message translates to:
  /// **'Add illness'**
  String get addIllness;

  /// No description provided for @editIllness.
  ///
  /// In en, this message translates to:
  /// **'Edit illness'**
  String get editIllness;

  /// No description provided for @illnessTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get illnessTitleField;

  /// No description provided for @illnessTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Illness title is required.'**
  String get illnessTitleRequired;

  /// No description provided for @illnessStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get illnessStartDate;

  /// No description provided for @illnessEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get illnessEndDate;

  /// No description provided for @illnessOngoing.
  ///
  /// In en, this message translates to:
  /// **'Still recovering (no end date)'**
  String get illnessOngoing;

  /// No description provided for @illnessClearEndDate.
  ///
  /// In en, this message translates to:
  /// **'Clear end date'**
  String get illnessClearEndDate;

  /// No description provided for @illnessSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get illnessSymptoms;

  /// No description provided for @illnessTemperature.
  ///
  /// In en, this message translates to:
  /// **'Max temperature (°C)'**
  String get illnessTemperature;

  /// No description provided for @illnessDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get illnessDiagnosis;

  /// No description provided for @illnessRecoveryNote.
  ///
  /// In en, this message translates to:
  /// **'Recovery note'**
  String get illnessRecoveryNote;

  /// No description provided for @illnessLinkedVisit.
  ///
  /// In en, this message translates to:
  /// **'Linked doctor visit'**
  String get illnessLinkedVisit;

  /// No description provided for @illnessNoLinkedVisit.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get illnessNoLinkedVisit;

  /// No description provided for @saveIllness.
  ///
  /// In en, this message translates to:
  /// **'Save illness'**
  String get saveIllness;

  /// No description provided for @deleteIllnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this illness?'**
  String get deleteIllnessTitle;

  /// No description provided for @deleteIllnessMessage.
  ///
  /// In en, this message translates to:
  /// **'This illness record will be removed from this device.'**
  String get deleteIllnessMessage;

  /// No description provided for @illnessAttachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attach photos or documents from this illness.'**
  String get illnessAttachmentsHint;

  /// No description provided for @symptomFever.
  ///
  /// In en, this message translates to:
  /// **'Fever'**
  String get symptomFever;

  /// No description provided for @symptomCough.
  ///
  /// In en, this message translates to:
  /// **'Cough'**
  String get symptomCough;

  /// No description provided for @symptomCold.
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get symptomCold;

  /// No description provided for @symptomVomiting.
  ///
  /// In en, this message translates to:
  /// **'Vomiting'**
  String get symptomVomiting;

  /// No description provided for @symptomDiarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get symptomDiarrhea;

  /// No description provided for @symptomRash.
  ///
  /// In en, this message translates to:
  /// **'Rash'**
  String get symptomRash;

  /// No description provided for @symptomHeadache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get symptomHeadache;

  /// No description provided for @symptomStomachPain.
  ///
  /// In en, this message translates to:
  /// **'Stomach pain'**
  String get symptomStomachPain;

  /// No description provided for @symptomBreathing.
  ///
  /// In en, this message translates to:
  /// **'Breathing difficulty'**
  String get symptomBreathing;

  /// No description provided for @symptomAllergy.
  ///
  /// In en, this message translates to:
  /// **'Allergy'**
  String get symptomAllergy;

  /// No description provided for @symptomInjury.
  ///
  /// In en, this message translates to:
  /// **'Injury'**
  String get symptomInjury;

  /// No description provided for @symptomOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get symptomOther;

  /// No description provided for @medicineTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicineTitle;

  /// No description provided for @medicinesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet.'**
  String get medicinesEmpty;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get addMedicine;

  /// No description provided for @editMedicine.
  ///
  /// In en, this message translates to:
  /// **'Edit medicine'**
  String get editMedicine;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get medicineName;

  /// No description provided for @medicineNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Medicine name is required.'**
  String get medicineNameRequired;

  /// No description provided for @medicineStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get medicineStrength;

  /// No description provided for @medicineDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get medicineDose;

  /// No description provided for @medicineFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get medicineFrequency;

  /// No description provided for @medicineStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get medicineStartDate;

  /// No description provided for @medicineEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get medicineEndDate;

  /// No description provided for @medicineReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get medicineReason;

  /// No description provided for @medicinePrescriber.
  ///
  /// In en, this message translates to:
  /// **'Prescriber'**
  String get medicinePrescriber;

  /// No description provided for @medicineStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get medicineStatus;

  /// No description provided for @medicineStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get medicineStatusActive;

  /// No description provided for @medicineStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get medicineStatusCompleted;

  /// No description provided for @medicineStatusStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get medicineStatusStopped;

  /// No description provided for @medicineStatusAsNeeded.
  ///
  /// In en, this message translates to:
  /// **'As needed'**
  String get medicineStatusAsNeeded;

  /// No description provided for @medicineSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get medicineSchedule;

  /// No description provided for @medicineAddScheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get medicineAddScheduleTime;

  /// No description provided for @saveMedicine.
  ///
  /// In en, this message translates to:
  /// **'Save medicine'**
  String get saveMedicine;

  /// No description provided for @deleteMedicineTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this medicine?'**
  String get deleteMedicineTitle;

  /// No description provided for @deleteMedicineMessage.
  ///
  /// In en, this message translates to:
  /// **'This medicine record will be removed from this device.'**
  String get deleteMedicineMessage;

  /// No description provided for @doctorVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctor visits'**
  String get doctorVisitTitle;

  /// No description provided for @doctorVisitsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No doctor visits yet.'**
  String get doctorVisitsEmpty;

  /// No description provided for @addDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Add doctor visit'**
  String get addDoctorVisit;

  /// No description provided for @editDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Edit doctor visit'**
  String get editDoctorVisit;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorName;

  /// No description provided for @doctorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Doctor name is required.'**
  String get doctorNameRequired;

  /// No description provided for @doctorSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get doctorSpecialty;

  /// No description provided for @doctorHospital.
  ///
  /// In en, this message translates to:
  /// **'Chamber / hospital'**
  String get doctorHospital;

  /// No description provided for @doctorReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get doctorReason;

  /// No description provided for @doctorSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get doctorSymptoms;

  /// No description provided for @doctorDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get doctorDiagnosis;

  /// No description provided for @doctorTests.
  ///
  /// In en, this message translates to:
  /// **'Tests advised'**
  String get doctorTests;

  /// No description provided for @doctorFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up date'**
  String get doctorFollowUp;

  /// No description provided for @saveDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Save visit'**
  String get saveDoctorVisit;

  /// No description provided for @deleteDoctorVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this visit?'**
  String get deleteDoctorVisitTitle;

  /// No description provided for @deleteDoctorVisitMessage.
  ///
  /// In en, this message translates to:
  /// **'This doctor visit will be removed from this device.'**
  String get deleteDoctorVisitMessage;

  /// No description provided for @doctorAttachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attach a prescription photo or PDF.'**
  String get doctorAttachmentsHint;

  /// No description provided for @medicalDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical documents'**
  String get medicalDocsTitle;

  /// No description provided for @medicalDocsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No medical documents yet.'**
  String get medicalDocsEmpty;

  /// No description provided for @addMedicalDocument.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get addMedicalDocument;

  /// No description provided for @editMedicalDocument.
  ///
  /// In en, this message translates to:
  /// **'Edit document'**
  String get editMedicalDocument;

  /// No description provided for @medicalDocType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get medicalDocType;

  /// No description provided for @medicalDocTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get medicalDocTitle;

  /// No description provided for @medicalDocTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Document title is required.'**
  String get medicalDocTitleRequired;

  /// No description provided for @medicalDocDate.
  ///
  /// In en, this message translates to:
  /// **'Document date'**
  String get medicalDocDate;

  /// No description provided for @medicalDocNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get medicalDocNotes;

  /// No description provided for @medicalDocFileRequired.
  ///
  /// In en, this message translates to:
  /// **'A file is required.'**
  String get medicalDocFileRequired;

  /// No description provided for @medicalDocPickFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get medicalDocPickFile;

  /// No description provided for @saveMedicalDocument.
  ///
  /// In en, this message translates to:
  /// **'Save document'**
  String get saveMedicalDocument;

  /// No description provided for @deleteMedicalDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this document?'**
  String get deleteMedicalDocumentTitle;

  /// No description provided for @deleteMedicalDocumentMessage.
  ///
  /// In en, this message translates to:
  /// **'This medical document will be removed from this device.'**
  String get deleteMedicalDocumentMessage;

  /// No description provided for @docTypePrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get docTypePrescription;

  /// No description provided for @docTypeDiagnostic.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic report'**
  String get docTypeDiagnostic;

  /// No description provided for @docTypeVaccinationCard.
  ///
  /// In en, this message translates to:
  /// **'Vaccination card'**
  String get docTypeVaccinationCard;

  /// No description provided for @docTypeDischarge.
  ///
  /// In en, this message translates to:
  /// **'Discharge summary'**
  String get docTypeDischarge;

  /// No description provided for @docTypeCertificate.
  ///
  /// In en, this message translates to:
  /// **'Medical certificate'**
  String get docTypeCertificate;

  /// No description provided for @docTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docTypeOther;

  /// No description provided for @timelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No timeline entries yet.'**
  String get timelineEmpty;

  /// No description provided for @timelineFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get timelineFilterAll;

  /// No description provided for @timelineFilterMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get timelineFilterMemories;

  /// No description provided for @timelineFilterGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get timelineFilterGrowth;

  /// No description provided for @timelineFilterMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get timelineFilterMilestones;

  /// No description provided for @timelineFilterHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get timelineFilterHealth;

  /// No description provided for @timelineFilterSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get timelineFilterSchool;

  /// No description provided for @timelineFilterAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get timelineFilterAchievements;

  /// No description provided for @timelineFilterPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get timelineFilterPhotos;

  /// No description provided for @timelineFilterFunny.
  ///
  /// In en, this message translates to:
  /// **'Funny'**
  String get timelineFilterFunny;

  /// No description provided for @timelineTypeJournal.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get timelineTypeJournal;

  /// No description provided for @timelineTypeFunny.
  ///
  /// In en, this message translates to:
  /// **'Funny'**
  String get timelineTypeFunny;

  /// No description provided for @timelineTypeAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get timelineTypeAchievement;

  /// No description provided for @timelineTypeGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get timelineTypeGrowth;

  /// No description provided for @timelineTypeMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get timelineTypeMilestone;

  /// No description provided for @timelineTypeSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get timelineTypeSchool;

  /// No description provided for @timelineTypeVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get timelineTypeVaccination;

  /// No description provided for @timelineTypeIllness.
  ///
  /// In en, this message translates to:
  /// **'Illness'**
  String get timelineTypeIllness;

  /// No description provided for @timelineTypeDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor visit'**
  String get timelineTypeDoctor;

  /// No description provided for @timelineTypeBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get timelineTypeBirthday;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events on this day.'**
  String get calendarNoEvents;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @remindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet.'**
  String get remindersEmpty;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get addReminder;

  /// No description provided for @editReminder.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get editReminder;

  /// No description provided for @reminderTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get reminderTitleField;

  /// No description provided for @reminderTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required.'**
  String get reminderTitleRequired;

  /// No description provided for @reminderType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get reminderType;

  /// No description provided for @reminderDateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get reminderDateTime;

  /// No description provided for @reminderRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get reminderRepeat;

  /// No description provided for @reminderEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications on'**
  String get reminderEnabled;

  /// No description provided for @reminderNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get reminderNotes;

  /// No description provided for @saveReminder.
  ///
  /// In en, this message translates to:
  /// **'Save reminder'**
  String get saveReminder;

  /// No description provided for @deleteReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this reminder?'**
  String get deleteReminderTitle;

  /// No description provided for @deleteReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'This reminder will be removed from this device.'**
  String get deleteReminderMessage;

  /// No description provided for @reminderTypeVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get reminderTypeVaccination;

  /// No description provided for @reminderTypeMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get reminderTypeMedicine;

  /// No description provided for @reminderTypeDoctorFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Doctor follow-up'**
  String get reminderTypeDoctorFollowUp;

  /// No description provided for @reminderTypeBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get reminderTypeBirthday;

  /// No description provided for @reminderTypeWeeklyMemory.
  ///
  /// In en, this message translates to:
  /// **'Weekly memory'**
  String get reminderTypeWeeklyMemory;

  /// No description provided for @reminderTypeBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get reminderTypeBackup;

  /// No description provided for @reminderTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get reminderTypeCustom;

  /// No description provided for @reminderRepeatNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get reminderRepeatNone;

  /// No description provided for @reminderRepeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get reminderRepeatDaily;

  /// No description provided for @reminderRepeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get reminderRepeatWeekly;

  /// No description provided for @reminderRepeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get reminderRepeatYearly;

  /// No description provided for @reminderRepeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get reminderRepeatMonthly;

  /// No description provided for @onThisDayTitle.
  ///
  /// In en, this message translates to:
  /// **'On this day'**
  String get onThisDayTitle;

  /// No description provided for @onThisDayEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing from past years on this day yet.'**
  String get onThisDayEmpty;

  /// No description provided for @onThisDayYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{years} years ago'**
  String onThisDayYearsAgo(int years);

  /// No description provided for @upcomingReminders.
  ///
  /// In en, this message translates to:
  /// **'Upcoming reminders'**
  String get upcomingReminders;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders?'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Shishur Dinlipi can remind you about vaccinations, medicines, follow-up visits and important memories.'**
  String get notificationPermissionBody;

  /// No description provided for @notificationAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get notificationAllow;

  /// No description provided for @notificationNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notificationNotNow;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search memories, health, school…'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No matching records.'**
  String get searchEmpty;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecent;

  /// No description provided for @searchFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchFilterAll;

  /// No description provided for @searchTypeJournal.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get searchTypeJournal;

  /// No description provided for @searchTypeMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get searchTypeMilestone;

  /// No description provided for @searchTypeMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get searchTypeMedicine;

  /// No description provided for @searchTypeDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get searchTypeDoctor;

  /// No description provided for @searchTypeIllness.
  ///
  /// In en, this message translates to:
  /// **'Illnesses'**
  String get searchTypeIllness;

  /// No description provided for @searchTypeSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get searchTypeSchool;

  /// No description provided for @searchTypeAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get searchTypeAchievement;

  /// No description provided for @searchFromDate.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get searchFromDate;

  /// No description provided for @searchToDate.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get searchToDate;

  /// No description provided for @searchClearDates.
  ///
  /// In en, this message translates to:
  /// **'Clear dates'**
  String get searchClearDates;

  /// No description provided for @searchFilterAllTags.
  ///
  /// In en, this message translates to:
  /// **'All tags'**
  String get searchFilterAllTags;

  /// No description provided for @photosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosTitle;

  /// No description provided for @photosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos yet.'**
  String get photosEmpty;

  /// No description provided for @photosFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get photosFavorites;

  /// No description provided for @photosByYear.
  ///
  /// In en, this message translates to:
  /// **'By year'**
  String get photosByYear;

  /// No description provided for @photosByAge.
  ///
  /// In en, this message translates to:
  /// **'By age'**
  String get photosByAge;

  /// No description provided for @photosByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get photosByCategory;

  /// No description provided for @photosAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get photosAll;

  /// No description provided for @photoMissing.
  ///
  /// In en, this message translates to:
  /// **'This photo or file is no longer available.'**
  String get photoMissing;

  /// No description provided for @photoFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get photoFavorite;

  /// No description provided for @photoUnfavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove favorite'**
  String get photoUnfavorite;

  /// No description provided for @albumsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No albums yet. Create a custom album.'**
  String get albumsEmpty;

  /// No description provided for @addAlbum.
  ///
  /// In en, this message translates to:
  /// **'Create album'**
  String get addAlbum;

  /// No description provided for @editAlbum.
  ///
  /// In en, this message translates to:
  /// **'Edit album'**
  String get editAlbum;

  /// No description provided for @albumTitleField.
  ///
  /// In en, this message translates to:
  /// **'Album title'**
  String get albumTitleField;

  /// No description provided for @albumTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Album title is required.'**
  String get albumTitleRequired;

  /// No description provided for @albumTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get albumTheme;

  /// No description provided for @albumCover.
  ///
  /// In en, this message translates to:
  /// **'Cover photo'**
  String get albumCover;

  /// No description provided for @albumAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get albumAddPhotos;

  /// No description provided for @albumNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items in this album yet.'**
  String get albumNoItems;

  /// No description provided for @saveAlbum.
  ///
  /// In en, this message translates to:
  /// **'Save album'**
  String get saveAlbum;

  /// No description provided for @deleteAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this album?'**
  String get deleteAlbumTitle;

  /// No description provided for @deleteAlbumMessage.
  ///
  /// In en, this message translates to:
  /// **'This album will be removed from this device.'**
  String get deleteAlbumMessage;

  /// No description provided for @albumThemeMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get albumThemeMinimal;

  /// No description provided for @albumThemePlayful.
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get albumThemePlayful;

  /// No description provided for @albumThemeColorful.
  ///
  /// In en, this message translates to:
  /// **'Colorful'**
  String get albumThemeColorful;

  /// No description provided for @albumThemeElegant.
  ///
  /// In en, this message translates to:
  /// **'Elegant'**
  String get albumThemeElegant;

  /// No description provided for @tagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsTitle;

  /// No description provided for @tagsAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add a tag'**
  String get tagsAddHint;

  /// No description provided for @tagsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tags yet.'**
  String get tagsEmpty;

  /// No description provided for @yearReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Year in Review'**
  String get yearReviewTitle;

  /// No description provided for @yearReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a yearly memory album — entirely offline.'**
  String get yearReviewSubtitle;

  /// No description provided for @yearReviewPickYear.
  ///
  /// In en, this message translates to:
  /// **'Choose a year'**
  String get yearReviewPickYear;

  /// No description provided for @yearReviewEmptyYears.
  ///
  /// In en, this message translates to:
  /// **'Add a child profile to start a Year in Review.'**
  String get yearReviewEmptyYears;

  /// No description provided for @yearReviewOpenYear.
  ///
  /// In en, this message translates to:
  /// **'Open {name}\'s {year} review'**
  String yearReviewOpenYear(String name, int year);

  /// No description provided for @yearReviewEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Year in Review'**
  String get yearReviewEditorTitle;

  /// No description provided for @yearReviewTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get yearReviewTheme;

  /// No description provided for @yearReviewLanguage.
  ///
  /// In en, this message translates to:
  /// **'PDF language'**
  String get yearReviewLanguage;

  /// No description provided for @yearReviewIncludeHealth.
  ///
  /// In en, this message translates to:
  /// **'Include health highlights'**
  String get yearReviewIncludeHealth;

  /// No description provided for @yearReviewParentLetter.
  ///
  /// In en, this message translates to:
  /// **'Parent letter'**
  String get yearReviewParentLetter;

  /// No description provided for @yearReviewParentLetterHint.
  ///
  /// In en, this message translates to:
  /// **'Write a short letter to your child…'**
  String get yearReviewParentLetterHint;

  /// No description provided for @yearReviewCover.
  ///
  /// In en, this message translates to:
  /// **'Cover photo'**
  String get yearReviewCover;

  /// No description provided for @yearReviewNoCover.
  ///
  /// In en, this message translates to:
  /// **'No cover'**
  String get yearReviewNoCover;

  /// No description provided for @yearReviewNoCoverPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos this year to use as a cover.'**
  String get yearReviewNoCoverPhotos;

  /// No description provided for @yearReviewEditCaption.
  ///
  /// In en, this message translates to:
  /// **'Edit caption'**
  String get yearReviewEditCaption;

  /// No description provided for @yearReviewGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate PDF'**
  String get yearReviewGenerate;

  /// No description provided for @yearReviewSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved.'**
  String get yearReviewSaved;

  /// No description provided for @yearReviewGeneratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating your album'**
  String get yearReviewGeneratingTitle;

  /// No description provided for @yearReviewStagePreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing memories…'**
  String get yearReviewStagePreparing;

  /// No description provided for @yearReviewStagePhotos.
  ///
  /// In en, this message translates to:
  /// **'Processing photos…'**
  String get yearReviewStagePhotos;

  /// No description provided for @yearReviewStageBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building pages…'**
  String get yearReviewStageBuilding;

  /// No description provided for @yearReviewStageSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving PDF…'**
  String get yearReviewStageSaving;

  /// No description provided for @yearReviewStageComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get yearReviewStageComplete;

  /// No description provided for @yearReviewStageFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the PDF'**
  String get yearReviewStageFailed;

  /// No description provided for @yearReviewPdfReady.
  ///
  /// In en, this message translates to:
  /// **'Your Year in Review PDF is ready.'**
  String get yearReviewPdfReady;

  /// No description provided for @yearReviewPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get yearReviewPreview;

  /// No description provided for @yearReviewShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get yearReviewShare;

  /// No description provided for @yearReviewPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get yearReviewPrint;

  /// No description provided for @yearReviewSavedToExports.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device in your exports folder.'**
  String get yearReviewSavedToExports;

  /// No description provided for @yearReviewSectionGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get yearReviewSectionGrowth;

  /// No description provided for @yearReviewSectionMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get yearReviewSectionMilestones;

  /// No description provided for @yearReviewSectionSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get yearReviewSectionSchool;

  /// No description provided for @yearReviewSectionAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get yearReviewSectionAchievements;

  /// No description provided for @yearReviewSectionFunny.
  ///
  /// In en, this message translates to:
  /// **'Funny moments'**
  String get yearReviewSectionFunny;

  /// No description provided for @yearReviewSectionPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get yearReviewSectionPhotos;

  /// No description provided for @yearReviewSectionBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get yearReviewSectionBirthday;

  /// No description provided for @yearReviewSectionJournals.
  ///
  /// In en, this message translates to:
  /// **'Journal highlights'**
  String get yearReviewSectionJournals;

  /// No description provided for @yearReviewSectionHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get yearReviewSectionHealth;

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock journal'**
  String get unlockTitle;

  /// No description provided for @unlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to open private memories.'**
  String get unlockSubtitle;

  /// No description provided for @unlockPinLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get unlockPinLabel;

  /// No description provided for @unlockCta.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockCta;

  /// No description provided for @unlockBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get unlockBiometric;

  /// No description provided for @unlockPinWrong.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN.'**
  String get unlockPinWrong;

  /// No description provided for @securitySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get securitySettingsTitle;

  /// No description provided for @securityAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get securityAppLock;

  /// No description provided for @securityConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get securityConfirmPin;

  /// No description provided for @securityCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get securityCurrentPin;

  /// No description provided for @securityNewPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get securityNewPin;

  /// No description provided for @securityChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get securityChangePin;

  /// No description provided for @securityRemovePin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get securityRemovePin;

  /// No description provided for @securityPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match.'**
  String get securityPinMismatch;

  /// No description provided for @securityPinSet.
  ///
  /// In en, this message translates to:
  /// **'PIN is set.'**
  String get securityPinSet;

  /// No description provided for @securityPinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN updated.'**
  String get securityPinChanged;

  /// No description provided for @securityPinRemoved.
  ///
  /// In en, this message translates to:
  /// **'PIN removed.'**
  String get securityPinRemoved;

  /// No description provided for @securityDisableBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Disable biometrics'**
  String get securityDisableBiometrics;

  /// No description provided for @securityBiometricsHint.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Face ID or fingerprint. Falls back to PIN.'**
  String get securityBiometricsHint;

  /// No description provided for @securityAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get securityAutoLock;

  /// No description provided for @securityAutoLockImmediate.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get securityAutoLockImmediate;

  /// No description provided for @securityAutoLock1m.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get securityAutoLock1m;

  /// No description provided for @securityAutoLock5m.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get securityAutoLock5m;

  /// No description provided for @securityAutoLock15m.
  ///
  /// In en, this message translates to:
  /// **'After 15 minutes'**
  String get securityAutoLock15m;

  /// No description provided for @securityLockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock now'**
  String get securityLockNow;

  /// No description provided for @securityEncryptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Local encryption'**
  String get securityEncryptionTitle;

  /// No description provided for @securityEncryptionBody.
  ///
  /// In en, this message translates to:
  /// **'Your database is encrypted on this device. The encryption key is stored in the system keychain and never leaves the phone.'**
  String get securityEncryptionBody;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupTitle;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an encrypted offline backup of journals, photos, and health records.'**
  String get backupSubtitle;

  /// No description provided for @backupPassword.
  ///
  /// In en, this message translates to:
  /// **'Backup password'**
  String get backupPassword;

  /// No description provided for @backupPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get backupPasswordConfirm;

  /// No description provided for @backupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get backupCreate;

  /// No description provided for @backupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup created.'**
  String get backupCreated;

  /// No description provided for @backupRestoreCta.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestoreCta;

  /// No description provided for @backupHistory.
  ///
  /// In en, this message translates to:
  /// **'Local backups'**
  String get backupHistory;

  /// No description provided for @backupHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No local backups yet.'**
  String get backupHistoryEmpty;

  /// No description provided for @backupStagePreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing…'**
  String get backupStagePreparing;

  /// No description provided for @backupStageDatabase.
  ///
  /// In en, this message translates to:
  /// **'Snapshotting database…'**
  String get backupStageDatabase;

  /// No description provided for @backupStageMedia.
  ///
  /// In en, this message translates to:
  /// **'Collecting photos & documents…'**
  String get backupStageMedia;

  /// No description provided for @backupStageArchive.
  ///
  /// In en, this message translates to:
  /// **'Building archive…'**
  String get backupStageArchive;

  /// No description provided for @backupStageEncrypting.
  ///
  /// In en, this message translates to:
  /// **'Encrypting…'**
  String get backupStageEncrypting;

  /// No description provided for @backupStageSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get backupStageSaving;

  /// No description provided for @backupStageComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get backupStageComplete;

  /// No description provided for @backupStageFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupStageFailed;

  /// No description provided for @cloudBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud backups'**
  String get cloudBackupTitle;

  /// No description provided for @cloudBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional. Upload already-encrypted backups to your own cloud account. The app never requires cloud.'**
  String get cloudBackupSubtitle;

  /// No description provided for @cloudBackupConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get cloudBackupConnect;

  /// No description provided for @cloudBackupDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get cloudBackupDisconnect;

  /// No description provided for @cloudBackupConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get cloudBackupConnected;

  /// No description provided for @cloudBackupNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured in this build'**
  String get cloudBackupNotConfigured;

  /// No description provided for @cloudBackupUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get cloudBackupUnsupported;

  /// No description provided for @cloudBackupUploadLatest.
  ///
  /// In en, this message translates to:
  /// **'Upload latest local backup'**
  String get cloudBackupUploadLatest;

  /// No description provided for @cloudBackupUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded to cloud.'**
  String get cloudBackupUploaded;

  /// No description provided for @cloudBackupRemoteEmpty.
  ///
  /// In en, this message translates to:
  /// **'No remote backups yet.'**
  String get cloudBackupRemoteEmpty;

  /// No description provided for @cloudBackupRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get cloudBackupRefresh;

  /// No description provided for @cloudBackupDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get cloudBackupDownload;

  /// No description provided for @cloudBackupDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get cloudBackupDelete;

  /// No description provided for @cloudBackupDeleted.
  ///
  /// In en, this message translates to:
  /// **'Remote backup deleted.'**
  String get cloudBackupDeleted;

  /// No description provided for @cloudBackupDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded. You can restore it from the Restore screen.'**
  String get cloudBackupDownloaded;

  /// No description provided for @cloudProviderGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get cloudProviderGoogleDrive;

  /// No description provided for @cloudProviderOneDrive.
  ///
  /// In en, this message translates to:
  /// **'OneDrive'**
  String get cloudProviderOneDrive;

  /// No description provided for @cloudProviderDropbox.
  ///
  /// In en, this message translates to:
  /// **'Dropbox'**
  String get cloudProviderDropbox;

  /// No description provided for @cloudProviderICloud.
  ///
  /// In en, this message translates to:
  /// **'iCloud'**
  String get cloudProviderICloud;

  /// No description provided for @cloudProviderLocal.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get cloudProviderLocal;

  /// No description provided for @restoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreTitle;

  /// No description provided for @restoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an encrypted .sdjbackup file. Your current data can be safety-backed up first.'**
  String get restoreSubtitle;

  /// No description provided for @restorePick.
  ///
  /// In en, this message translates to:
  /// **'Choose backup file'**
  String get restorePick;

  /// No description provided for @restoreValidate.
  ///
  /// In en, this message translates to:
  /// **'Validate backup'**
  String get restoreValidate;

  /// No description provided for @restorePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup summary'**
  String get restorePreviewTitle;

  /// No description provided for @restorePreviewChildren.
  ///
  /// In en, this message translates to:
  /// **'{count} children'**
  String restorePreviewChildren(int count);

  /// No description provided for @restorePreviewAssets.
  ///
  /// In en, this message translates to:
  /// **'{count} media files'**
  String restorePreviewAssets(int count);

  /// No description provided for @restorePreviewSchema.
  ///
  /// In en, this message translates to:
  /// **'Schema version {version}'**
  String restorePreviewSchema(int version);

  /// No description provided for @restorePreviewApp.
  ///
  /// In en, this message translates to:
  /// **'App {version}'**
  String restorePreviewApp(String version);

  /// No description provided for @restoreSafetyPassword.
  ///
  /// In en, this message translates to:
  /// **'Safety backup password (optional)'**
  String get restoreSafetyPassword;

  /// No description provided for @restoreSafetyPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Creates a backup of current data before overwrite.'**
  String get restoreSafetyPasswordHint;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will replace journals, photos, and settings on this device with the backup.'**
  String get restoreConfirmBody;

  /// No description provided for @restoreConfirmCta.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreConfirmCta;

  /// No description provided for @restoreCommit.
  ///
  /// In en, this message translates to:
  /// **'Restore now'**
  String get restoreCommit;

  /// No description provided for @restoreRestartRequired.
  ///
  /// In en, this message translates to:
  /// **'Restore finished. Please fully close and reopen the app.'**
  String get restoreRestartRequired;

  /// No description provided for @restoreStageReading.
  ///
  /// In en, this message translates to:
  /// **'Reading backup…'**
  String get restoreStageReading;

  /// No description provided for @restoreStageDecrypting.
  ///
  /// In en, this message translates to:
  /// **'Decrypting…'**
  String get restoreStageDecrypting;

  /// No description provided for @restoreStageValidating.
  ///
  /// In en, this message translates to:
  /// **'Checking integrity…'**
  String get restoreStageValidating;

  /// No description provided for @restoreStagePreview.
  ///
  /// In en, this message translates to:
  /// **'Ready to preview'**
  String get restoreStagePreview;

  /// No description provided for @restoreStageSafety.
  ///
  /// In en, this message translates to:
  /// **'Creating safety backup…'**
  String get restoreStageSafety;

  /// No description provided for @restoreStageRestoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring files…'**
  String get restoreStageRestoring;

  /// No description provided for @restoreStageMigrating.
  ///
  /// In en, this message translates to:
  /// **'Running migrations…'**
  String get restoreStageMigrating;

  /// No description provided for @restoreStageRebuilding.
  ///
  /// In en, this message translates to:
  /// **'Rebuilding reminders…'**
  String get restoreStageRebuilding;

  /// No description provided for @restoreStageComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get restoreStageComplete;

  /// No description provided for @restoreStageFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get restoreStageFailed;

  /// No description provided for @stateLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get stateLoading;

  /// No description provided for @stateSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get stateSaveProgress;

  /// No description provided for @stateSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get stateSaveSuccess;

  /// No description provided for @stateSaveFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Please try again.'**
  String get stateSaveFailure;

  /// No description provided for @stateNoSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No matching records.'**
  String get stateNoSearchResults;

  /// No description provided for @statePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission is required to continue.'**
  String get statePermissionDenied;

  /// No description provided for @stateNotificationDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. You can enable them in system settings.'**
  String get stateNotificationDenied;

  /// No description provided for @stateMigration.
  ///
  /// In en, this message translates to:
  /// **'Updating your journal…'**
  String get stateMigration;

  /// No description provided for @stateStorageAlmostFull.
  ///
  /// In en, this message translates to:
  /// **'Storage is almost full. Free up space or clean exports.'**
  String get stateStorageAlmostFull;

  /// No description provided for @storageTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storageTitle;

  /// No description provided for @storageTotal.
  ///
  /// In en, this message translates to:
  /// **'Using {size}'**
  String storageTotal(String size);

  /// No description provided for @storageAlmostFull.
  ///
  /// In en, this message translates to:
  /// **'Storage is getting full on this device.'**
  String get storageAlmostFull;

  /// No description provided for @storageFileCount.
  ///
  /// In en, this message translates to:
  /// **'{count} files'**
  String storageFileCount(int count);

  /// No description provided for @storageOrphans.
  ///
  /// In en, this message translates to:
  /// **'Orphan media'**
  String get storageOrphans;

  /// No description provided for @storageOrphanCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items need attention'**
  String storageOrphanCount(int count);

  /// No description provided for @storageExports.
  ///
  /// In en, this message translates to:
  /// **'Generated PDFs'**
  String get storageExports;

  /// No description provided for @storageExportCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exports kept'**
  String storageExportCount(int count);

  /// No description provided for @storageCleanupTemp.
  ///
  /// In en, this message translates to:
  /// **'Clean temporary files'**
  String get storageCleanupTemp;

  /// No description provided for @storageCleanupExports.
  ///
  /// In en, this message translates to:
  /// **'Remove older PDF exports'**
  String get storageCleanupExports;

  /// No description provided for @storageCleanupOrphans.
  ///
  /// In en, this message translates to:
  /// **'Remove orphan media'**
  String get storageCleanupOrphans;

  /// No description provided for @storageTempCleaned.
  ///
  /// In en, this message translates to:
  /// **'Temporary files cleaned.'**
  String get storageTempCleaned;

  /// No description provided for @storageExportsCleaned.
  ///
  /// In en, this message translates to:
  /// **'Removed {count} older exports.'**
  String storageExportsCleaned(int count);

  /// No description provided for @storageOrphansCleaned.
  ///
  /// In en, this message translates to:
  /// **'Removed {count} orphan media items.'**
  String storageOrphansCleaned(int count);

  /// No description provided for @storageCatDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get storageCatDatabase;

  /// No description provided for @storageCatImages.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get storageCatImages;

  /// No description provided for @storageCatThumbnails.
  ///
  /// In en, this message translates to:
  /// **'Thumbnails'**
  String get storageCatThumbnails;

  /// No description provided for @storageCatDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get storageCatDocuments;

  /// No description provided for @storageCatPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF exports'**
  String get storageCatPdf;

  /// No description provided for @storageCatAlbumImages.
  ///
  /// In en, this message translates to:
  /// **'Album images'**
  String get storageCatAlbumImages;

  /// No description provided for @storageCatBackups.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get storageCatBackups;

  /// No description provided for @storageCatTemp.
  ///
  /// In en, this message translates to:
  /// **'Temporary'**
  String get storageCatTemp;

  /// No description provided for @birthdaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Birthdays'**
  String get birthdaysTitle;

  /// No description provided for @birthdayDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthdayDetailTitle;

  /// No description provided for @addBirthday.
  ///
  /// In en, this message translates to:
  /// **'Add birthday'**
  String get addBirthday;

  /// No description provided for @editBirthday.
  ///
  /// In en, this message translates to:
  /// **'Edit birthday'**
  String get editBirthday;

  /// No description provided for @birthdayAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get birthdayAge;

  /// No description provided for @birthdayDate.
  ///
  /// In en, this message translates to:
  /// **'Birthday date'**
  String get birthdayDate;

  /// No description provided for @birthdayLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get birthdayLocation;

  /// No description provided for @birthdayTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get birthdayTheme;

  /// No description provided for @birthdayFavoriteGift.
  ///
  /// In en, this message translates to:
  /// **'Favorite gift'**
  String get birthdayFavoriteGift;

  /// No description provided for @birthdayGuests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get birthdayGuests;

  /// No description provided for @birthdayParentMessage.
  ///
  /// In en, this message translates to:
  /// **'Parent message'**
  String get birthdayParentMessage;

  /// No description provided for @birthdayNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get birthdayNotes;

  /// No description provided for @birthdayInterview.
  ///
  /// In en, this message translates to:
  /// **'Annual interview'**
  String get birthdayInterview;

  /// No description provided for @birthdayInterviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Birthday interview'**
  String get birthdayInterviewTitle;

  /// No description provided for @birthdayCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare by age'**
  String get birthdayCompareTitle;

  /// No description provided for @birthdayAlbumCreate.
  ///
  /// In en, this message translates to:
  /// **'Create birthday album'**
  String get birthdayAlbumCreate;

  /// No description provided for @birthdayAlbumReady.
  ///
  /// In en, this message translates to:
  /// **'Birthday album ready.'**
  String get birthdayAlbumReady;

  /// No description provided for @birthdayPdfGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate birthday PDF'**
  String get birthdayPdfGenerate;

  /// No description provided for @birthdayPdfReady.
  ///
  /// In en, this message translates to:
  /// **'Birthday PDF ready.'**
  String get birthdayPdfReady;

  /// No description provided for @birthdayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No birthday memories yet.'**
  String get birthdayEmpty;

  /// No description provided for @birthdayEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Capture each year’s celebration and interview answers.'**
  String get birthdayEmptyHint;

  /// No description provided for @birthdayQFavoriteFood.
  ///
  /// In en, this message translates to:
  /// **'Favorite food?'**
  String get birthdayQFavoriteFood;

  /// No description provided for @birthdayQFavoriteColor.
  ///
  /// In en, this message translates to:
  /// **'Favorite color?'**
  String get birthdayQFavoriteColor;

  /// No description provided for @birthdayQFavoriteCartoon.
  ///
  /// In en, this message translates to:
  /// **'Favorite cartoon?'**
  String get birthdayQFavoriteCartoon;

  /// No description provided for @birthdayQFavoriteBook.
  ///
  /// In en, this message translates to:
  /// **'Favorite book?'**
  String get birthdayQFavoriteBook;

  /// No description provided for @birthdayQFavoriteGame.
  ///
  /// In en, this message translates to:
  /// **'Favorite game?'**
  String get birthdayQFavoriteGame;

  /// No description provided for @birthdayQFavoriteFriend.
  ///
  /// In en, this message translates to:
  /// **'Favorite friend?'**
  String get birthdayQFavoriteFriend;

  /// No description provided for @birthdayQWantToBe.
  ///
  /// In en, this message translates to:
  /// **'What do you want to be?'**
  String get birthdayQWantToBe;

  /// No description provided for @birthdayQMakesHappy.
  ///
  /// In en, this message translates to:
  /// **'What makes you happy?'**
  String get birthdayQMakesHappy;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @addFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add favorite'**
  String get addFavorite;

  /// No description provided for @editFavorite.
  ///
  /// In en, this message translates to:
  /// **'Edit favorite'**
  String get editFavorite;

  /// No description provided for @favoriteCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get favoriteCategory;

  /// No description provided for @favoriteValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get favoriteValue;

  /// No description provided for @favoriteStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get favoriteStartDate;

  /// No description provided for @favoriteEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date (optional)'**
  String get favoriteEndDate;

  /// No description provided for @favoriteNotes.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get favoriteNotes;

  /// No description provided for @favoriteEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet.'**
  String get favoriteEmpty;

  /// No description provided for @favoriteEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Track favorite food, colors, books, and more over the years.'**
  String get favoriteEmptyHint;

  /// No description provided for @favoriteCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get favoriteCurrent;

  /// No description provided for @favoriteHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get favoriteHistory;

  /// No description provided for @favoriteCatFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get favoriteCatFood;

  /// No description provided for @favoriteCatColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get favoriteCatColor;

  /// No description provided for @favoriteCatCartoon.
  ///
  /// In en, this message translates to:
  /// **'Cartoon'**
  String get favoriteCatCartoon;

  /// No description provided for @favoriteCatBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get favoriteCatBook;

  /// No description provided for @favoriteCatGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get favoriteCatGame;

  /// No description provided for @favoriteCatFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get favoriteCatFriend;

  /// No description provided for @searchTypeBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get searchTypeBirthday;

  /// No description provided for @searchTypeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get searchTypeFavorite;

  /// No description provided for @addGroupMemoriesExtra.
  ///
  /// In en, this message translates to:
  /// **'Birthdays & favorites'**
  String get addGroupMemoriesExtra;

  /// No description provided for @addBirthdaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Party, gifts, and annual interview'**
  String get addBirthdaySubtitle;

  /// No description provided for @addFavoriteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Food, color, cartoon, book, game, friend'**
  String get addFavoriteSubtitle;

  /// No description provided for @interestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interestsTitle;

  /// No description provided for @addInterest.
  ///
  /// In en, this message translates to:
  /// **'Add interest'**
  String get addInterest;

  /// No description provided for @editInterest.
  ///
  /// In en, this message translates to:
  /// **'Edit interest'**
  String get editInterest;

  /// No description provided for @interestName.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interestName;

  /// No description provided for @interestFirstNoticed.
  ///
  /// In en, this message translates to:
  /// **'First noticed'**
  String get interestFirstNoticed;

  /// No description provided for @interestLevel.
  ///
  /// In en, this message translates to:
  /// **'Interest level'**
  String get interestLevel;

  /// No description provided for @interestNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get interestNotes;

  /// No description provided for @interestEmpty.
  ///
  /// In en, this message translates to:
  /// **'No interests yet.'**
  String get interestEmpty;

  /// No description provided for @interestEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Track drawing, sports, music, and more as they grow.'**
  String get interestEmptyHint;

  /// No description provided for @interestLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String interestLevelLabel(int level);

  /// No description provided for @familyEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Family events'**
  String get familyEventsTitle;

  /// No description provided for @addFamilyEvent.
  ///
  /// In en, this message translates to:
  /// **'Add family event'**
  String get addFamilyEvent;

  /// No description provided for @editFamilyEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit family event'**
  String get editFamilyEvent;

  /// No description provided for @familyEventType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get familyEventType;

  /// No description provided for @familyEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get familyEventTitle;

  /// No description provided for @familyEventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get familyEventDate;

  /// No description provided for @familyEventLocation.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get familyEventLocation;

  /// No description provided for @familyEventStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get familyEventStory;

  /// No description provided for @familyEventReaction.
  ///
  /// In en, this message translates to:
  /// **'Child’s reaction'**
  String get familyEventReaction;

  /// No description provided for @familyEventEmpty.
  ///
  /// In en, this message translates to:
  /// **'No family events yet.'**
  String get familyEventEmpty;

  /// No description provided for @familyEventEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Capture Eid, weddings, visits, and special moments.'**
  String get familyEventEmptyHint;

  /// No description provided for @familyEventAlbumCreate.
  ///
  /// In en, this message translates to:
  /// **'Create event album'**
  String get familyEventAlbumCreate;

  /// No description provided for @familyEventAlbumReady.
  ///
  /// In en, this message translates to:
  /// **'Family event album ready.'**
  String get familyEventAlbumReady;

  /// No description provided for @familyEventTypeEid.
  ///
  /// In en, this message translates to:
  /// **'Eid'**
  String get familyEventTypeEid;

  /// No description provided for @familyEventTypeWedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get familyEventTypeWedding;

  /// No description provided for @familyEventTypeVacation.
  ///
  /// In en, this message translates to:
  /// **'Family vacation'**
  String get familyEventTypeVacation;

  /// No description provided for @familyEventTypeGrandparent.
  ///
  /// In en, this message translates to:
  /// **'Grandparent visit'**
  String get familyEventTypeGrandparent;

  /// No description provided for @familyEventTypeSibling.
  ///
  /// In en, this message translates to:
  /// **'New sibling'**
  String get familyEventTypeSibling;

  /// No description provided for @familyEventTypeMoving.
  ///
  /// In en, this message translates to:
  /// **'Moving home'**
  String get familyEventTypeMoving;

  /// No description provided for @familyEventTypeFirstFlight.
  ///
  /// In en, this message translates to:
  /// **'First flight'**
  String get familyEventTypeFirstFlight;

  /// No description provided for @familyEventTypeFirstBeach.
  ///
  /// In en, this message translates to:
  /// **'First beach'**
  String get familyEventTypeFirstBeach;

  /// No description provided for @familyEventTypeGathering.
  ///
  /// In en, this message translates to:
  /// **'Gathering'**
  String get familyEventTypeGathering;

  /// No description provided for @familyEventTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get familyEventTypeOther;

  /// No description provided for @tripsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips & places'**
  String get tripsTitle;

  /// No description provided for @addTrip.
  ///
  /// In en, this message translates to:
  /// **'Add trip'**
  String get addTrip;

  /// No description provided for @editTrip.
  ///
  /// In en, this message translates to:
  /// **'Edit trip'**
  String get editTrip;

  /// No description provided for @tripType.
  ///
  /// In en, this message translates to:
  /// **'Trip type'**
  String get tripType;

  /// No description provided for @tripTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tripTitle;

  /// No description provided for @tripPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get tripPlace;

  /// No description provided for @tripStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get tripStartDate;

  /// No description provided for @tripEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date (optional)'**
  String get tripEndDate;

  /// No description provided for @tripStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get tripStory;

  /// No description provided for @tripReaction.
  ///
  /// In en, this message translates to:
  /// **'Child’s reaction'**
  String get tripReaction;

  /// No description provided for @tripEmpty.
  ///
  /// In en, this message translates to:
  /// **'No trips yet.'**
  String get tripEmpty;

  /// No description provided for @tripEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Save vacations, first flights, beaches, and places visited.'**
  String get tripEmptyHint;

  /// No description provided for @tripAlbumCreate.
  ///
  /// In en, this message translates to:
  /// **'Create trip album'**
  String get tripAlbumCreate;

  /// No description provided for @tripAlbumReady.
  ///
  /// In en, this message translates to:
  /// **'Trip album ready.'**
  String get tripAlbumReady;

  /// No description provided for @tripTypeVacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation'**
  String get tripTypeVacation;

  /// No description provided for @tripTypeFirstFlight.
  ///
  /// In en, this message translates to:
  /// **'First flight'**
  String get tripTypeFirstFlight;

  /// No description provided for @tripTypeFirstBeach.
  ///
  /// In en, this message translates to:
  /// **'First beach'**
  String get tripTypeFirstBeach;

  /// No description provided for @tripTypePlaceVisit.
  ///
  /// In en, this message translates to:
  /// **'Place visit'**
  String get tripTypePlaceVisit;

  /// No description provided for @tripTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get tripTypeOther;

  /// No description provided for @timelineTypeFamilyEvent.
  ///
  /// In en, this message translates to:
  /// **'Family event'**
  String get timelineTypeFamilyEvent;

  /// No description provided for @timelineTypeTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get timelineTypeTrip;

  /// No description provided for @searchTypeInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get searchTypeInterest;

  /// No description provided for @searchTypeFamilyEvent.
  ///
  /// In en, this message translates to:
  /// **'Family event'**
  String get searchTypeFamilyEvent;

  /// No description provided for @searchTypeTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get searchTypeTrip;

  /// No description provided for @homeInterests.
  ///
  /// In en, this message translates to:
  /// **'Growing interests'**
  String get homeInterests;

  /// No description provided for @homeFamilyEvents.
  ///
  /// In en, this message translates to:
  /// **'Family moments'**
  String get homeFamilyEvents;

  /// No description provided for @homeTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips & places'**
  String get homeTrips;

  /// No description provided for @addInterestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hobbies and passions'**
  String get addInterestSubtitle;

  /// No description provided for @addFamilyEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Eid, wedding, visits, firsts'**
  String get addFamilyEventSubtitle;

  /// No description provided for @addTripSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Travel, places, beach, flights'**
  String get addTripSubtitle;
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
