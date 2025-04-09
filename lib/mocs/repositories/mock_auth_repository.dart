import 'package:codium/core/exceptions/auth_exceptions.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_auth_repository.dart';
import 'package:codium/mocs/data/mock_user.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MockAuthRepository implements IAuthRepository {
  User? _currentUser;
  bool _shouldFail = false;

  // Для тестирования ошибок
  void setShouldFail(bool value) => _shouldFail = value;

  @override
  Future<User> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 3)); // Имитация задержки

    if (_shouldFail) {
      throw AuthException('Ошибка регистрации');
    }

    _currentUser = mockUser;

    GetIt.I<Talker>().info('Sign Up. Email: $email. Password: $password');

    return _currentUser!;
  }

  @override
  Future<User> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_shouldFail) {
      throw AuthException('Неверные учетные данные');
    }

    _currentUser = mockUser;

    GetIt.I<Talker>().info('Sign Up. Email: $email. Password: $password');

    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    GetIt.I<Talker>().info('Sign Out');
    _currentUser = null;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _currentUser != null;
  }

  Future<User?> getCurrentUser() async => _currentUser;
}
