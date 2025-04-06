import 'package:codium/domain/models/task/course_task.dart';

class CourseModule {
  final String title;
  final String description;
  final List<CourseTask> tasks;
  final Duration duration;

  CourseModule({
    required this.title,
    required this.description,
    required this.tasks,
    required this.duration,
  });
}