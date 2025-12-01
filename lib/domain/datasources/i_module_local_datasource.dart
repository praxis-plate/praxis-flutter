import 'package:codium/data/database/app_database.dart';

abstract interface class IModuleLocalDataSource {
  Future<List<ModuleEntity>> getModulesByCourseId(int courseId);
  Future<ModuleEntity?> getModuleById(int moduleId);
  Future<ModuleEntity> insertModule(ModuleCompanion entry);
  Future<void> updateModule(ModuleCompanion entry);
}
