import 'package:codium/core/exceptions/app_error.dart';

class NetworkError extends AppError {
  const NetworkError.timeout({super.message})
    : super(code: AppErrorCode.networkTimeout, canRetry: true);

  const NetworkError.noInternet({super.message})
    : super(code: AppErrorCode.networkNoInternet, canRetry: true);

  const NetworkError.general({super.message})
    : super(code: AppErrorCode.networkGeneral, canRetry: true);
}

class FileSystemError extends AppError {
  const FileSystemError.notFound({super.message})
    : super(code: AppErrorCode.fileNotFound, canRetry: false);

  const FileSystemError.permissionDenied({super.message})
    : super(code: AppErrorCode.filePermissionDenied, canRetry: false);

  const FileSystemError.insufficientStorage({super.message})
    : super(code: AppErrorCode.fileInsufficientStorage, canRetry: false);

  const FileSystemError.corrupted({super.message})
    : super(code: AppErrorCode.fileCorrupted, canRetry: false);

  const FileSystemError.general({super.message})
    : super(code: AppErrorCode.fileGeneral, canRetry: false);
}

class DatabaseError extends AppError {
  const DatabaseError.locked({super.message})
    : super(code: AppErrorCode.databaseLocked, canRetry: true);

  const DatabaseError.constraint({super.message})
    : super(code: AppErrorCode.databaseConstraint, canRetry: false);

  const DatabaseError.migration({super.message})
    : super(code: AppErrorCode.databaseMigration, canRetry: false);

  const DatabaseError.general({super.message})
    : super(code: AppErrorCode.databaseGeneral, canRetry: true);
}

class ValidationError extends AppError {
  const ValidationError({super.message})
    : super(code: AppErrorCode.validationInvalid, canRetry: false);
}

class ApiError extends AppError {
  const ApiError.unauthorized({super.message})
    : super(code: AppErrorCode.apiUnauthorized, canRetry: false);

  const ApiError.forbidden({super.message})
    : super(code: AppErrorCode.apiForbidden, canRetry: false);

  const ApiError.notFound({super.message})
    : super(code: AppErrorCode.apiNotFound, canRetry: false);

  const ApiError.general({super.message})
    : super(code: AppErrorCode.apiGeneral, canRetry: true);
}

class RateLimitError extends AppError {
  const RateLimitError({super.message})
    : super(code: AppErrorCode.rateLimitExceeded, canRetry: true);
}

class UnknownError extends AppError {
  const UnknownError({super.message})
    : super(code: AppErrorCode.unknown, canRetry: false);
}
