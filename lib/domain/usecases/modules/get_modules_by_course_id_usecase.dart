import 'package:codium/core/utils/result.dart';
import 'package:codium/domain/models/module/module_model.dart';
import 'package:codium/domain/repositories/i_module_repository.dart';

class GetModulesByCourseIdUseCase {
  final IModuleRepository _moduleRepository;

  const GetModulesByCourseIdUseCase(this._moduleRepository);

  Future<Result<List<ModuleModel>>> call(int courseId) async {
    return _moduleRepository.getModulesByCourseId(courseId);
  }
}
