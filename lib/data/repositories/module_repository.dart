import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/module_entity_extension.dart';
import 'package:codium/domain/datasources/i_module_local_datasource.dart';
import 'package:codium/domain/models/module/create_module_model.dart';
import 'package:codium/domain/models/module/module_model.dart';
import 'package:codium/domain/models/module/update_module_model.dart';
import 'package:codium/domain/repositories/i_module_repository.dart';

class ModuleRepository implements IModuleRepository {
  final IModuleLocalDataSource _localDataSource;

  const ModuleRepository(this._localDataSource);

  @override
  Future<Result<List<ModuleModel>>> getModulesByCourseId(int courseId) async {
    try {
      final entities = await _localDataSource.getModulesByCourseId(courseId);
      final models = entities.map((e) => e.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<ModuleModel?>> getModuleById(int moduleId) async {
    try {
      final entity = await _localDataSource.getModuleById(moduleId);
      return Success(entity?.toDomain());
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> create(CreateModuleModel model) async {
    try {
      await _localDataSource.insertModule(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> update(UpdateModuleModel model) async {
    try {
      await _localDataSource.updateModule(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
