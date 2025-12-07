import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:codium/domain/repositories/i_auth_repository.dart';
import 'package:codium/domain/repositories/i_user_repository.dart';

class CheckAuthStatusUseCase {
  final IAuthRepository _authRepository;
  final IUserRepository _userRepository;

  CheckAuthStatusUseCase(this._authRepository, this._userRepository);

  Future<Result<UserProfileModel?>> call() async {
    final isAuthResult = await _authRepository.isAuthenticated();

    return isAuthResult.when(
      success: (isAuth) async {
        if (!isAuth) {
          return const Success<UserProfileModel?>(null);
        }

        final userResult = await _userRepository.getCurrentUser();
        return userResult.when(
          success: (user) => Success<UserProfileModel?>(user),
          failure: (failure) => const Success<UserProfileModel?>(null),
        );
      },
      failure: (failure) => const Success<UserProfileModel?>(null),
    );
  }
}
