import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/module/create_module_model.dart';
import 'package:codium/domain/models/module/module_model.dart';
import 'package:codium/domain/models/module/update_module_model.dart';

abstract interface class IModuleRepository {
  Future<Result<List<ModuleModel>>> getModulesByCourseId(int courseId);
  Future<Result<ModuleModel?>> getModuleById(int moduleId);
  Future<Result<void>> create(CreateModuleModel model);
  Future<Result<void>> update(UpdateModuleModel model);
}
