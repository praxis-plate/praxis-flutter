import 'package:codium/core/exceptions/user_exceptions.dart';
import 'package:codium/data/datasources/local/local_auth_datasource.dart';
import 'package:codium/domain/datasources/abstract_auth_datasource.dart';
import 'package:codium/domain/datasources/abstract_user_datasource.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_user_repository.dart';

class UserRepository implements IUserRepository {
  final IUserDataSource _dataSource;
  final IAuthDataSource _authDataSource;

  UserRepository(this._dataSource, this._authDataSource);

  @override
  Future<User> getCurrentUser() async {
    try {
      if (_authDataSource is LocalAuthDataSource) {
        final localAuthDataSource = _authDataSource as LocalAuthDataSource;
        final user = await localAuthDataSource.getCurrentUser();
        if (user == null) {
          throw UserException('No authenticated user found');
        }
        return user;
      }
      throw UserException(
        'Auth datasource not configured for local authentication',
      );
    } catch (e) {
      throw UserException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(User user) {
    throw UnimplementedError();
  }
}
