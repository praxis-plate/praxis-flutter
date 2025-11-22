import 'package:codium/domain/models/models.dart';

abstract interface class IAuthDataSource {
  Future<User?> signUp({required String email, required String password});
  Future<User?> signIn({required String email, required String password});
  Future<void> signOut();
}
