import 'package:codium/data/database/app_database.dart';
import 'package:codium/domain/models/module/module_model.dart';
import 'package:drift/drift.dart';
import 'package:praxis_client/praxis_client.dart';

extension ModuleDtoExtension on ModuleDto {
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

extension ModuleDtoCompanionExtension on ModuleDto {
  ModuleCompanion toCompanion() {
    return ModuleCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      description: Value(description),
      orderIndex: Value(orderIndex),
      createdAt: Value(createdAt),
    );
  }
}
