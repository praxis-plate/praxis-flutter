import 'package:codium/data/database/app_database.dart';
import 'package:codium/data/datasources/local/user_local_datasource.dart';
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
        email: 'test@codium.app',
      );

      final updatedUser = await dataSource.upsertFromSession(
        userId: 'backend-id',
        email: 'test@codium.app',
      );

      final userByLegacyId = await dataSource.getUserById('legacy-id');
      final userByBackendId = await dataSource.getUserById('backend-id');

      expect(updatedUser, isNotNull);
      expect(updatedUser!.id, 'backend-id');
      expect(updatedUser.email, 'test@codium.app');
      expect(userByLegacyId, isNull);
      expect(userByBackendId, isNotNull);
      expect(userByBackendId!.email, 'test@codium.app');
    },
  );
}
