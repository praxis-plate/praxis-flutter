import 'package:codium/domain/models/session/session.dart';

abstract interface class ISessionService {
  Future<void> saveSession({required int userId, required String email});
  Future<void> clearSession();
  Future<bool> hasActiveSession();
  Future<SessionModel?> getSession();
}
