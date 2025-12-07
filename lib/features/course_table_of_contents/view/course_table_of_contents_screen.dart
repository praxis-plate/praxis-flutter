import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/task/course_task.dart';
import 'package:codium/features/course_table_of_contents/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CourseTableOfContentsScreen extends StatelessWidget {
  const CourseTableOfContentsScreen({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RunningText(
          text: Text(course.title, overflow: TextOverflow.visible),
        ),
        centerTitle: false,
      ),
      body: const Wrapper(
        child: Center(child: Text('Table of Contents - Coming Soon')),
      ),
    );
  }
}

class ContentElement extends StatelessWidget {
  const ContentElement({
    super.key,
    required this.task,
    required this.onTap,
    this.indent = 0,
  });

  final CourseTask task;
  final VoidCallback onTap;
  final int indent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ).copyWith(left: indent.toDouble() * 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(task.toString(), style: theme.textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
