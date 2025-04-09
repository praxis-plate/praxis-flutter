import 'package:cached_network_image/cached_network_image.dart';
import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/utils/constants.dart';
import 'package:codium/core/widgets/course_info.dart';
import 'package:codium/core/widgets/user_provider.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/main/bloc/course_purchasing/course_purchasing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    required this.course,
    super.key,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) {
        if (prev is AuthAuthenticatedState && curr is AuthAuthenticatedState) {
          return prev.user.purchasedCourseIds != curr.user.purchasedCourseIds;
        }
        return false;
      },
      builder: (context, state) {
        return BlocBuilder<CoursePurchasingBloc, CoursePurchasingState>(
          buildWhen: (prev, curr) {
            return curr is CoursePurchasingLoadingState &&
                    curr.courseId == course.id ||
                curr is CoursePurchasingLoadSuccessState &&
                    curr.courseId == course.id ||
                curr is CoursePurchasingLoadErrorState &&
                    curr.courseId == course.id;
          },
          builder: (context, state) {
            final isPurchased = user.purchasedCourseIds.contains(course.id);
            final isProcessing = state is CoursePurchasingLoadingState &&
                state.courseId == course.id;

            return SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      height: 140,
                      width: 140,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      imageUrl: course.coverImage,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Image(
                        image: AssetImage(Constants.placeholderCourseImagePath),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            course.title,
                            style: theme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            course.previewDescription,
                            style: theme.textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: CourseInfo(course: course),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (!isPurchased)
                              _PurchaseButton(
                                course: course,
                                isProcessing: isProcessing,
                                state: state,
                              ),
                            if (isPurchased) const Flexible(child: PurchasedBadge()),
                          ],
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

class _PurchaseButton extends StatelessWidget {
  final Course course;
  final bool isProcessing;
  final CoursePurchasingState state;

  const _PurchaseButton({
    required this.course,
    required this.isProcessing,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton.icon(
        icon: isProcessing
            ? const CircularProgressIndicator()
            : const Icon(Icons.shopping_cart),
        label: Text(
          _getButtonText(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: _getTextColor(context),
              ),
        ),
        onPressed: isProcessing ? null : () => _handlePurchase(context),
      ),
    );
  }

  String _getButtonText() {
    if (state is CoursePurchasingLoadErrorState) return 'Retry';
    if (isProcessing) return 'Processing...';
    return 'Buy for ${course.pricing.price}';
  }

  Color _getTextColor(BuildContext context) {
    if (state is CoursePurchasingLoadErrorState) {
      return Theme.of(context).colorScheme.error;
    }
    return Theme.of(context).colorScheme.primary;
  }

  void _handlePurchase(BuildContext context) {
    final bloc = context.read<CoursePurchasingBloc>();
    if (!bloc.isClosed) {
      bloc.add(CoursePurchasingRequestEvent(course.id));
    }
  }
}

class PurchasedBadge extends StatelessWidget {
  final Color? color;
  final double iconSize;
  final double fontSize;
  final bool showText;

  const PurchasedBadge({
    super.key,
    this.color,
    this.iconSize = 20,
    this.fontSize = 14,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = color ?? theme.colorScheme.primary;

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.toDouble(), end: 1.toDouble()),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.toDouble(),
          child: Transform.scale(
            scale: Curves.easeOutBack.transform(value.toDouble()),
            child: child,
          ),
        );
      },
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 40,
          minWidth: 60,
          maxWidth: 150,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: badgeColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: iconSize,
              color: badgeColor,
            ),
            if (showText) ...[
              const SizedBox(width: 6),
              Text(
                'Куплено',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: badgeColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
