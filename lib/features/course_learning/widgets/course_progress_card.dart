import 'package:cached_network_image/cached_network_image.dart';
import 'package:praxis/core/utils/constants.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/user/user_course_statistics.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';

class CourseProgressCard extends StatelessWidget {
  final CourseModel course;
  final UserCourseStatistics statistics;
  final VoidCallback? onTap;

  const CourseProgressCard({
    required this.course,
    required this.statistics,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CourseThumbnail(imageUrl: course.coverImage, theme: theme),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _LessonProgress(
                        label: s.lessonsCompleted(
                          statistics.solvedTasks,
                          statistics.totalTasks,
                        ),
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ProgressBar(progress: statistics.progress, theme: theme),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  s.courseProgressPercent(statistics.progress.round()),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (statistics.isCompleted)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        s.complete,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseThumbnail extends StatelessWidget {
  final String? imageUrl;
  final ThemeData theme;

  const _CourseThumbnail({required this.imageUrl, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        imageUrl: imageUrl ?? '',
        placeholder: (context, url) =>
            Container(color: theme.colorScheme.surfaceContainerHighest),
        errorWidget: (context, url, error) => Image.asset(
          Constants.placeholderCourseImagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _LessonProgress extends StatelessWidget {
  final String label;
  final ThemeData theme;

  const _LessonProgress({
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.menu_book,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final ThemeData theme;

  const _ProgressBar({required this.progress, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress / 100,
        minHeight: 8,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }
}
