import 'package:codium/domain/models/module/module_model.dart';
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
