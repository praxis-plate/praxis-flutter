import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final int? taskCount;

  const LessonCard({super.key, required this.lesson, required this.taskCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.play_circle_outline,
          color: theme.colorScheme.primary,
        ),
        title: Text(lesson.title),
        subtitle: _TaskCountSubtitle(
          durationMinutes: lesson.durationMinutes,
          taskCount: taskCount,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.pushNamed(
            'lesson-task-session',
            pathParameters: {'lessonId': lesson.id.toString()},
          );
        },
      ),
    );
  }
}

class _TaskCountSubtitle extends StatelessWidget {
  final int durationMinutes;
  final int? taskCount;

  const _TaskCountSubtitle({
    required this.durationMinutes,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final taskCountText = taskCount != null
        ? ' • ${s.tasksCount(taskCount!)}'
        : '';

    return Text(
      '${s.minutesCount(durationMinutes)}$taskCountText',
      style: theme.textTheme.bodySmall,
    );
  }
}
