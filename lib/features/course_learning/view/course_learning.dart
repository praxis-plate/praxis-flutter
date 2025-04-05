import 'package:codium/core/widgets/course_progress_bar.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/repositories/codium_courses/models/course.dart';
import 'package:codium/repositories/codium_courses/models/user_course_statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CourseLearning extends StatelessWidget {
  const CourseLearning({
    super.key,
    required this.task,
    required this.userCourseStatistics,
  });

  final Task task;
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
                courseStatistics: userCourseStatistics,
              ),
            ),
          ),
        ),
      ),
      body: Wrapper(
        child: switch (task) {
          Theory theory => TheoryBody(theory: theory),
          Practice practice => PracticeBody(practice: practice),
          _ => const Center(
              child: Text('Error when loading...'),
            )
        },
      ),
    );
  }
}

class TheoryBody extends StatelessWidget {
  const TheoryBody({
    super.key,
    required this.theory,
  });

  final Theory theory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Markdown(
      padding: EdgeInsets.zero,
      data: theory.textInMarkdown,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        codeblockDecoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(4),
        ),
        blockquoteDecoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class PracticeBody extends StatelessWidget {
  const PracticeBody({
    super.key,
    required this.practice,
  });

  final Practice practice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Markdown(
      padding: EdgeInsets.zero,
      data: practice.textInMarkdown,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        blockquote: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
