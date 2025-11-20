// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Codium';

  @override
  String get displaySignUp => 'Sign Up';

  @override
  String get labelPhoneNumber => 'Phone number:';

  @override
  String get next => 'Next';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelPassword => 'Password';

  @override
  String get errorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get displayAlreadyHaveAnAccount => 'Already have an account?';

  @override
  String get displaySignIn => 'Sign In';

  @override
  String get displayEmailHint => 'example@gmail.com';

  @override
  String get displayPasswordHint => '•••••••••';

  @override
  String get displayDontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get navigationMainTitle => 'Main';

  @override
  String get navigationLearningTitle => 'Learning';

  @override
  String get navigationProfileTitle => 'Profile';

  @override
  String get mainTitle => 'Main';

  @override
  String get balance => 'Balance';

  @override
  String get recommend => 'Recommend';

  @override
  String get courses => 'Courses';

  @override
  String get searchCourse => 'Search course...';

  @override
  String get yourBalance => 'Your balance:';

  @override
  String get learningTitle => 'Learning';

  @override
  String get streak => 'Streak';

  @override
  String get points => 'Points';

  @override
  String get solved => 'Solved';

  @override
  String get active => 'Active';

  @override
  String get passed => 'Passed';

  @override
  String get noData => 'No data';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSetRussian => 'Russian';

  @override
  String get profileSetDarkMode => 'Dark theme';

  @override
  String get profileLogOut => 'Sign out';

  @override
  String get errorEmailEmpty => 'Email is required';

  @override
  String get errorEmailInvalid => 'Invalid email format';

  @override
  String get errorPasswordEmpty => 'Password is required';

  @override
  String get errorPasswordInvalid => 'Password must be at least 8 characters, at least one letter and one number';

  @override
  String get errorNetworkTimeout => 'Connection timeout. Please check your internet connection.';

  @override
  String get errorNetworkNoInternet => 'No internet connection. Please check your network settings.';

  @override
  String get errorNetworkGeneral => 'Network error. Please try again.';

  @override
  String get errorFileNotFound => 'File not found. It may have been moved or deleted.';

  @override
  String get errorFilePermissionDenied => 'Permission denied. Please grant the necessary permissions.';

  @override
  String get errorFileInsufficientStorage => 'Insufficient storage. Please free up space and try again.';

  @override
  String get errorFileCorrupted => 'File is corrupted. Please try a different file.';

  @override
  String get errorFileGeneral => 'File error. Please try again.';

  @override
  String get errorDatabaseLocked => 'Database is busy. Please try again in a moment.';

  @override
  String get errorDatabaseConstraint => 'Data validation error. Please check your input.';

  @override
  String get errorDatabaseMigration => 'Database update failed. Please restart the app.';

  @override
  String get errorDatabaseGeneral => 'Database error. Please try again.';

  @override
  String get errorValidationInvalid => 'Invalid data. Please check your input.';

  @override
  String get errorApiUnauthorized => 'Authentication failed. Please check your API credentials.';

  @override
  String get errorApiForbidden => 'Access denied. You do not have permission for this action.';

  @override
  String get errorApiNotFound => 'Resource not found. The data may no longer exist.';

  @override
  String get errorApiGeneral => 'API error. Please try again.';

  @override
  String get errorRateLimitExceeded => 'Rate limit exceeded. Please wait a moment.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';
}
