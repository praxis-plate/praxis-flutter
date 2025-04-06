import 'package:codium/core/exceptions/auth_exceptions.dart';
import 'package:codium/core/validators/auth_validator.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_auth_repository.dart';

class SignUpUseCase {
  final IAuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<User> execute(String email, String password) async {
    AuthValidator.validateCredentials(email, password);
    
    try {
      return await _authRepository.signUp(email, password);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Ошибка регистрации');
    }
  }
}