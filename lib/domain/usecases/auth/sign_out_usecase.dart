import 'package:codium/core/exceptions/auth_exceptions.dart';
import 'package:codium/domain/repositories/abstract_auth_repository.dart';

class SignOutUseCase {
  final IAuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      throw AuthException('Sign out error');
    }
  }
}
