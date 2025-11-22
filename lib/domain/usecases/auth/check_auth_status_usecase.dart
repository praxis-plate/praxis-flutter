import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_auth_repository.dart';
import 'package:codium/domain/repositories/abstract_user_repository.dart';

class CheckAuthStatusUseCase {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;

  CheckAuthStatusUseCase(this._authRepository, this._userRepository);

  Future<User?> call() async {
    try {
      final isAuth = await _authRepository.isAuthenticated();

      if (!isAuth) {
        return null;
      }

      return await _userRepository.getCurrentUser();
    } catch (e) {
      return null;
    }
  }
}
