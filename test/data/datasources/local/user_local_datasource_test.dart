import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/datasources/local/user_local_datasource.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late UserLocalDataSource dataSource;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = UserLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'upsertFromSession updates cached user when email already exists',
    () async {
      await dataSource.upsertFromSession(
        userId: 'legacy-id',
        email: 'test@praxis.app',
      );

      final updatedUser = await dataSource.upsertFromSession(
        userId: 'backend-id',
        email: 'test@praxis.app',
      );

      final userByLegacyId = await dataSource.getUserById('legacy-id');
      final userByBackendId = await dataSource.getUserById('backend-id');

      expect(updatedUser, isNotNull);
      expect(updatedUser!.id, 'backend-id');
      expect(updatedUser.email, 'test@praxis.app');
      expect(userByLegacyId, isNull);
      expect(userByBackendId, isNotNull);
      expect(userByBackendId!.email, 'test@praxis.app');
    },
  );

  test(
    'upsertFromSession clears dependent records when email already exists',
    () async {
      await dataSource.upsertFromSession(
        userId: 'legacy-id',
        email: 'test@praxis.app',
      );
      await database
          .into(database.userStatistic)
          .insert(
            UserStatisticCompanion.insert(
              userId: 'legacy-id',
              lastActiveDate: DateTime(2026, 3, 9),
            ),
          );

      final updatedUser = await dataSource.upsertFromSession(
        userId: 'backend-id',
        email: 'test@praxis.app',
      );
      final newStatistic = await (database.select(
        database.userStatistic,
      )..where((t) => t.userId.equals('backend-id'))).getSingleOrNull();
      final legacyStatistic = await (database.select(
        database.userStatistic,
      )..where((t) => t.userId.equals('legacy-id'))).getSingleOrNull();

      expect(updatedUser, isNotNull);
      expect(updatedUser!.id, 'backend-id');
      expect(newStatistic, isNull);
      expect(legacyStatistic, isNull);
    },
  );
}
