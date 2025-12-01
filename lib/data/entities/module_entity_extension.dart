import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/module/create_module_model.dart';
import 'package:codium/domain/models/module/module_model.dart';
import 'package:codium/domain/models/module/update_module_model.dart';
import 'package:drift/drift.dart';

extension ModuleEntityExtension on ModuleEntity {
  ModuleModel toDomain() {
    return ModuleModel(
      id: id,
      courseId: courseId,
      title: title,
      description: description,
      orderIndex: orderIndex,
      createdAt: createdAt,
    );
  }
}

extension CreateModuleModelExtension on CreateModuleModel {
  ModuleCompanion toCompanion() {
    return ModuleCompanion.insert(
      courseId: courseId,
      title: title,
      description: description,
      orderIndex: orderIndex,
      createdAt: DateTime.now(),
    );
  }
}

extension UpdateModuleModelExtension on UpdateModuleModel {
  ModuleCompanion toCompanion() {
    return ModuleCompanion(
      id: Value(id),
      title: title != null ? Value(title!) : const Value.absent(),
      description: description != null
          ? Value(description!)
          : const Value.absent(),
      orderIndex: orderIndex != null
          ? Value(orderIndex!)
          : const Value.absent(),
    );
  }
}
