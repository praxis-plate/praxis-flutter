import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/datasources/local/module_local_datasource.dart';
import 'package:praxis/data/datasources/remote/module_remote_datasource.dart';
import 'package:praxis/data/entities/module_dto_extension.dart';
import 'package:praxis/data/entities/module_entity_extension.dart';
import 'package:praxis/domain/models/module/module_model.dart';
import 'package:praxis/domain/repositories/i_module_repository.dart';

class ModuleRepository implements IModuleRepository {
  final ModuleRemoteDataSource _remoteDataSource;
  final ModuleLocalDataSource _localDataSource;

  const ModuleRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<List<ModuleModel>>> getModulesByCourseId(int courseId) async {
    final cachedModules = await _localDataSource.getModulesByCourseId(courseId);

    try {
      final moduleDtos = await _remoteDataSource.getModulesByCourseId(courseId);
      await _localDataSource.upsertModules(
        moduleDtos.map((module) => module.toCompanion()).toList(),
      );
      final models = moduleDtos.map((dto) => dto.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      if (cachedModules.isNotEmpty && _shouldUseCachedData(e)) {
        final models = cachedModules.map((entity) => entity.toDomain()).toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        return Success(models);
      }

      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }

  bool _shouldUseCachedData(AppError error) => error.canRetry;
}
