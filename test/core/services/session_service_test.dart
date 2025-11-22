import 'package:codium/core/services/session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SessionService sessionService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sessionService = SessionService();
  });

  group('SessionService - Session Persistence', () {
    test('should save session with userId and email', () async {
      const userId = 'user123';
      const email = 'test@example.com';

      await sessionService.saveSession(userId: userId, email: email);

      final hasSession = await sessionService.hasActiveSession();
      final savedUserId = await sessionService.getUserId();
      final savedEmail = await sessionService.getUserEmail();

      expect(hasSession, true);
      expect(savedUserId, userId);
      expect(savedEmail, email);
    });

    test('should clear all session data', () async {
      const userId = 'user123';
      const email = 'test@example.com';

      await sessionService.saveSession(userId: userId, email: email);
      await sessionService.clearSession();

      final hasSession = await sessionService.hasActiveSession();
      final savedUserId = await sessionService.getUserId();
      final savedEmail = await sessionService.getUserEmail();

      expect(hasSession, false);
      expect(savedUserId, isNull);
      expect(savedEmail, isNull);
    });

    test('should return false when no session exists', () async {
      final hasSession = await sessionService.hasActiveSession();

      expect(hasSession, false);
    });

    test('should return null for userId when no session', () async {
      final userId = await sessionService.getUserId();

      expect(userId, isNull);
    });

    test('should return null for email when no session', () async {
      final email = await sessionService.getUserEmail();

      expect(email, isNull);
    });

    test('should persist session across service instances', () async {
      const userId = 'user123';
      const email = 'test@example.com';

      await sessionService.saveSession(userId: userId, email: email);

      final newSessionService = SessionService();
      final hasSession = await newSessionService.hasActiveSession();
      final savedUserId = await newSessionService.getUserId();

      expect(hasSession, true);
      expect(savedUserId, userId);
    });

    test('should overwrite existing session', () async {
      const userId1 = 'user123';
      const email1 = 'test1@example.com';
      const userId2 = 'user456';
      const email2 = 'test2@example.com';

      await sessionService.saveSession(userId: userId1, email: email1);
      await sessionService.saveSession(userId: userId2, email: email2);

      final savedUserId = await sessionService.getUserId();
      final savedEmail = await sessionService.getUserEmail();

      expect(savedUserId, userId2);
      expect(savedEmail, email2);
    });
  });
}
