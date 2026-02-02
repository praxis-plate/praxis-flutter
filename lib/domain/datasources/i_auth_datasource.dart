import 'package:codium/data/entities/auth_session_entity.dart';

abstract interface class IAuthDataSource {
  Future<String> startRegistration({required String email});
  Future<String> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  });
  Future<AuthSessionEntity> finishRegistration({
    required String email,
    required String password,
    required String registrationToken,
  });

  Future<AuthSessionEntity> login({
    required String email,
    required String password,
  });

  Future<String> startPasswordReset({required String email});
  Future<String> verifyPasswordResetCode({
    required String passwordResetRequestId,
    required String verificationCode,
  });
  Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  });
}
