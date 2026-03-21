import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/repositories/i_auth_repository.dart';

class SignOutUseCase {
  final IAuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<Result<void>> call() async {
    return await _authRepository.signOut();
  }
}
