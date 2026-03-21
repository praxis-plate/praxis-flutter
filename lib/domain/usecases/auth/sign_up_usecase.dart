import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:praxis/domain/repositories/i_auth_repository.dart';

class SignUpUseCase {
  final IAuthRepository _authRepository;

  const SignUpUseCase(this._authRepository);

  Future<Result<UserProfileModel>> call(
    String email,
    String password,
    String registrationToken,
  ) async {
    return await _authRepository.signUp(
      email: email,
      password: password,
      registrationToken: registrationToken,
    );
  }
}
