import 'package:codium/domain/models/course/course_model.dart';
import 'package:flutter/material.dart';

class DescriptionContent extends StatelessWidget {
  final CourseModel course;

  const DescriptionContent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [Text(course.description, style: theme.textTheme.bodyMedium)],
    );
  }
}
