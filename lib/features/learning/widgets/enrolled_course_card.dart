import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/core/theme/app_theme.dart';
import 'package:praxis/core/utils/constants.dart';
import 'package:praxis/core/utils/duration.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/user/user_course_statistics.dart';
import 'package:praxis/features/course_learning/widgets/course_progress_bar.dart';
import 'package:praxis/s.dart';

class EnrolledCourseCard extends StatelessWidget {
  const EnrolledCourseCard({
    super.key,
    required this.course,
    required this.onContinue,
    this.statistics,
  });

  final CourseModel course;
  final VoidCallback onContinue;
  final UserCourseStatistics? statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final stats =
        statistics ??
        UserCourseStatistics(
          courseId: course.id.toString(),
          progress: 0,
          totalTasks: course.totalTasks > 0 ? course.totalTasks : 1,
          solvedTasks: 0,
          timeSpent: Duration.zero,
          lastActivity: DateTime.now(),
        );

    return Material(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/course/${course.id}/learn'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      imageUrl: course.thumbnailUrl ?? '',
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        Constants.placeholderCourseImagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          _CourseMetaInfoRow(course: course),
                          const SizedBox(height: 8),
                          CourseProgressBar(userCourseStatistics: stats),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.lessonsCompleted(
                                    stats.solvedTasks,
                                    stats.totalTasks,
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                s.courseProgressPercent(stats.progress.round()),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onContinue,
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: theme.colorScheme.primary,
                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text(s.learningContinue),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseMetaInfoRow extends StatelessWidget {
  const _CourseMetaInfoRow({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Row(
      children: [
        const Icon(Icons.star, size: 16, color: AppPalette.star),
        const SizedBox(width: 4),
        Text(
          course.rating.toStringAsFixed(1),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.schedule,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        Text(
          DurationFormatter.formatCompact(
            Duration(minutes: course.durationMinutes),
            s,
          ),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.menu_book,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        Text(
          s.lessonsCount(course.totalTasks),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
