import 'package:codium/domain/models/course/course_model.dart';
import 'package:flutter/material.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({super.key, required this.course, this.mainAxisAlignment});

  final CourseModel course;
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
        Text(' ${course.durationMinutes}м', style: theme.textTheme.labelSmall),
        const SizedBox(width: 8),
        Icon(Icons.star_rounded, color: theme.colorScheme.primary, size: 18),
        Text(
          ' ${course.rating.toStringAsFixed(1)}',
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
