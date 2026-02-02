import 'package:codium/core/services/session_service.dart';
import 'package:codium/domain/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SessionService sessionService;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    sessionService = SessionService(prefs);
  });

  group('SessionService - Session Persistence', () {
    test('should save session with userId and email', () async {
      const userId = '123';
      const email = 'test@example.com';
      final tokenExpiresAt = DateTime.now().add(const Duration(hours: 24));
      final session = SessionModel(
        userId: userId,
        email: email,
        accessToken: 'test_access_token',
        refreshToken: 'test_refresh_token',
        tokenExpiresAt: tokenExpiresAt,
      );

      await sessionService.saveSession(session);

      final hasSession = await sessionService.hasActiveSession();
      final savedSession = await sessionService.getSession();

      expect(hasSession, true);
      expect(savedSession, isNotNull);
      expect(savedSession!.userId, userId);
      expect(savedSession.email, email);
    });

    test('should clear all session data', () async {
      final tokenExpiresAt = DateTime.now().add(const Duration(hours: 24));
      final session = SessionModel(
        userId: '123',
        email: 'test@example.com',
        accessToken: 'test_access_token',
        refreshToken: 'test_refresh_token',
        tokenExpiresAt: tokenExpiresAt,
      );

      await sessionService.saveSession(session);
      await sessionService.clearSession();

      final hasSession = await sessionService.hasActiveSession();
      final savedSession = await sessionService.getSession();

      expect(hasSession, false);
      expect(savedSession, isNull);
    });

    test('should return false when no session exists', () async {
      final hasSession = await sessionService.hasActiveSession();

      expect(hasSession, false);
    });

    test('should return null for session when no session exists', () async {
      final session = await sessionService.getSession();

      expect(session, isNull);
    });

    test('should persist session across service instances', () async {
      final tokenExpiresAt = DateTime.now().add(const Duration(hours: 24));
      final session = SessionModel(
        userId: '123',
        email: 'test@example.com',
        accessToken: 'test_access_token',
        refreshToken: 'test_refresh_token',
        tokenExpiresAt: tokenExpiresAt,
      );

      await sessionService.saveSession(session);

      final newSessionService = SessionService(prefs);
      final hasSession = await newSessionService.hasActiveSession();
      final savedSession = await newSessionService.getSession();

      expect(hasSession, true);
      expect(savedSession, isNotNull);
      expect(savedSession!.userId, '123');
    });

    test('should overwrite existing session', () async {
      final tokenExpiresAt = DateTime.now().add(const Duration(hours: 24));
      final session1 = SessionModel(
        userId: '123',
        email: 'test1@example.com',
        accessToken: 'test_access_token_1',
        refreshToken: 'test_refresh_token_1',
        tokenExpiresAt: tokenExpiresAt,
      );
      final session2 = SessionModel(
        userId: '456',
        email: 'test2@example.com',
        accessToken: 'test_access_token_2',
        refreshToken: 'test_refresh_token_2',
        tokenExpiresAt: tokenExpiresAt,
      );

      await sessionService.saveSession(session1);
      await sessionService.saveSession(session2);

      final savedSession = await sessionService.getSession();

      expect(savedSession, isNotNull);
      expect(savedSession!.userId, '456');
      expect(savedSession.email, 'test2@example.com');
    });
  });
}
