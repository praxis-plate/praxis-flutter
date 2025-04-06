import 'package:codium/domain/datasources/abstract_user_datasource.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_user_repository.dart';

class UserRepository implements IUserRepository {
  final IUserDataSource _dataSource;

  UserRepository(this._dataSource);

  @override
  Future<User> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser(User user) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }
}
