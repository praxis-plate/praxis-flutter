import 'package:codium/domain/models/task/course_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TaskWidgetFactory {
  static Widget create(CourseTask task) {
    return switch (task.type) {
      'theory' => TheoryBody(task: task),
      'practice' => PracticeBody(task: task),
      'quiz' => QuizBody(task: task),
      'project' => ProjectBody(task: task),
      _ => const SizedBox(),
    };
  }
}

class TheoryBody extends StatelessWidget {
  final CourseTask task;

  const TheoryBody({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Markdown(
      padding: EdgeInsets.zero,
      data: task.content,
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
  final CourseTask task;

  const PracticeBody({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Markdown(
      padding: EdgeInsets.zero,
      data: task.content,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(
        theme,
      ).copyWith(blockquote: TextStyle(color: theme.colorScheme.error)),
    );
  }
}

class QuizBody extends StatelessWidget {
  final CourseTask task;

  const QuizBody({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProjectBody extends StatelessWidget {
  final CourseTask task;

  const ProjectBody({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
