import 'package:cached_network_image/cached_network_image.dart';
import 'package:codium/core/theme/app_theme.dart';
import 'package:codium/core/utils/constants.dart';
import 'package:codium/core/utils/duration.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:codium/s.dart';
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

        return InkWell(
          onTap: onPressed,
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
                        _CourseRating(rating: course.rating),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _CourseMetaInfo(
                      key: Key(course.id.toString()),
                      duration: Duration(minutes: course.durationMinutes),
                      courseId: course.id,
                      lessonsCount: 0,
                      priceInCoins: course.priceInCoins,
                      isPurchased: isPurchased,
                      isProcessing: isProcessing,
                      userProfile: userProfile,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CourseMetaInfo extends StatelessWidget {
  const _CourseMetaInfo({
    super.key,
    required this.courseId,
    required this.duration,
    required this.lessonsCount,
    required this.priceInCoins,
    required this.isPurchased,
    required this.isProcessing,
    required this.userProfile,
  });

  final int courseId;
  final Duration duration;
  final int lessonsCount;
  final int priceInCoins;
  final bool isPurchased;
  final bool isProcessing;
  final UserProfileModel userProfile;

  void onPurchasePressed(BuildContext context, UserProfileModel userProfile) {
    if (!context.mounted) {
      return;
    }

    context.read<CoursePurchasingBloc>().add(
      CoursePurchasingRequestEvent(userId: userProfile.id, courseId: courseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
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
          ],
        ),
        _CompactPurchaseButton(
          priceInCoins: priceInCoins,
          isProcessing: isProcessing,
          isPurchased: isPurchased,
          onPressed: () => onPurchasePressed(context, userProfile),
        ),
      ],
    );
  }
}

class _CompactPurchaseButton extends StatelessWidget {
  final int priceInCoins;
  final bool isProcessing;
  final bool isPurchased;
  final VoidCallback onPressed;

  const _CompactPurchaseButton({
    required this.priceInCoins,
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
        constraints: const BoxConstraints(
          minHeight: 30,
          maxHeight: 30,
          minWidth: 50,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _getBackgroundColor(theme),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _getBorderColor(theme), width: 1),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _CompactPurchaseButtonContent(
            isPurchased: isPurchased,
            isProcessing: isProcessing,
            priceInCoins: priceInCoins,
            theme: theme,
          ),
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
}

class _CompactPurchaseButtonContent extends StatelessWidget {
  final bool isPurchased;
  final bool isProcessing;
  final int priceInCoins;
  final ThemeData theme;

  const _CompactPurchaseButtonContent({
    required this.isPurchased,
    required this.isProcessing,
    required this.priceInCoins,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (isPurchased) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 20, color: theme.colorScheme.primary),
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
    return CoinAmount(
      amount: priceInCoins,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
      iconColor: theme.colorScheme.primary,
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
