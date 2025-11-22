abstract interface class ISessionService {
  Future<void> saveSession({required String userId, required String email});

  Future<void> clearSession();

  Future<bool> hasActiveSession();

  Future<String?> getUserId();

  Future<String?> getUserEmail();
}
