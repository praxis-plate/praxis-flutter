import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_auth_repository.dart';

class StartPasswordResetUseCase {
  final IAuthRepository _authRepository;

  StartPasswordResetUseCase(this._authRepository);

  Future<Result<String>> call(String email) async {
    return _authRepository.startPasswordReset(email);
  }
}
