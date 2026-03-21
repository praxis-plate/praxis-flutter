import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:praxis/domain/repositories/i_auth_repository.dart';

class SignInUseCase {
  final IAuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<Result<UserProfileModel>> call(String email, String password) async {
    return await _authRepository.signIn(email, password);
  }
}
