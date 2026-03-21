import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';

abstract interface class IAuthRepository {
  Future<Result<String>> startRegistration(String email);
  Future<Result<String>> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  });
  Future<Result<UserProfileModel>> signUp({
    required String email,
    required String password,
    required String registrationToken,
  });

  Future<Result<UserProfileModel>> signIn(String email, String password);

  Future<Result<String>> startPasswordReset(String email);
  Future<Result<String>> verifyPasswordResetCode({
    required String passwordResetRequestId,
    required String verificationCode,
  });
  Future<Result<void>> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  });

  Future<Result<void>> signOut();

  Future<Result<bool>> isAuthenticated();
}
