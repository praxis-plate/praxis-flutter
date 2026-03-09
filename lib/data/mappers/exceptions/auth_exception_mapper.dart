import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/error/failure.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

class AuthExceptionMapper {
  static AppFailure map(Object error) {
    if (error is EmailAccountLoginException) {
      return switch (error.reason) {
        EmailAccountLoginExceptionReason.invalidCredentials => const AppFailure(
          code: AppErrorCode.authInvalidCredentials,
          message: 'Invalid email or password',
          canRetry: false,
        ),
        EmailAccountLoginExceptionReason.tooManyAttempts => const AppFailure(
          code: AppErrorCode.rateLimitExceeded,
          message: 'Rate limit exceeded',
          canRetry: true,
        ),
        EmailAccountLoginExceptionReason.unknown => const AppFailure(
          code: AppErrorCode.unknown,
          message: 'Unknown authentication error',
          canRetry: true,
        ),
      };
    }

    if (error is EmailAccountRequestException) {
      return switch (error.reason) {
        EmailAccountRequestExceptionReason.tooManyAttempts => const AppFailure(
          code: AppErrorCode.rateLimitExceeded,
          message: 'Rate limit exceeded',
          canRetry: true,
        ),
        EmailAccountRequestExceptionReason.policyViolation ||
        EmailAccountRequestExceptionReason.invalid ||
        EmailAccountRequestExceptionReason.expired => const AppFailure(
          code: AppErrorCode.validationInvalid,
          message: 'Invalid verification code',
          canRetry: false,
        ),
        EmailAccountRequestExceptionReason.unknown => const AppFailure(
          code: AppErrorCode.unknown,
          message: 'Unknown registration error',
          canRetry: true,
        ),
      };
    }

    if (error is EmailAccountPasswordResetException) {
      return switch (error.reason) {
        EmailAccountPasswordResetExceptionReason.tooManyAttempts =>
          const AppFailure(
            code: AppErrorCode.rateLimitExceeded,
            message: 'Rate limit exceeded',
            canRetry: true,
          ),
        EmailAccountPasswordResetExceptionReason.policyViolation ||
        EmailAccountPasswordResetExceptionReason.invalid ||
        EmailAccountPasswordResetExceptionReason.expired => const AppFailure(
          code: AppErrorCode.validationInvalid,
          message: 'Invalid verification code',
          canRetry: false,
        ),
        EmailAccountPasswordResetExceptionReason.unknown => const AppFailure(
          code: AppErrorCode.unknown,
          message: 'Unknown password reset error',
          canRetry: true,
        ),
      };
    }

    if (error is AuthUserBlockedException) {
      return const AppFailure(
        code: AppErrorCode.apiForbidden,
        message: 'User is blocked',
        canRetry: false,
      );
    }

    if (error is ServerpodClientException) {
      return AppFailure(
        code: AppErrorCode.apiGeneral,
        message: error.message,
        canRetry: true,
      );
    }

    return AppFailure.fromException(error);
  }
}
