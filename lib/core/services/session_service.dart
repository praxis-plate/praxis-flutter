import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _sessionKey = 'user_session';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  Future<void> saveSession({
    required String userId,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, 'active');
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
  }

  Future<bool> hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey) == 'active';
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }
}
