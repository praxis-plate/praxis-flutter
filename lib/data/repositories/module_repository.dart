import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/datasources/remote/module_remote_datasource.dart';
import 'package:praxis/data/entities/module_dto_extension.dart';
import 'package:praxis/domain/models/module/module_model.dart';
import 'package:praxis/domain/repositories/i_module_repository.dart';

class ModuleRepository implements IModuleRepository {
  final ModuleRemoteDataSource _remoteDataSource;

  const ModuleRepository(this._remoteDataSource);

  @override
  Future<Result<List<ModuleModel>>> getModulesByCourseId(int courseId) async {
    try {
      final moduleDtos = await _remoteDataSource.getModulesByCourseId(courseId);
      final models = moduleDtos.map((dto) => dto.toDomain()).toList();
      return Success(models);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e));
    }
  }
}
