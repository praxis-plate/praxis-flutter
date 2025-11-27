import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/datasources/i_module_local_datasource.dart';

class ModuleLocalDataSource implements IModuleLocalDataSource {
  final AppDatabase _db;

  const ModuleLocalDataSource(this._db);

  @override
  Future<List<ModuleEntity>> getModulesByCourseId(int courseId) async {
    return await _db.managers.module
        .filter((f) => f.courseId.id(courseId))
        .get();
  }

  @override
  Future<ModuleEntity?> getModuleById(int moduleId) async {
    return await _db.managers.module
        .filter((f) => f.id(moduleId))
        .getSingleOrNull();
  }

  @override
  Future<ModuleEntity> insertModule(ModuleEntity entry) async {
    return await _db.into(_db.module).insertReturning(entry);
  }

  @override
  Future<void> updateModule(ModuleCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Module id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.module)..where((t) => t.id.equals(id))).write(entry);
  }
}
