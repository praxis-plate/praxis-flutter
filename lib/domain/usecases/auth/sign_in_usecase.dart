import 'package:codium/core/utils/result.dart';
import 'package:codium/core/validators/auth_validator.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:codium/domain/repositories/i_auth_repository.dart';

class SignInUseCase {
  final IAuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<Result<UserProfileModel>> call(String email, String password) async {
    AuthValidator.validateCredentials(email, password);
    return await _authRepository.signIn(email, password);
  }
}
