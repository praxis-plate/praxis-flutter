import 'package:equatable/equatable.dart';

class CourseStructureLessonModel extends Equatable {
  final int id;
  final String title;
  final int orderIndex;
  final int durationMinutes;

  const CourseStructureLessonModel({
    required this.id,
    required this.title,
    required this.orderIndex,
    required this.durationMinutes,
  });

  @override
  List<Object> get props => [id, title, orderIndex, durationMinutes];
}
