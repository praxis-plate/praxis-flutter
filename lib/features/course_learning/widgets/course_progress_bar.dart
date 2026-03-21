import 'package:codium/domain/models/models.dart';
import 'package:flutter/material.dart';

class CourseProgressBar extends StatelessWidget {
  const CourseProgressBar({super.key, required this.userCourseStatistics});

  final UserCourseStatistics userCourseStatistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LinearProgressIndicator(
      value: userCourseStatistics.progress / 100,
      minHeight: 4,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      borderRadius: BorderRadius.circular(999),
    );
  }
}
