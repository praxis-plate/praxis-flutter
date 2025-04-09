import 'package:codium/domain/models/models.dart';

class LearningData {
  final List<ActivityCell> activityCells;
  final UserStatistics userStatistics;
  final Map<Course, UserCourseStatistics> userCourseStatisticsByCourse;

  LearningData({
    required this.activityCells,
    required this.userStatistics,
    required this.userCourseStatisticsByCourse,
  });

  List<MapEntry<Course, UserCourseStatistics>> get addedCoursesStatistics {
    return userCourseStatisticsByCourse.entries
        .toList();
  }

  List<MapEntry<Course, UserCourseStatistics>> get passedCoursesStatistics {
    return userCourseStatisticsByCourse.entries
        .where((entry) => entry.value.progress >= 1.0)
        .toList();
  }
}
