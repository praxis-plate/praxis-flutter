import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_auth_repository.dart';

class VerifyPasswordResetCodeUseCase {
  final IAuthRepository _authRepository;

  VerifyPasswordResetCodeUseCase(this._authRepository);

  Future<Result<String>> call({
    required String passwordResetRequestId,
    required String verificationCode,
  }) async {
    return _authRepository.verifyPasswordResetCode(
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode,
    );
  }
}
