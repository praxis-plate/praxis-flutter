import 'package:codium/core/exceptions/auth_exceptions.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/domain/repositories/abstract_auth_repository.dart';

class MockAuthRepository implements IAuthRepository {
  User? _currentUser;
  bool _shouldFail = false;

  // Для тестирования ошибок
  void setShouldFail(bool value) => _shouldFail = value;

  @override
  Future<User> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Имитация задержки

    if (_shouldFail) {
      throw AuthException('Ошибка регистрации');
    }

    _currentUser = User(
      id: 'mock_${email.hashCode}',
      email: email,
      name: email.split('@').first,
      balance: 0,
    );

    return _currentUser!;
  }

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_shouldFail) {
      throw AuthException('Неверные учетные данные');
    }

    _currentUser = User(
      id: 'mock_${email.hashCode}',
      email: email,
      name: 'Mock User',
      balance: 0,
    );

    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _currentUser != null;
  }

  Future<User?> getCurrentUser() async => _currentUser;
}
