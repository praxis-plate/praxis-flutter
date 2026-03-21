import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final int? taskCount;
  final int completedTaskCount;
  final bool isCompleted;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.taskCount,
    required this.completedTaskCount,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor =
        isCompleted ? theme.colorScheme.primary : theme.cardColor;
    final foregroundColor =
        isCompleted ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCompleted
              ? theme.colorScheme.primary
              : theme.dividerColor.withValues(alpha: 0.6),
        ),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: foregroundColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _TaskCountSubtitle(
                      durationMinutes: lesson.durationMinutes,
                      taskCount: taskCount,
                      color: foregroundColor.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (taskCount != null) ...[
                Text(
                  '$completedTaskCount/$taskCount',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foregroundColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.chevron_right,
                color: foregroundColor.withValues(alpha: 0.7),
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
  final Color color;

  const _TaskCountSubtitle({
    required this.durationMinutes,
    required this.taskCount,
    required this.color,
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
      style: theme.textTheme.bodySmall?.copyWith(color: color),
    );
  }
}
