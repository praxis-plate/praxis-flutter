import 'dart:convert';

import 'package:codium/core/services/session_service.dart';
import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/domain/datasources/abstract_auth_datasource.dart';
import 'package:codium/domain/models/models.dart';
import 'package:crypto/crypto.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class LocalAuthDataSource implements IAuthDataSource {
  final AppDatabase _db;
  final SessionService _sessionService;
  final Uuid _uuid = const Uuid();

  LocalAuthDataSource(this._db, this._sessionService);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final existingUser = await _db.managers.users
          .filter((f) => f.email(email))
          .getSingleOrNull();

      if (existingUser != null) {
        throw Exception('User with this email already exists');
      }

      final userId = _uuid.v4();
      final passwordHash = _hashPassword(password);

      await _db.managers.users.create(
        (o) => o(
          id: userId,
          email: email,
          passwordHash: passwordHash,
          createdAt: DateTime.now(),
        ),
      );

      await _sessionService.saveSession(userId: userId, email: email);

      return User(
        id: userId,
        name: email.split('@').first,
        email: email,
        balance: Money(amount: Decimal.zero, currency: Currency.usd),
        purchasedCourseIds: const [],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final passwordHash = _hashPassword(password);

      final userEntity = await _db.managers.users
          .filter((f) => f.email(email) & f.passwordHash(passwordHash))
          .getSingleOrNull();

      if (userEntity == null) {
        return null;
      }

      await _sessionService.saveSession(
        userId: userEntity.id,
        email: userEntity.email,
      );

      return User(
        id: userEntity.id,
        name: email.split('@').first,
        email: userEntity.email,
        balance: Money(amount: Decimal.zero, currency: Currency.usd),
        purchasedCourseIds: const [],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _sessionService.clearSession();
  }

  Future<bool> hasActiveSession() async {
    return await _sessionService.hasActiveSession();
  }

  Future<User?> getCurrentUser() async {
    try {
      final hasSession = await _sessionService.hasActiveSession();
      if (!hasSession) {
        return null;
      }

      final userId = await _sessionService.getUserId();
      if (userId == null) {
        return null;
      }

      final userEntity = await _db.managers.users
          .filter((f) => f.id(userId))
          .getSingleOrNull();

      if (userEntity == null) {
        await _sessionService.clearSession();
        return null;
      }

      return User(
        id: userEntity.id,
        name: userEntity.email.split('@').first,
        email: userEntity.email,
        balance: Money(amount: Decimal.zero, currency: Currency.usd),
        purchasedCourseIds: const [],
      );
    } catch (e) {
      return null;
    }
  }
}
