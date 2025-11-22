import 'package:codium/core/services/session_service.dart';
import 'package:codium/data/datasources/local/app_database.dart';
import 'package:codium/data/datasources/local/local_auth_datasource.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase database;
  late SessionService sessionService;
  late LocalAuthDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    database = AppDatabase.forTesting(NativeDatabase.memory());
    sessionService = SessionService();
    dataSource = LocalAuthDataSource(database, sessionService);
  });

  tearDown(() async {
    await database.close();
  });

  group('LocalAuthDataSource - User Registration', () {
    test('should register a new user with hashed password', () async {
      const email = 'test@example.com';
      const password = 'password123';

      final user = await dataSource.signUp(email: email, password: password);

      expect(user, isNotNull);
      expect(user!.email, email);
      expect(user.id, isNotEmpty);

      final userEntity = await database.managers.users
          .filter((f) => f.email(email))
          .getSingleOrNull();

      expect(userEntity, isNotNull);
      expect(userEntity!.email, email);
      expect(userEntity.passwordHash, isNot(password));
      expect(userEntity.passwordHash.length, 64);
    });

    test('should not register user with duplicate email', () async {
      const email = 'duplicate@example.com';
      const password = 'password123';

      await dataSource.signUp(email: email, password: password);
      final secondUser = await dataSource.signUp(
        email: email,
        password: password,
      );

      expect(secondUser, isNull);
    });

    test('should save session after successful registration', () async {
      const email = 'session@example.com';
      const password = 'password123';

      await dataSource.signUp(email: email, password: password);

      final hasSession = await sessionService.hasActiveSession();
      final savedEmail = await sessionService.getUserEmail();

      expect(hasSession, true);
      expect(savedEmail, email);
    });

    test('should hash different passwords differently', () async {
      const email1 = 'user1@example.com';
      const email2 = 'user2@example.com';
      const password1 = 'password123';
      const password2 = 'password456';

      await dataSource.signUp(email: email1, password: password1);
      await dataSource.signUp(email: email2, password: password2);

      final user1Entity = await database.managers.users
          .filter((f) => f.email(email1))
          .getSingleOrNull();

      final user2Entity = await database.managers.users
          .filter((f) => f.email(email2))
          .getSingleOrNull();

      expect(user1Entity!.passwordHash, isNot(user2Entity!.passwordHash));
    });
  });

  group('LocalAuthDataSource - User Login', () {
    test('should login with correct credentials', () async {
      const email = 'login@example.com';
      const password = 'correctPassword';

      await dataSource.signUp(email: email, password: password);
      await sessionService.clearSession();

      final user = await dataSource.signIn(email: email, password: password);

      expect(user, isNotNull);
      expect(user!.email, email);
    });

    test('should not login with incorrect password', () async {
      const email = 'secure@example.com';
      const correctPassword = 'correctPassword';
      const wrongPassword = 'wrongPassword';

      await dataSource.signUp(email: email, password: correctPassword);
      await sessionService.clearSession();

      final user = await dataSource.signIn(
        email: email,
        password: wrongPassword,
      );

      expect(user, isNull);
    });

    test('should not login with non-existent email', () async {
      const email = 'nonexistent@example.com';
      const password = 'password123';

      final user = await dataSource.signIn(email: email, password: password);

      expect(user, isNull);
    });

    test('should save session after successful login', () async {
      const email = 'sessionlogin@example.com';
      const password = 'password123';

      await dataSource.signUp(email: email, password: password);
      await sessionService.clearSession();

      await dataSource.signIn(email: email, password: password);

      final hasSession = await sessionService.hasActiveSession();
      final savedEmail = await sessionService.getUserEmail();

      expect(hasSession, true);
      expect(savedEmail, email);
    });
  });

  group('LocalAuthDataSource - Session Management', () {
    test('should clear session on sign out', () async {
      const email = 'signout@example.com';
      const password = 'password123';

      await dataSource.signUp(email: email, password: password);

      expect(await sessionService.hasActiveSession(), true);

      await dataSource.signOut();

      expect(await sessionService.hasActiveSession(), false);
    });

    test('should persist session across datasource instances', () async {
      const email = 'persist@example.com';
      const password = 'password123';

      await dataSource.signUp(email: email, password: password);

      final newDataSource = LocalAuthDataSource(database, sessionService);
      final hasSession = await newDataSource.hasActiveSession();

      expect(hasSession, true);
    });

    test('should retrieve current user from active session', () async {
      const email = 'current@example.com';
      const password = 'password123';

      await dataSource.signUp(email: email, password: password);

      final currentUser = await dataSource.getCurrentUser();

      expect(currentUser, isNotNull);
      expect(currentUser!.email, email);
    });

    test('should return null when no active session', () async {
      final currentUser = await dataSource.getCurrentUser();

      expect(currentUser, isNull);
    });

    test('should clear session if user not found in database', () async {
      const email = 'deleted@example.com';
      const password = 'password123';

      final user = await dataSource.signUp(email: email, password: password);

      await database.managers.users.filter((f) => f.id(user!.id)).delete();

      final currentUser = await dataSource.getCurrentUser();

      expect(currentUser, isNull);
      expect(await sessionService.hasActiveSession(), false);
    });
  });

  group('LocalAuthDataSource - Password Hashing', () {
    test('should produce consistent hash for same password', () async {
      const email1 = 'hash1@example.com';
      const email2 = 'hash2@example.com';
      const password = 'samePassword';

      await dataSource.signUp(email: email1, password: password);
      await dataSource.signUp(email: email2, password: password);

      final user1Entity = await database.managers.users
          .filter((f) => f.email(email1))
          .getSingleOrNull();

      final user2Entity = await database.managers.users
          .filter((f) => f.email(email2))
          .getSingleOrNull();

      expect(user1Entity!.passwordHash, user2Entity!.passwordHash);
    });

    test('should not store plain text password', () async {
      const email = 'plaintext@example.com';
      const password = 'mySecretPassword';

      await dataSource.signUp(email: email, password: password);

      final userEntity = await database.managers.users
          .filter((f) => f.email(email))
          .getSingleOrNull();

      expect(userEntity!.passwordHash, isNot(password));
      expect(userEntity.passwordHash.contains(password), false);
    });
  });
}
