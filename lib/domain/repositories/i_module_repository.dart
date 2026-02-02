import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/module/module_model.dart';

abstract interface class IModuleRepository {
  Future<Result<List<ModuleModel>>> getModulesByCourseId(int courseId);
}
