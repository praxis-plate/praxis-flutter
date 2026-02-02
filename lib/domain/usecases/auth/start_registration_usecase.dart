import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/repositories/i_auth_repository.dart';

class StartRegistrationUseCase {
  final IAuthRepository _authRepository;

  StartRegistrationUseCase(this._authRepository);

  Future<Result<String>> call(String email) async {
    return _authRepository.startRegistration(email);
  }
}
