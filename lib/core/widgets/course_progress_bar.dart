import 'package:codium/domain/models/user_course_statistics.dart';
import 'package:flutter/material.dart';

class CourseProgressBar extends StatelessWidget {
  const CourseProgressBar({
    super.key,
    required this.userCourseStatistics,
  });

  final UserCourseStatistics userCourseStatistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LinearProgressIndicator(
      value: userCourseStatistics.progress,
      backgroundColor: theme.colorScheme.primaryContainer,
      valueColor: AlwaysStoppedAnimation<Color>(
        theme.colorScheme.primary,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
