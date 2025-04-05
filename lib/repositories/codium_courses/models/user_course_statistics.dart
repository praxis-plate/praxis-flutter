import 'package:codium/repositories/codium_courses/models/course.dart';

class UserCourseStatistics {
  final Course course;
  final double passedProgress;

  UserCourseStatistics({
    required this.course,
    required int passedTasksCount,
  }) : passedProgress =
            course.tasksCount > 0 ? passedTasksCount / course.tasksCount : 0;
}
