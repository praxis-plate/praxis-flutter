import 'package:flutter/material.dart';
import 'package:praxis/domain/models/course/course_structure_module_model.dart';
import 'package:praxis/domain/models/course/course_structure_lesson_model.dart';
import 'package:praxis/s.dart';

class CourseContentsModuleSection extends StatelessWidget {
  const CourseContentsModuleSection({
    super.key,
    required this.module,
    required this.isPurchased,
    required this.onLessonTap,
  });

  final CourseStructureModuleModel module;
  final bool isPurchased;
  final ValueChanged<int> onLessonTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CourseContentsModuleHeader(module: module),
        ...module.lessons.map(
          (lesson) => CourseContentsLessonTile(
            lesson: lesson,
            isPurchased: isPurchased,
            onTap: () => onLessonTap(lesson.id),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CourseContentsModuleHeader extends StatelessWidget {
  const _CourseContentsModuleHeader({required this.module});

  final CourseStructureModuleModel module;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final hasDescription = module.description.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              s.lessonsCount(module.lessons.length),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            if (hasDescription) ...[
              const SizedBox(height: 6),
              Text(
                module.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CourseContentsLessonTile extends StatelessWidget {
  const CourseContentsLessonTile({
    super.key,
    required this.lesson,
    required this.isPurchased,
    required this.onTap,
  });

  final CourseStructureLessonModel lesson;
  final bool isPurchased;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isPurchased ? Icons.play_circle_outline : Icons.lock_outline,
                  color: isPurchased
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lesson.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isPurchased
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (lesson.durationMinutes > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      s.minutesCount(lesson.durationMinutes),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
