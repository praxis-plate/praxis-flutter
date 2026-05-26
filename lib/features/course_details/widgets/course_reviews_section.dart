import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:praxis/core/widgets/common/surface_card.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/domain/usecases/course/submit_course_review_usecase.dart';
import 'package:praxis/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:praxis/features/course_details/widgets/course_review_dialog.dart';
import 'package:praxis/s.dart';

class CourseReviewsSection extends StatelessWidget {
  const CourseReviewsSection({
    super.key,
    required this.course,
    required this.userProfile,
  });

  final CourseModel course;
  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    if (course.reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    final s = S.of(context);
    final theme = Theme.of(context);
    final currentUserReview = _resolveCurrentUserReview();
    final canManageOwnReview =
        course.canSubmitReview || currentUserReview != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s.courseReviewsTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (course.canSubmitReview && currentUserReview == null)
                FilledButton.tonal(
                  onPressed: () => _openReviewDialog(context),
                  child: Text(s.courseReviewAction),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              for (final review in course.reviews) ...[
                _CourseReviewCard(
                  review: review,
                  onEdit: canManageOwnReview && review.isCurrentUserReview
                      ? () => _openReviewDialog(context)
                      : null,
                ),
                const SizedBox(height: 12),
              ],
            ]..removeLast(),
          ),
        ],
      ),
    );
  }

  Future<void> _openReviewDialog(BuildContext context) async {
    final currentUserReview = _resolveCurrentUserReview();
    final submitted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => CourseReviewDialog(
        courseId: course.id,
        submitCourseReviewUseCase: GetIt.I<SubmitCourseReviewUseCase>(),
        initialReview: currentUserReview,
      ),
    );

    if (submitted != true || !context.mounted) {
      return;
    }

    context.read<CourseDetailBloc>().add(
      CourseDetailLoadEvent(courseId: course.id, userId: userProfile.id),
    );
  }

  CourseReviewModel? _resolveCurrentUserReview() {
    if (course.currentUserReview != null) {
      return course.currentUserReview;
    }

    for (final review in course.reviews) {
      if (review.isCurrentUserReview) {
        return review;
      }
    }

    return null;
  }
}

class _CourseReviewCard extends StatelessWidget {
  const _CourseReviewCard({required this.review, this.onEdit});

  final CourseReviewModel review;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateLabel = MaterialLocalizations.of(
      context,
    ).formatShortDate(review.createdAt);

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      borderColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    dateLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < review.rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  tooltip: S.of(context).courseReviewEditAction,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                  padding: EdgeInsets.zero,
                  splashRadius: 18,
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.08,
                    ),
                    foregroundColor: theme.colorScheme.primary,
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
