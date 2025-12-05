import 'dart:convert';

import 'package:codium/domain/models/session/session.dart';
import 'package:codium/domain/services/i_session_service.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService implements ISessionService {
  static const String _sessionKey = 'user_session';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiresAtKey = 'token_expires_at';

  @override
  Future<void> saveSession({
    required int userId,
    required String email,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final generatedAccessToken = accessToken ?? _generateToken(userId, email);
    final generatedRefreshToken =
        refreshToken ?? _generateToken(userId, email, isRefresh: true);
    final expiresAt =
        tokenExpiresAt ?? DateTime.now().add(const Duration(hours: 24));

    await prefs.setString(_sessionKey, 'active');
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_accessTokenKey, generatedAccessToken);
    await prefs.setString(_refreshTokenKey, generatedRefreshToken);
    await prefs.setString(_tokenExpiresAtKey, expiresAt.toIso8601String());
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenExpiresAtKey);
  }

  @override
  Future<bool> hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getString(_sessionKey) == 'active';

    if (!isActive) return false;

    final expiresAtStr = prefs.getString(_tokenExpiresAtKey);
    if (expiresAtStr == null) return false;

    final expiresAt = DateTime.parse(expiresAtStr);
    return DateTime.now().isBefore(expiresAt);
  }

  @override
  Future<SessionModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_userIdKey);
    final email = prefs.getString(_userEmailKey);
    final accessToken = prefs.getString(_accessTokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);
    final expiresAtStr = prefs.getString(_tokenExpiresAtKey);

    if (userId == null || email == null) {
      return null;
    }

    return SessionModel(
      userId: userId,
      email: email,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: expiresAtStr != null
          ? DateTime.parse(expiresAtStr)
          : null,
    );
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  String _generateToken(int userId, String email, {bool isRefresh = false}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = isRefresh ? 'refresh' : 'access';
    final payload = '$userId:$email:$type:$timestamp';
    final bytes = utf8.encode(payload);
    final hash = sha256.convert(bytes);
    return base64Url.encode(hash.bytes);
  }
}
