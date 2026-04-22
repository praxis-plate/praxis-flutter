import 'package:cached_network_image/cached_network_image.dart';
import 'package:praxis/core/theme/app_theme.dart';
import 'package:praxis/core/utils/constants.dart';
import 'package:praxis/core/utils/duration.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    required this.userProfile,
    required this.course,
    required this.onPressed,
    this.isPurchased = false,
    super.key,
  });

  final UserProfileModel userProfile;
  final CourseModel course;
  final VoidCallback? onPressed;
  final bool isPurchased;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CoursePurchasingBloc, CoursePurchasingState>(
      builder: (context, state) {
        final isProcessing =
            state is CoursePurchasingLoadingState &&
            state.courseId == course.id;

        return Material(
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          height: 100,
                          width: 100,
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
                      if (isPurchased)
                        const Positioned(
                          top: 4,
                          right: 4,
                          child: _PurchasedBadge(),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                course.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          _CourseMetaInfoRow(
                            key: Key(course.id.toString()),
                            rating: course.rating,
                            duration: Duration(minutes: course.durationMinutes),
                            lessonsCount: course.totalTasks,
                            action: isPurchased
                                ? null
                                : _CourseActionChip(
                                    courseId: course.id,
                                    priceInCoins: course.priceInCoins,
                                    isProcessing: isProcessing,
                                    userProfile: userProfile,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CourseMetaInfoRow extends StatelessWidget {
  const _CourseMetaInfoRow({
    super.key,
    required this.rating,
    required this.duration,
    required this.lessonsCount,
    this.action,
  });

  final double rating;
  final Duration duration;
  final int lessonsCount;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Row(
      children: [
        _CourseRating(rating: rating),
        const SizedBox(width: 12),
        Icon(
          Icons.schedule,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        Text(
          DurationFormatter.formatCompact(duration, s),
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
          s.lessonsCount(lessonsCount),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        if (action != null) ...[const Spacer(), action!],
      ],
    );
  }
}

class _CourseActionChip extends StatelessWidget {
  final int courseId;
  final int priceInCoins;
  final bool isProcessing;
  final UserProfileModel userProfile;

  const _CourseActionChip({
    required this.courseId,
    required this.priceInCoins,
    required this.isProcessing,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isProcessing
          ? null
          : () => _onPurchasePressed(context, userProfile),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.6,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _PurchaseChipContent(
            isProcessing: isProcessing,
            priceInCoins: priceInCoins,
            theme: theme,
          ),
        ),
      ),
    );
  }

  void _onPurchasePressed(BuildContext context, UserProfileModel userProfile) {
    if (!context.mounted) {
      return;
    }

    context.read<CoursePurchasingBloc>().add(
      CoursePurchasingRequestEvent(userId: userProfile.id, courseId: courseId),
    );
  }
}

class _PurchaseChipContent extends StatelessWidget {
  final bool isProcessing;
  final int priceInCoins;
  final ThemeData theme;

  const _PurchaseChipContent({
    required this.isProcessing,
    required this.priceInCoins,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (isProcessing) {
      return const SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (priceInCoins == 0) {
      return Text(
        s.add,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          s.courseDetailsGet,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 6),
        CoinAmount(
          amount: priceInCoins,
          style: theme.textTheme.bodySmall?.copyWith(
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
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: AppPalette.star, size: 16),
      ],
    );
  }
}

class _PurchasedBadge extends StatelessWidget {
  const _PurchasedBadge();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: theme.colorScheme.onPrimary,
          ),
          const SizedBox(width: 2),
          Text(
            s.purchased,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
