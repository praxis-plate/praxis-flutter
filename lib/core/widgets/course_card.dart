import 'package:cached_network_image/cached_network_image.dart';
import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/utils/constants.dart';
import 'package:codium/core/widgets/user_provider.dart';
import 'package:codium/domain/models/course/course.dart';
import 'package:codium/domain/models/course/course_pricing.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onPressed;

  const CourseCard({
    required this.course,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BlocBuilder<CoursePurchasingBloc, CoursePurchasingState>(
          builder: (context, state) {
            final isPurchased = user.purchasedCourseIds.contains(course.id);
            final isProcessing = state is CoursePurchasingLoadingState &&
                state.courseId == course.id;

            return InkWell(
              onTap: onPressed,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      imageUrl: course.coverImage,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                course.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _CourseRating(
                              rating: course.statistics.averageRating,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.previewDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        _CourseMetaInfo(
                          duration: course.totalDuration,
                          courseId: course.id,
                          lessonsCount: course.totalTasks,
                          pricing: course.pricing,
                          isPurchased: isPurchased,
                          isProcessing: isProcessing,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CourseMetaInfo extends StatelessWidget {
  final String courseId;
  final Duration duration;
  final int lessonsCount;
  final CoursePricing pricing;
  final bool isPurchased;
  final bool isProcessing;

  const _CourseMetaInfo({
    required this.courseId,
    required this.duration,
    required this.lessonsCount,
    required this.pricing,
    required this.isPurchased,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Text(
              _formatDuration(duration),
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
              '$lessonsCount уроков',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        _CompactPurchaseButton(
          pricing: pricing,
          isProcessing: isProcessing,
          isPurchased: isPurchased,
          onPressed: () {
            final bloc = context.read<CoursePurchasingBloc>();
            if (!bloc.isClosed) {
              bloc.add(CoursePurchasingRequestEvent(courseId));
            }
          },
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hoursч $minutesм';
  }
}

class _CompactPurchaseButton extends StatelessWidget {
  final CoursePricing pricing;
  final bool isProcessing;
  final bool isPurchased;
  final VoidCallback onPressed;

  const _CompactPurchaseButton({
    required this.pricing,
    required this.isProcessing,
    required this.isPurchased,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isPurchased || isProcessing ? null : onPressed,
      child: Container(
        constraints:
            const BoxConstraints(minHeight: 30, maxHeight: 30, minWidth: 50),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _getBackgroundColor(theme),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getBorderColor(theme),
            width: 1,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _getContent(theme),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (isPurchased) return theme.colorScheme.primary.withValues(alpha: 0.1);
    if (isProcessing) return theme.colorScheme.surfaceContainerHighest;
    return theme.colorScheme.primary.withValues(alpha: 0.1);
  }

  Color _getBorderColor(ThemeData theme) {
    if (isPurchased || isProcessing) {
      return theme.colorScheme.primary.withValues(alpha: 0.3);
    }
    return theme.colorScheme.primary.withValues(alpha: 0.3);
  }

  Widget _getContent(ThemeData theme) {
    if (isPurchased) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ],
      );
    }

    if (isProcessing) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          pricing.price.format(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _CourseRating extends StatelessWidget {
  final double rating;

  const _CourseRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.amber,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: Colors.amber, size: 16),
      ],
    );
  }
}
