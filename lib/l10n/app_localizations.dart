import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// Codium
  ///
  /// In en, this message translates to:
  /// **'Codium'**
  String get appTitle;

  /// No description provided for @displaySignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get displaySignUp;

  /// No description provided for @labelPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number:'**
  String get labelPhoneNumber;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelPassword;

  /// No description provided for @errorPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsDoNotMatch;

  /// No description provided for @displayAlreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get displayAlreadyHaveAnAccount;

  /// No description provided for @displaySignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get displaySignIn;

  /// No description provided for @displayEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get displayEmailHint;

  /// No description provided for @displayPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'•••••••••'**
  String get displayPasswordHint;

  /// No description provided for @displayDontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get displayDontHaveAnAccount;

  /// No description provided for @navigationMainTitle.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get navigationMainTitle;

  /// No description provided for @navigationLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get navigationLearningTitle;

  /// No description provided for @navigationProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigationProfileTitle;

  /// No description provided for @mainTitle.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainTitle;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @recommend.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get recommend;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @searchCourse.
  ///
  /// In en, this message translates to:
  /// **'Search course...'**
  String get searchCourse;

  /// No description provided for @yourBalance.
  ///
  /// In en, this message translates to:
  /// **'Your balance:'**
  String get yourBalance;

  /// No description provided for @learningTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learningTitle;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @solved.
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get solved;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSetRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get profileSetRussian;

  /// No description provided for @profileSetDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get profileSetDarkMode;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileLogOut;

  /// No description provided for @errorEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get errorEmailEmpty;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errorPasswordEmpty;

  /// No description provided for @errorPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters, at least one letter and one number'**
  String get errorPasswordInvalid;

  /// No description provided for @errorNetworkTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please check your internet connection.'**
  String get errorNetworkTimeout;

  /// No description provided for @errorNetworkNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get errorNetworkNoInternet;

  /// No description provided for @errorNetworkGeneral.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get errorNetworkGeneral;

  /// No description provided for @errorFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found. It may have been moved or deleted.'**
  String get errorFileNotFound;

  /// No description provided for @errorFilePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Please grant the necessary permissions.'**
  String get errorFilePermissionDenied;

  /// No description provided for @errorFileInsufficientStorage.
  ///
  /// In en, this message translates to:
  /// **'Insufficient storage. Please free up space and try again.'**
  String get errorFileInsufficientStorage;

  /// No description provided for @errorFileCorrupted.
  ///
  /// In en, this message translates to:
  /// **'File is corrupted. Please try a different file.'**
  String get errorFileCorrupted;

  /// No description provided for @errorFileGeneral.
  ///
  /// In en, this message translates to:
  /// **'File error. Please try again.'**
  String get errorFileGeneral;

  /// No description provided for @errorDatabaseLocked.
  ///
  /// In en, this message translates to:
  /// **'Database is busy. Please try again in a moment.'**
  String get errorDatabaseLocked;

  /// No description provided for @errorDatabaseConstraint.
  ///
  /// In en, this message translates to:
  /// **'Data validation error. Please check your input.'**
  String get errorDatabaseConstraint;

  /// No description provided for @errorDatabaseMigration.
  ///
  /// In en, this message translates to:
  /// **'Database update failed. Please restart the app.'**
  String get errorDatabaseMigration;

  /// No description provided for @errorDatabaseGeneral.
  ///
  /// In en, this message translates to:
  /// **'Database error. Please try again.'**
  String get errorDatabaseGeneral;

  /// No description provided for @errorValidationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid data. Please check your input.'**
  String get errorValidationInvalid;

  /// No description provided for @errorApiUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please check your API credentials.'**
  String get errorApiUnauthorized;

  /// No description provided for @errorApiForbidden.
  ///
  /// In en, this message translates to:
  /// **'Access denied. You do not have permission for this action.'**
  String get errorApiForbidden;

  /// No description provided for @errorApiNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found. The data may no longer exist.'**
  String get errorApiNotFound;

  /// No description provided for @errorApiGeneral.
  ///
  /// In en, this message translates to:
  /// **'API error. Please try again.'**
  String get errorApiGeneral;

  /// No description provided for @errorRateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Rate limit exceeded. Please wait a moment.'**
  String get errorRateLimitExceeded;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingSkipForNow;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'AI Smart Reader'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Transform any technical book into an interactive learning experience with AI-powered explanations'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Read & Learn'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Import your PDF books and read them with built-in text selection. Select any term to get instant AI explanations with examples'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Your reading progress is automatically saved. Create bookmarks, view explanation history, and pick up right where you left off'**
  String get onboardingDescription3;

  /// No description provided for @onboardingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a programming language to get started with relevant courses'**
  String get onboardingLanguageDescription;

  /// No description provided for @onboardingErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get onboardingErrorUnknown;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF Library'**
  String get libraryTitle;

  /// No description provided for @libraryNoBooksFound.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get libraryNoBooksFound;

  /// No description provided for @libraryNoPdfs.
  ///
  /// In en, this message translates to:
  /// **'No PDFs in library'**
  String get libraryNoPdfs;

  /// No description provided for @libraryTapToImport.
  ///
  /// In en, this message translates to:
  /// **'Tap + to import your first PDF'**
  String get libraryTapToImport;

  /// No description provided for @libraryErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading library'**
  String get libraryErrorLoading;

  /// No description provided for @libraryRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get libraryRetry;

  /// No description provided for @librarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by title or author...'**
  String get librarySearchHint;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Explanation History'**
  String get historyTitle;

  /// No description provided for @historyNoExplanationsFound.
  ///
  /// In en, this message translates to:
  /// **'No explanations found'**
  String get historyNoExplanationsFound;

  /// No description provided for @historyNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No explanation history'**
  String get historyNoHistory;

  /// No description provided for @historyStartReading.
  ///
  /// In en, this message translates to:
  /// **'Start reading and ask for explanations'**
  String get historyStartReading;

  /// No description provided for @historyErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading history'**
  String get historyErrorLoading;

  /// No description provided for @historyRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get historyRetry;

  /// No description provided for @historySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search explanations...'**
  String get historySearchHint;

  /// No description provided for @historyUnknownPdf.
  ///
  /// In en, this message translates to:
  /// **'Unknown PDF'**
  String get historyUnknownPdf;

  /// No description provided for @historyExplanation.
  ///
  /// In en, this message translates to:
  /// **'explanation'**
  String get historyExplanation;

  /// No description provided for @historyExplanations.
  ///
  /// In en, this message translates to:
  /// **'explanations'**
  String get historyExplanations;

  /// No description provided for @historyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Explanation'**
  String get historyDeleteTitle;

  /// No description provided for @historyDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this explanation from history?'**
  String get historyDeleteMessage;

  /// No description provided for @historyDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get historyDeleteCancel;

  /// No description provided for @historyDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get historyDeleteConfirm;

  /// No description provided for @historyNavigateTo.
  ///
  /// In en, this message translates to:
  /// **'Navigate to {text} on page {page}'**
  String historyNavigateTo(Object page, Object text);

  /// No description provided for @pdfReaderTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF Reader'**
  String get pdfReaderTitle;

  /// No description provided for @pdfReaderErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading PDF'**
  String get pdfReaderErrorLoading;

  /// No description provided for @pdfReaderLazyLoading.
  ///
  /// In en, this message translates to:
  /// **'Lazy loading enabled for large PDF'**
  String get pdfReaderLazyLoading;

  /// No description provided for @pdfReaderNoPdfLoaded.
  ///
  /// In en, this message translates to:
  /// **'No PDF loaded'**
  String get pdfReaderNoPdfLoaded;

  /// No description provided for @pdfReaderPageIndicator.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pdfReaderPageIndicator(Object current, Object total);

  /// No description provided for @pdfReaderAddBookmarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get pdfReaderAddBookmarkTitle;

  /// No description provided for @pdfReaderAddBookmarkPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pdfReaderAddBookmarkPage(Object page);

  /// No description provided for @pdfReaderAddBookmarkCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pdfReaderAddBookmarkCancel;

  /// No description provided for @pdfReaderAddBookmarkAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get pdfReaderAddBookmarkAdd;

  /// No description provided for @pdfReaderBookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get pdfReaderBookmarkAdded;

  /// No description provided for @bookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksTitle;

  /// No description provided for @bookmarksNoBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get bookmarksNoBookmarks;

  /// No description provided for @bookmarksTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark icon to add one'**
  String get bookmarksTapToAdd;

  /// No description provided for @bookmarksErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading bookmarks'**
  String get bookmarksErrorLoading;

  /// No description provided for @bookmarksRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get bookmarksRetry;

  /// No description provided for @bookmarksDeleted.
  ///
  /// In en, this message translates to:
  /// **'Bookmark deleted'**
  String get bookmarksDeleted;

  /// No description provided for @bookmarksErrorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting bookmark: {error}'**
  String bookmarksErrorDeleting(Object error);

  /// No description provided for @bookmarksPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String bookmarksPage(Object page);

  /// No description provided for @explanationGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating explanation...'**
  String get explanationGenerating;

  /// No description provided for @explanationSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected: \"{text}\"'**
  String explanationSelected(Object text);

  /// No description provided for @explanationTitle.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanationTitle;

  /// No description provided for @explanationSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get explanationSources;

  /// No description provided for @explanationNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get explanationNoInternet;

  /// No description provided for @explanationError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get explanationError;

  /// No description provided for @explanationRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get explanationRetry;

  /// No description provided for @pdfBookPages.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} pages'**
  String pdfBookPages(Object current, Object total);

  /// No description provided for @pdfBookOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get pdfBookOpen;

  /// No description provided for @pdfBookAddToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get pdfBookAddToFavorites;

  /// No description provided for @pdfBookRemoveFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get pdfBookRemoveFromFavorites;

  /// No description provided for @pdfBookRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get pdfBookRename;

  /// No description provided for @pdfBookDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get pdfBookDelete;

  /// No description provided for @pdfBookRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename PDF'**
  String get pdfBookRenameTitle;

  /// No description provided for @pdfBookRenameCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pdfBookRenameCancel;

  /// No description provided for @pdfBookRenameSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get pdfBookRenameSave;

  /// No description provided for @pdfBookDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete PDF'**
  String get pdfBookDeleteTitle;

  /// No description provided for @pdfBookDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String pdfBookDeleteMessage(Object title);

  /// No description provided for @pdfBookDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pdfBookDeleteCancel;

  /// No description provided for @pdfBookDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get pdfBookDeleteConfirm;

  /// No description provided for @courseDetailsUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get courseDetailsUnknown;

  /// No description provided for @courseDetailsLessons.
  ///
  /// In en, this message translates to:
  /// **'{count} уроков'**
  String courseDetailsLessons(Object count);

  /// No description provided for @courseDetailsGet.
  ///
  /// In en, this message translates to:
  /// **'Get'**
  String get courseDetailsGet;

  /// No description provided for @courseDetailsContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get courseDetailsContinue;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
