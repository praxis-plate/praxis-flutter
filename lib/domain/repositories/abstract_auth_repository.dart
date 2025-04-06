import 'package:codium/domain/models/models.dart';

abstract interface class IAuthRepository {
  Future<User> signUp(String email, String password);
  Future<User> login(String email, String password);
  Future<void> signOut();
  Future<bool> isAuthenticated();
}
