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
