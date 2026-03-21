import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final int? taskCount;
  final bool isCompleted;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.taskCount,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.pushNamed(
            'lesson-task-session',
            pathParameters: {'lessonId': lesson.id.toString()},
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(
                isCompleted
                    ? Icons.check_circle_outline
                    : Icons.play_circle_outline,
                color: isCompleted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _TaskCountSubtitle(
                      durationMinutes: lesson.durationMinutes,
                      taskCount: taskCount,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isCompleted) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Text(
                    S.of(context).complete,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
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
