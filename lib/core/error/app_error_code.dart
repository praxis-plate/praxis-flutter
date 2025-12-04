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

  authUserNotFound,
  authInvalidCredentials,
  authUserAlreadyExists,
  authFailedToCreateUser,

  insufficientBalance,

  unknown,
}
