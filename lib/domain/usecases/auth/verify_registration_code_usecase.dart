import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_auth_repository.dart';

class VerifyRegistrationCodeUseCase {
  final IAuthRepository _authRepository;

  VerifyRegistrationCodeUseCase(this._authRepository);

  Future<Result<String>> call({
    required String accountRequestId,
    required String verificationCode,
  }) async {
    return _authRepository.verifyRegistrationCode(
      accountRequestId: accountRequestId,
      verificationCode: verificationCode,
    );
  }
}
