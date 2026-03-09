import 'package:codium/core/utils/result.dart';
import 'package:codium/data/datasources/local/user_local_datasource.dart';
import 'package:codium/data/datasources/remote/auth_remote_datasource.dart';
import 'package:codium/data/datasources/remote/auth_session_remote_datasource.dart';
import 'package:codium/data/entities/auth_session_entity.dart';
import 'package:codium/data/repositories/auth_repository.dart';
import 'package:codium/domain/models/session/session_model.dart';
import 'package:codium/domain/services/i_session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_client/serverpod_client.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockSessionService extends Mock implements ISessionService {}

class _MockAuthSessionRemoteDataSource extends Mock
    implements AuthSessionRemoteDataSource {}

class _MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late AuthRepository repository;
  late _MockAuthRemoteDataSource authRemoteDataSource;
  late _MockSessionService sessionService;
  late _MockAuthSessionRemoteDataSource authSessionRemoteDataSource;
  late _MockUserLocalDataSource userLocalDataSource;

  setUpAll(() {
    registerFallbackValue(
      const SessionModel(
        userId: '00000000-0000-0000-0000-000000000000',
        email: 'fallback@example.com',
        accessToken: 'access',
        refreshToken: 'refresh',
        tokenExpiresAt: null,
      ),
    );
    registerFallbackValue(
      AuthSessionEntity(
        authStrategy: 'email',
        authUserId: UuidValue.fromString(
          '00000000-0000-0000-0000-000000000000',
        ),
        accessToken: 'access',
        refreshToken: 'refresh',
        tokenExpiresAt: null,
        email: 'fallback@example.com',
        scopeNames: const {},
      ),
    );
  });

  setUp(() {
    authRemoteDataSource = _MockAuthRemoteDataSource();
    sessionService = _MockSessionService();
    authSessionRemoteDataSource = _MockAuthSessionRemoteDataSource();
    userLocalDataSource = _MockUserLocalDataSource();

    repository = AuthRepository(
      authRemoteDataSource,
      sessionService,
      authSessionRemoteDataSource,
      userLocalDataSource,
    );
  });

  test('signIn persists local user using backend user id', () async {
    final session = AuthSessionEntity(
      authStrategy: 'email',
      authUserId: UuidValue.fromString('00000000-0000-0000-0000-000000000123'),
      accessToken: 'access',
      refreshToken: 'refresh',
      tokenExpiresAt: DateTime(2026, 3, 9, 12),
      email: 'user@example.com',
      scopeNames: const {},
    );

    when(
      () => authRemoteDataSource.login(
        email: 'user@example.com',
        password: 'secret',
      ),
    ).thenAnswer((_) async => session);
    when(() => sessionService.saveSession(any())).thenAnswer((_) async {});
    when(
      () => userLocalDataSource.upsertFromSession(
        userId: '00000000-0000-0000-0000-000000000123',
        email: 'user@example.com',
      ),
    ).thenAnswer((_) async => null);
    when(
      () => authSessionRemoteDataSource.update(any()),
    ).thenAnswer((_) async {});

    final result = await repository.signIn('user@example.com', 'secret');

    expect(result.isSuccess, isTrue);
    verify(() => sessionService.saveSession(any())).called(1);
    verify(
      () => userLocalDataSource.upsertFromSession(
        userId: '00000000-0000-0000-0000-000000000123',
        email: 'user@example.com',
      ),
    ).called(1);
  });
}
