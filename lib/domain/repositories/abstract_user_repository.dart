import 'package:codium/domain/models/models.dart';

abstract interface class IUserRepository {
  Future<User> getCurrentUser();
  Future<void> saveUser(User user);
}
