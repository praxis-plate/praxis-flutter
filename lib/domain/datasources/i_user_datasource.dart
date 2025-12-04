import 'package:codium/data/database/app_database.dart';

abstract interface class IUserDataSource {
  Future<UserEntity?> create({required String email, required String password});
  Future<UserEntity?> getUserByEmail(String email);
  Future<UserEntity?> getUserById(int userId);
  Future<void> updateUser(UserCompanion entry);
  String hashPassword(String password);
}
