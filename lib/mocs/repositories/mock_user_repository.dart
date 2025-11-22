import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/repositories.dart';
import 'package:codium/mocs/data/mock_user.dart';

class MockUserRepository implements IUserRepository {
  @override
  Future<User> getCurrentUser() async {
    return mockUser;
  }

  @override
  Future<void> saveUser(User user) async {
    mockUser = user;
  }
}
