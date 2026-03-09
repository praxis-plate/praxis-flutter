import 'package:codium/domain/models/course/course_structure_module_model.dart';
import 'package:equatable/equatable.dart';

class CourseStructureModel extends Equatable {
  final int courseId;
  final String title;
  final List<CourseStructureModuleModel> modules;

  const CourseStructureModel({
    required this.courseId,
    required this.title,
    required this.modules,
  });

  @override
  List<Object> get props => [courseId, title, modules];

  @override
  bool get stringify => true;
}
