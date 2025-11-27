import 'dart:convert';

import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/datasources.dart';
import 'package:crypto/crypto.dart';

class UserLocalDataSource implements IUserDataSource {
  final AppDatabase _db;

  const UserLocalDataSource(this._db);

  @override
  Future<UserEntity?> create({
    required String email,
    required String password,
  }) async {
    return _db.managers.user.createReturning(
      (o) => o(
        email: email,
        passwordHash: hashPassword(password),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    return await _db.managers.user
        .filter((f) => f.email(email))
        .getSingleOrNull();
  }

  @override
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
