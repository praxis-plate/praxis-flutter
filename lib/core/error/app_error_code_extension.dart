import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension AppErrorCodeExtension on AppErrorCode {
  String localizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case AppErrorCode.networkTimeout:
        return l10n.errorNetworkTimeout;
      case AppErrorCode.networkNoInternet:
        return l10n.errorNetworkNoInternet;
      case AppErrorCode.networkGeneral:
        return l10n.errorNetworkGeneral;

      case AppErrorCode.fileNotFound:
        return l10n.errorFileNotFound;
      case AppErrorCode.filePermissionDenied:
        return l10n.errorFilePermissionDenied;
      case AppErrorCode.fileInsufficientStorage:
        return l10n.errorFileInsufficientStorage;
      case AppErrorCode.fileCorrupted:
        return l10n.errorFileCorrupted;
      case AppErrorCode.fileGeneral:
        return l10n.errorFileGeneral;

      case AppErrorCode.databaseLocked:
        return l10n.errorDatabaseLocked;
      case AppErrorCode.databaseConstraint:
        return l10n.errorDatabaseConstraint;
      case AppErrorCode.databaseMigration:
        return l10n.errorDatabaseMigration;
      case AppErrorCode.databaseGeneral:
        return l10n.errorDatabaseGeneral;

      case AppErrorCode.validationInvalid:
        return l10n.errorValidationInvalid;

      case AppErrorCode.apiUnauthorized:
        return l10n.errorApiUnauthorized;
      case AppErrorCode.apiForbidden:
        return l10n.errorApiForbidden;
      case AppErrorCode.apiNotFound:
        return l10n.errorApiNotFound;
      case AppErrorCode.apiGeneral:
        return l10n.errorApiGeneral;

      case AppErrorCode.rateLimitExceeded:
        return l10n.errorRateLimitExceeded;

      case AppErrorCode.authUserNotFound:
        return l10n.errorAuthUserNotFound;
      case AppErrorCode.authInvalidCredentials:
        return l10n.errorAuthInvalidCredentials;
      case AppErrorCode.authUserAlreadyExists:
        return l10n.errorAuthUserAlreadyExists;
      case AppErrorCode.authFailedToCreateUser:
        return l10n.errorAuthFailedToCreateUser;

      case AppErrorCode.insufficientBalance:
        return l10n.errorInsufficientBalance;
      case AppErrorCode.courseNotPurchased:
        return l10n.errorCourseNotPurchased;
      case AppErrorCode.lessonNotUnlocked:
        return l10n.errorLessonNotUnlocked;

      case AppErrorCode.unknown:
        return l10n.errorUnknown;
    }
  }
}
