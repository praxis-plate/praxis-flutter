import 'package:praxis/core/utils/duration.dart';
import 'package:praxis/domain/models/learning/lesson_progress.dart';
import 'package:praxis/domain/models/task/course_task.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';

class LessonListItem extends StatelessWidget {
  final CourseTask lesson;
  final int lessonNumber;
  final LessonProgress? progress;
  final bool isLocked;
  final VoidCallback? onTap;

  const LessonListItem({
    required this.lesson,
    required this.lessonNumber,
    this.progress,
    this.isLocked = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = progress?.isCompleted ?? false;

    return InkWell(
      onTap: isLocked ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _LessonIcon(
              lessonNumber: lessonNumber,
              isCompleted: isCompleted,
              isLocked: isLocked,
              theme: theme,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isLocked
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                          : theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (lesson.estimatedTime != null) ...[
                    const SizedBox(height: 4),
                    _LessonDuration(
                      duration: lesson.estimatedTime!,
                      isLocked: isLocked,
                      theme: theme,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            _LessonStatus(
              isCompleted: isCompleted,
              isLocked: isLocked,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonIcon extends StatelessWidget {
  final int lessonNumber;
  final bool isCompleted;
  final bool isLocked;
  final ThemeData theme;

  const _LessonIcon({
    required this.lessonNumber,
    required this.isCompleted,
    required this.isLocked,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        shape: BoxShape.circle,
        border: Border.all(color: _getBorderColor(), width: 2),
      ),
      child: Center(
        child: _LessonIconContent(
          lessonNumber: lessonNumber,
          isCompleted: isCompleted,
          isLocked: isLocked,
          theme: theme,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isCompleted) {
      return theme.colorScheme.primary.withValues(alpha: 0.1);
    }
    if (isLocked) {
      return theme.colorScheme.surfaceContainerHighest;
    }
    return theme.colorScheme.primary.withValues(alpha: 0.05);
  }

  Color _getBorderColor() {
    if (isCompleted) {
      return theme.colorScheme.primary;
    }
    if (isLocked) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.2);
    }
    return theme.colorScheme.primary.withValues(alpha: 0.3);
  }
}

class _LessonIconContent extends StatelessWidget {
  final int lessonNumber;
  final bool isCompleted;
  final bool isLocked;
  final ThemeData theme;

  const _LessonIconContent({
    required this.lessonNumber,
    required this.isCompleted,
    required this.isLocked,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Icon(Icons.check, size: 20, color: theme.colorScheme.primary);
    }
    if (isLocked) {
      return Icon(
        Icons.lock,
        size: 20,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      );
    }
    return Text(
      lessonNumber.toString(),
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _LessonDuration extends StatelessWidget {
  final Duration duration;
  final bool isLocked;
  final ThemeData theme;

  const _LessonDuration({
    required this.duration,
    required this.isLocked,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Row(
      children: [
        Icon(
          Icons.schedule,
          size: 14,
          color: isLocked
              ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        Text(
          DurationFormatter.formatLessonDuration(duration, s),
          style: theme.textTheme.bodySmall?.copyWith(
            color: isLocked
                ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _LessonStatus extends StatelessWidget {
  final bool isCompleted;
  final bool isLocked;
  final ThemeData theme;

  const _LessonStatus({
    required this.isCompleted,
    required this.isLocked,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Icon(
        Icons.check_circle,
        size: 24,
        color: theme.colorScheme.primary,
      );
    }
    if (isLocked) {
      return Icon(
        Icons.lock,
        size: 24,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      );
    }
    return Icon(
      Icons.play_circle_outline,
      size: 24,
      color: theme.colorScheme.primary,
    );
  }
}
