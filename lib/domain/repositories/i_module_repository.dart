import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/module/module_model.dart';

abstract interface class IModuleRepository {
  Future<Result<List<ModuleModel>>> getModulesByCourseId(int courseId);
}
