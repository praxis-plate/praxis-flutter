import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:praxis/domain/repositories/i_user_repository.dart';

class GetProfileUseCase {
  final IUserRepository _userRepository;

  GetProfileUseCase(this._userRepository);

  Future<Result<UserProfileModel>> call() async {
    return await _userRepository.getCurrentUser();
  }
}
