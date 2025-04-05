import 'package:codium/repositories/codium_courses/models/user_course_statistics.dart';
import 'package:flutter/material.dart';

class CourseProgressBar extends StatelessWidget {
  const CourseProgressBar({
    super.key,
    required this.courseStatistics,
  });

  final UserCourseStatistics courseStatistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LinearProgressIndicator(
      value: courseStatistics.passedProgress,
      backgroundColor: theme.colorScheme.primaryContainer,
      valueColor: AlwaysStoppedAnimation<Color>(
        theme.colorScheme.primary,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
