import 'package:codium/domain/models/session/session.dart';
import 'package:codium/domain/services/i_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService implements ISessionService {
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiresAtKey = 'token_expires_at';

  final SharedPreferences _prefs;

  SessionService(this._prefs);

  @override
  Future<void> saveSession(SessionModel session) async {
    await _prefs.setString(_userIdKey, session.userId);
    await _prefs.setString(_userEmailKey, session.email);
    await _prefs.setString(_accessTokenKey, session.accessToken);
    if (session.refreshToken is String) {
      await _prefs.setString(_refreshTokenKey, session.refreshToken!);
    }
    if (session.tokenExpiresAt is DateTime) {
      await _prefs.setString(
        _tokenExpiresAtKey,
        session.tokenExpiresAt!.toIso8601String(),
      );
    }
  }

  @override
  Future<void> updateTokens(UpdateSessionModel update) async {
    await _prefs.setString(_accessTokenKey, update.accessToken);
    await _prefs.setString(_refreshTokenKey, update.refreshToken);
    await _prefs.setString(
      _tokenExpiresAtKey,
      update.tokenExpiresAt.toIso8601String(),
    );
  }

  @override
  Future<void> clearSession() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_tokenExpiresAtKey);
  }

  @override
  Future<bool> hasActiveSession() async {
    final userId = _prefs.getInt(_userIdKey);
    if (userId == null) return false;

    final expiresAtStr = _prefs.getString(_tokenExpiresAtKey);
    if (expiresAtStr == null) return false;

    final expiresAt = DateTime.parse(expiresAtStr);
    return DateTime.now().isBefore(expiresAt);
  }

  @override
  Future<SessionModel?> getSession() async {
    final userId = _prefs.getString(_userIdKey);
    final email = _prefs.getString(_userEmailKey);
    final accessToken = _prefs.getString(_accessTokenKey);
    final refreshToken = _prefs.getString(_refreshTokenKey);
    final expiresAtStr = _prefs.getString(_tokenExpiresAtKey);

    if (userId == null ||
        email == null ||
        accessToken == null ||
        refreshToken == null ||
        expiresAtStr == null) {
      return null;
    }

    return SessionModel(
      userId: userId,
      email: email,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: DateTime.parse(expiresAtStr),
    );
  }

  @override
  Future<int?> getUserId() async {
    return _prefs.getInt(_userIdKey);
  }

  @override
  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }
}
