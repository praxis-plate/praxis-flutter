import 'package:codium/domain/models/course/course.dart';
import 'package:flutter/material.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({
    super.key,
    required this.course,
    this.mainAxisAlignment,
  });

  final Course course;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.watch_later_rounded,
          color: theme.colorScheme.primary,
          size: 18,
        ),
        Text(
          ' ${course.totalDuration}',
          style: theme.textTheme.labelSmall,
        ),
        if (course.totalTasks > 0) const SizedBox(width: 8),
        if (course.totalTasks > 0)
          Icon(
            Icons.task_alt_rounded,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        if (course.totalTasks > 0)
          Text(
            ' ${course.totalTasks.toString()}',
            style: theme.textTheme.labelSmall,
          ),
        if (course.totalTasks > 0) const SizedBox(width: 8),
        Icon(
          Icons.star_rounded,
          color: theme.colorScheme.primary,
          size: 18,
        ),
        Text(
          ' ${course.statistics.averageRating.toString()}',
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
