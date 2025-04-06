import 'package:codium/core/widgets/course_progress_bar.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/domain/models/task/course_task.dart';
import 'package:codium/domain/models/user_course_statistics.dart';
import 'package:codium/features/course_learning/view/task.dart';
import 'package:flutter/material.dart';

class CourseLearning extends StatelessWidget {
  const CourseLearning({
    super.key,
    required this.task,
    required this.userCourseStatistics,
  });

  final CourseTask task;
  final UserCourseStatistics userCourseStatistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          task.title,
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Align(
              alignment: Alignment.topCenter,
              child: CourseProgressBar(
                userCourseStatistics: userCourseStatistics,
              ),
            ),
          ),
        ),
      ),
      body: Wrapper(
        child: TaskWidgetFactory.create(task),
      ),
    );
  }
}

