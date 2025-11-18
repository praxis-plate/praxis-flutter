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
}
