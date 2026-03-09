import 'package:codium/data/database/app_database.dart';
import 'package:drift/drift.dart';

class UserLocalDataSource {
  final AppDatabase _db;

  const UserLocalDataSource(this._db);

  Future<UserEntity?> upsertFromSession({
    required String userId,
    required String email,
  }) async {
    final existingUser = await getUserById(userId);
    if (existingUser != null) {
      if (existingUser.email != email) {
        await updateUser(UserCompanion(id: Value(userId), email: Value(email)));
        return getUserById(userId);
      }

      return existingUser;
    }

    return _db.managers.user.createReturning(
      (o) => o(
        id: userId,
        email: email,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<UserEntity?> getUserByEmail(String email) async {
    return await _db.managers.user
        .filter((f) => f.email(email))
        .getSingleOrNull();
  }

  Future<UserEntity?> getUserById(String userId) async {
    return await _db.managers.user
        .filter((f) => f.id(userId))
        .getSingleOrNull();
  }

  Future<void> updateUser(UserCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('User id must be present for update');
    }

    await (_db.update(
      _db.user,
    )..where((t) => t.id.equals(entry.id.value))).write(entry);
  }
}
