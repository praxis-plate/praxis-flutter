import 'package:codium/domain/models/models.dart';

import 'mock_courses.dart';

final mockUserStatistics = UserStatistics(
  userId: 'mock_1',
  currentStreak: 3,
  maxStreak: 7,
  points: 500,
  lastActiveDate: DateTime.now().subtract(const Duration(days: 1)),
  courses: {
    for (final course in mockCourses)
      course.id: UserCourseStatistics(
        courseId: course.id,
        progress: 0.5,
        totalTasks: course.totalTasks,
        solvedTasks: (course.totalTasks / 2).round(),
        timeSpent: const Duration(hours: 2),
        lastActivity: DateTime.now().subtract(const Duration(days: 1)),
      ),
  },
);
