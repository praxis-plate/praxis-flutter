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

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkipForNow => 'Skip for now';

  @override
  String get onboardingTitle1 => 'AI Smart Reader';

  @override
  String get onboardingDescription1 => 'Transform any technical book into an interactive learning experience with AI-powered explanations';

  @override
  String get onboardingTitle2 => 'Read & Learn';

  @override
  String get onboardingDescription2 => 'Import your PDF books and read them with built-in text selection. Select any term to get instant AI explanations with examples';

  @override
  String get onboardingTitle3 => 'Track Progress';

  @override
  String get onboardingDescription3 => 'Your reading progress is automatically saved. Create bookmarks, view explanation history, and pick up right where you left off';

  @override
  String get onboardingLanguageTitle => 'Choose Your Language';

  @override
  String get onboardingLanguageDescription => 'Select a programming language to get started with relevant courses';

  @override
  String get onboardingErrorUnknown => 'Unknown error';

  @override
  String get libraryTitle => 'PDF Library';

  @override
  String get libraryNoBooksFound => 'No books found';

  @override
  String get libraryNoPdfs => 'No PDFs in library';

  @override
  String get libraryTapToImport => 'Tap + to import your first PDF';

  @override
  String get libraryErrorLoading => 'Error loading library';

  @override
  String get libraryRetry => 'Retry';

  @override
  String get librarySearchHint => 'Search by title or author...';

  @override
  String get historyTitle => 'Explanation History';

  @override
  String get historyNoExplanationsFound => 'No explanations found';

  @override
  String get historyNoHistory => 'No explanation history';

  @override
  String get historyStartReading => 'Start reading and ask for explanations';

  @override
  String get historyErrorLoading => 'Error loading history';

  @override
  String get historyRetry => 'Retry';

  @override
  String get historySearchHint => 'Search explanations...';

  @override
  String get historyUnknownPdf => 'Unknown PDF';

  @override
  String get historyExplanation => 'explanation';

  @override
  String get historyExplanations => 'explanations';

  @override
  String get historyDeleteTitle => 'Delete Explanation';

  @override
  String get historyDeleteMessage => 'Are you sure you want to delete this explanation from history?';

  @override
  String get historyDeleteCancel => 'Cancel';

  @override
  String get historyDeleteConfirm => 'Delete';

  @override
  String historyNavigateTo(Object page, Object text) {
    return 'Navigate to $text on page $page';
  }

  @override
  String get pdfReaderTitle => 'PDF Reader';

  @override
  String get pdfReaderErrorLoading => 'Error loading PDF';

  @override
  String get pdfReaderLazyLoading => 'Lazy loading enabled for large PDF';

  @override
  String get pdfReaderNoPdfLoaded => 'No PDF loaded';

  @override
  String pdfReaderPageIndicator(Object current, Object total) {
    return 'Page $current of $total';
  }

  @override
  String get pdfReaderAddBookmarkTitle => 'Add Bookmark';

  @override
  String pdfReaderAddBookmarkPage(Object page) {
    return 'Page $page';
  }

  @override
  String get pdfReaderAddBookmarkCancel => 'Cancel';

  @override
  String get pdfReaderAddBookmarkAdd => 'Add';

  @override
  String get pdfReaderBookmarkAdded => 'Bookmark added';

  @override
  String get bookmarksTitle => 'Bookmarks';

  @override
  String get bookmarksNoBookmarks => 'No bookmarks yet';

  @override
  String get bookmarksTapToAdd => 'Tap the bookmark icon to add one';

  @override
  String get bookmarksErrorLoading => 'Error loading bookmarks';

  @override
  String get bookmarksRetry => 'Retry';

  @override
  String get bookmarksDeleted => 'Bookmark deleted';

  @override
  String bookmarksErrorDeleting(Object error) {
    return 'Error deleting bookmark: $error';
  }

  @override
  String bookmarksPage(Object page) {
    return 'Page $page';
  }

  @override
  String get explanationGenerating => 'Generating explanation...';

  @override
  String explanationSelected(Object text) {
    return 'Selected: \"$text\"';
  }

  @override
  String get explanationTitle => 'Explanation';

  @override
  String get explanationSources => 'Sources';

  @override
  String get explanationNoInternet => 'No Internet Connection';

  @override
  String get explanationError => 'Error';

  @override
  String get explanationRetry => 'Retry';

  @override
  String pdfBookPages(Object current, Object total) {
    return '$current / $total pages';
  }

  @override
  String get pdfBookOpen => 'Open';

  @override
  String get pdfBookAddToFavorites => 'Add to favorites';

  @override
  String get pdfBookRemoveFromFavorites => 'Remove from favorites';

  @override
  String get pdfBookRename => 'Rename';

  @override
  String get pdfBookDelete => 'Delete';

  @override
  String get pdfBookRenameTitle => 'Rename PDF';

  @override
  String get pdfBookRenameCancel => 'Cancel';

  @override
  String get pdfBookRenameSave => 'Save';

  @override
  String get pdfBookDeleteTitle => 'Delete PDF';

  @override
  String pdfBookDeleteMessage(Object title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get pdfBookDeleteCancel => 'Cancel';

  @override
  String get pdfBookDeleteConfirm => 'Delete';

  @override
  String get courseDetailsUnknown => 'Unknown';

  @override
  String courseDetailsLessons(Object count) {
    return '$count уроков';
  }

  @override
  String get courseDetailsGet => 'Get';

  @override
  String get courseDetailsContinue => 'Continue';
}
