import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/datasources/local/user_local_datasource.dart';
import 'package:praxis/data/repositories/user_repository.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/session/session_model.dart';
import 'package:praxis/domain/services/i_session_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class _MockSessionService extends Mock implements ISessionService {}

void main() {
  late UserRepository repository;
  late _MockUserLocalDataSource userLocalDataSource;
  late _MockSessionService sessionService;

  setUp(() {
    userLocalDataSource = _MockUserLocalDataSource();
    sessionService = _MockSessionService();
    repository = UserRepository(userLocalDataSource, sessionService);
  });

  test(
    'getCurrentUser recreates local cache from session when user is absent',
    () async {
      const session = SessionModel(
        userId: '00000000-0000-0000-0000-000000000123',
        email: 'user@example.com',
        accessToken: 'access',
        refreshToken: 'refresh',
        tokenExpiresAt: null,
      );
      final localUser = UserEntity(
        id: '00000000-0000-0000-0000-000000000123',
        email: 'user@example.com',
        createdAt: DateTime(2026, 3, 9),
      );

      when(() => sessionService.getSession()).thenAnswer((_) async => session);
      when(
        () => userLocalDataSource.getUserById(
          '00000000-0000-0000-0000-000000000123',
        ),
      ).thenAnswer((_) async => null);
      when(
        () => userLocalDataSource.upsertFromSession(
          userId: '00000000-0000-0000-0000-000000000123',
          email: 'user@example.com',
        ),
      ).thenAnswer((_) async => localUser);

      final result = await repository.getCurrentUser();

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.id, '00000000-0000-0000-0000-000000000123');
      expect(result.dataOrNull?.email, 'user@example.com');
      verify(
        () => userLocalDataSource.upsertFromSession(
          userId: '00000000-0000-0000-0000-000000000123',
          email: 'user@example.com',
        ),
      ).called(1);
    },
  );
}
