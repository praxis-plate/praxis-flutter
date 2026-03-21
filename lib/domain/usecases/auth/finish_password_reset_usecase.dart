import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_auth_repository.dart';

class FinishPasswordResetUsecase {
  final IAuthRepository _authRepository;

  FinishPasswordResetUsecase(this._authRepository);

  Future<Result<void>> call({
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    return _authRepository.finishPasswordReset(
      finishPasswordResetToken: finishPasswordResetToken,
      newPassword: newPassword,
    );
  }
}
