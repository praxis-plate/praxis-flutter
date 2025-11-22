enum AppErrorCode {
  networkTimeout,
  networkNoInternet,
  networkGeneral,

  fileNotFound,
  filePermissionDenied,
  fileInsufficientStorage,
  fileCorrupted,
  fileGeneral,

  databaseLocked,
  databaseConstraint,
  databaseMigration,
  databaseGeneral,

  validationInvalid,

  apiUnauthorized,
  apiForbidden,
  apiNotFound,
  apiGeneral,

  rateLimitExceeded,

  unknown,
}

abstract class AppError implements Exception {
  final AppErrorCode code;
  final String? message;
  final bool canRetry;

  const AppError({required this.code, this.message, this.canRetry = false});

  @override
  String toString() => 'AppError(code: $code, message: $message)';
}
