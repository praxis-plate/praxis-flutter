import 'package:codium/core/utils/duration.dart';
import 'package:codium/repositories/codium_courses/models/course.dart';
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
        if (course.duration != null)
          Icon(
            Icons.watch_later_rounded,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        if (course.duration != null)
          Text(
            ' ${course.duration!.format()}',
            style: theme.textTheme.labelSmall,
          ),
        if (course.tasksCount > 0) const SizedBox(width: 8),
        if (course.tasksCount > 0)
          Icon(
            Icons.task_alt_rounded,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        if (course.tasksCount > 0)
          Text(
            ' ${course.tasksCount.toString()}',
            style: theme.textTheme.labelSmall,
          ),
        if (course.tasksCount > 0) const SizedBox(width: 8),
        if (course.ratingScores != null)
          Icon(
            Icons.star_rounded,
            color: theme.colorScheme.primary,
            size: 18,
          ),
        if (course.ratingScores != null)
          Text(
            ' ${course.ratingScores!.toString()}',
            style: theme.textTheme.labelSmall,
          ),
      ],
    );
  }
}
