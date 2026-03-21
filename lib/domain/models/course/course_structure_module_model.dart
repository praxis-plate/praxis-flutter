import 'package:praxis/domain/models/course/course_structure_lesson_model.dart';
import 'package:equatable/equatable.dart';

class CourseStructureModuleModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final int orderIndex;
  final List<CourseStructureLessonModel> lessons;

  const CourseStructureModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.lessons,
  });

  @override
  List<Object> get props => [id, title, description, orderIndex, lessons];

  @override
  bool get stringify => true;
}
