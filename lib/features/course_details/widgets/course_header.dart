import 'package:cached_network_image/cached_network_image.dart';
import 'package:praxis/core/utils/constants.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/course_details/widgets/course_meta_info.dart';
import 'package:praxis/features/course_details/widgets/course_purchase_button.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseHeader extends StatelessWidget {
  final CourseModel course;
  final bool isPurchased;

  const CourseHeader({
    super.key,
    required this.course,
    required this.isPurchased,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProfile = UserScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CourseSummaryCard(
          course: course,
          isPurchased: isPurchased,
          userProfile: userProfile,
        ),
        const SizedBox(height: 12),
        CourseMetaInfo(course: course),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final url = course.thumbnailUrl ?? '';
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  width: 180,
                  height: 110,
                  fit: BoxFit.cover,
                  imageUrl: url,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    Constants.placeholderCourseImagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _CourseSummaryCard extends StatelessWidget {
  final CourseModel course;
  final bool isPurchased;
  final UserProfileModel userProfile;

  const _CourseSummaryCard({
    required this.course,
    required this.isPurchased,
    required this.userProfile,
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                height: 96,
                width: 96,
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
                height: 96,
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
                    const SizedBox(height: 4),
                    Text(
                      course.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _SummaryActionButton(
                      course: course,
                      isPurchased: isPurchased,
                      userProfile: userProfile,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryActionButton extends StatelessWidget {
  final CourseModel course;
  final bool isPurchased;
  final UserProfileModel userProfile;

  const _SummaryActionButton({
    required this.course,
    required this.isPurchased,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    if (isPurchased) {
      return SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: () => context.push('/course/${course.id}/learn'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Text(s.startLearning),
        ),
      );
    }

    return SizedBox(
      height: 32,
      child: CoursePurchaseButton(
        courseId: course.id,
        priceInCoins: course.priceInCoins,
        userProfile: userProfile,
        compact: true,
      ),
    );
  }
}
