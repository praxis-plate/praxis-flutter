import 'package:codium/domain/models/models.dart';
import 'package:praxis_client/praxis_client.dart';

extension CourseStructureDtoMapper on CourseStructureDto {
  CourseStructureModel toDomain() {
    return CourseStructureModel(
      courseId: courseId,
      title: title,
      modules: modules.map((module) => module.toDomain()).toList(),
    );
  }
}

extension CourseStructureModuleDtoMapper on CourseStructureModuleDto {
  CourseStructureModuleModel toDomain() {
    return CourseStructureModuleModel(
      id: id,
      title: title,
      description: description,
      orderIndex: orderIndex,
      lessons: lessons.map((lesson) => lesson.toDomain()).toList(),
    );
  }
}

extension CourseStructureLessonDtoMapper on CourseStructureLessonDto {
  CourseStructureLessonModel toDomain() {
    return CourseStructureLessonModel(
      id: id,
      title: title,
      orderIndex: orderIndex,
      durationMinutes: durationMinutes,
    );
  }
}
