import 'package:codium/core/exceptions/auth_exceptions.dart';
import 'package:codium/core/validators/auth_validator.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_auth_repository.dart';

class SignInUseCase {
  final IAuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<User> execute(String email, String password) async {
    AuthValidator.validateCredentials(email, password);

    try {
      final user = await _authRepository.login(email, password);
      return user;
    } on AuthServerException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw AuthException('Ошибка входа');
    }
  }
}
