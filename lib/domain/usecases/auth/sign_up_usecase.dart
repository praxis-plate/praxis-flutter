import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:codium/domain/repositories/i_auth_repository.dart';

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
