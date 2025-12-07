import 'package:codium/domain/models/session/session_model.dart';
import 'package:codium/domain/models/session/update_session_model.dart';

abstract interface class ISessionService {
  Future<void> saveSession(SessionModel session);
  Future<void> updateTokens(UpdateSessionModel update);
  Future<void> clearSession();
  Future<bool> hasActiveSession();
  Future<SessionModel?> getSession();
  Future<int?> getUserId();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
}
