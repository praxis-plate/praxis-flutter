import 'package:praxis/data/database/app_database.dart';

class ModuleLocalDataSource {
  final AppDatabase _db;

  const ModuleLocalDataSource(this._db);

  Future<List<ModuleEntity>> getModulesByCourseId(int courseId) async {
    return await _db.managers.module
        .filter((f) => f.courseId.id(courseId))
        .get();
  }

  Future<ModuleEntity?> getModuleById(int moduleId) async {
    return await _db.managers.module
        .filter((f) => f.id(moduleId))
        .getSingleOrNull();
  }

  Future<ModuleEntity> insertModule(ModuleCompanion entry) async {
    return await _db.into(_db.module).insertReturning(entry);
  }

  Future<void> updateModule(ModuleCompanion entry) async {
    if (!entry.id.present) {
      throw ArgumentError('Module id must be present for update');
    }

    final int id = entry.id.value;

    await (_db.update(_db.module)..where((t) => t.id.equals(id))).write(entry);
  }
}
