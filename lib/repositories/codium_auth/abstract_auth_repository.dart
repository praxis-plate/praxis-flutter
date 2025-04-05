import 'package:codium/repositories/codium_courses/models/models.dart';

abstract interface class IAuthRepository {
  Future<User> signUp(String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout();
}
