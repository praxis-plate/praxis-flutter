import 'package:codium/core/exceptions/auth_exceptions.dart';
import 'package:codium/data/datasources/local/local_auth_datasource.dart';
import 'package:codium/domain/datasources/abstract_auth_datasource.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

final class AuthRepository implements IAuthRepository {
  final IAuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  @override
  Future<User> signUp(String email, String password) async {
    try {
      final user = await _dataSource.signUp(email: email, password: password);

      if (user == null) {
        throw AuthException('Ошибка при регистрации');
      }

      GetIt.I<Talker>().log(user);

      return user;
    } catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw AuthServerException(e.toString());
    }
  }

  @override
  Future<User> signIn(String email, String password) async {
    try {
      final user = await _dataSource.signIn(email: email, password: password);

      if (user == null) {
        throw AuthException('Неверные учетные данные');
      }

      GetIt.I<Talker>().log(user);

      return user;
    } catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw AuthServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _dataSource.signOut();
    } catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw AuthServerException(e.toString());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      if (_dataSource is LocalAuthDataSource) {
        final localDataSource = _dataSource;
        return await localDataSource.hasActiveSession();
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
