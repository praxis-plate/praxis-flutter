import 'package:codium/core/exceptions/auth_exceptions.dart';
import 'package:codium/data/datasources/local/local_auth_datasource.dart';
import 'package:codium/domain/datasources/datasources.dart';
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
        throw AuthException('Failed to create user');
      }

      GetIt.I<Talker>().info('User registered successfully: ${user.email}');

      return user;
    } on AuthUserAlreadyExistsException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);

      final errorMessage = e.toString();
      if (errorMessage.contains('already exists')) {
        throw AuthUserAlreadyExistsException(
          'User with this email is already registered',
        );
      }

      throw AuthException('Failed to sign up. Please try again later');
    }
  }

  @override
  Future<User> signIn(String email, String password) async {
    try {
      final user = await _dataSource.signIn(email: email, password: password);

      if (user == null) {
        throw AuthException('Invalid email or password');
      }

      GetIt.I<Talker>().info('User signed in successfully: ${user.email}');

      return user;
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);

      if (e is AuthException) {
        rethrow;
      }

      throw AuthException('Failed to sign in. Please try again later');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
      GetIt.I<Talker>().info('User signed out successfully');
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      throw AuthException('Failed to sign out. Please try again later');
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
