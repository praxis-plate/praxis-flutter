import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/exceptions/app_exception.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/database/app_database.dart';
import 'package:praxis/data/datasources/local/module_local_datasource.dart';
import 'package:praxis/data/datasources/remote/module_remote_datasource.dart';
import 'package:praxis/data/repositories/module_repository.dart';

class _MockModuleRemoteDataSource extends Mock
    implements ModuleRemoteDataSource {}

class _MockModuleLocalDataSource extends Mock
    implements ModuleLocalDataSource {}

void main() {
  late ModuleRepository repository;
  late _MockModuleRemoteDataSource remoteDataSource;
  late _MockModuleLocalDataSource localDataSource;

  setUp(() {
    remoteDataSource = _MockModuleRemoteDataSource();
    localDataSource = _MockModuleLocalDataSource();
    repository = ModuleRepository(remoteDataSource, localDataSource);
  });

  test(
    'getModulesByCourseId falls back to cached modules on remote error',
    () async {
      when(
        () => localDataSource.getModulesByCourseId(1),
      ).thenAnswer((_) async => [_moduleEntity]);
      when(
        () => remoteDataSource.getModulesByCourseId(1),
      ).thenThrow(const NetworkError.noConnection());

      final result = await repository.getModulesByCourseId(1);

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, hasLength(1));
      verify(() => remoteDataSource.getModulesByCourseId(1)).called(1);
    },
  );

  test(
    'getModulesByCourseId returns failure for unauthorized even when cache exists',
    () async {
      when(
        () => localDataSource.getModulesByCourseId(1),
      ).thenAnswer((_) async => [_moduleEntity]);
      when(
        () => remoteDataSource.getModulesByCourseId(1),
      ).thenThrow(const ApiError.unauthorized());

      final result = await repository.getModulesByCourseId(1);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.code, AppErrorCode.apiUnauthorized);
    },
  );
}

final _moduleEntity = ModuleEntity(
  id: 100,
  courseId: 1,
  title: 'Module',
  description: 'Basics',
  orderIndex: 0,
  createdAt: DateTime(2026, 3, 9),
);
