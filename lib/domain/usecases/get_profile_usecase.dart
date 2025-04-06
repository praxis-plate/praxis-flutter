import 'package:codium/core/exceptions/user_exceptions.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_user_repository.dart';

class GetProfileUseCase {
  final IUserRepository _userRepository;

  GetProfileUseCase(this._userRepository);

  Future<User> execute() async {
    try {
      return await _userRepository.getCurrentUser();
    } catch (e) {
      throw ProfileException('Не удалось загрузить профиль');
    }
  }
}
