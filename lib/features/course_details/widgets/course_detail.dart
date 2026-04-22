import 'package:cached_network_image/cached_network_image.dart';
import 'package:praxis/core/utils/constants.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/course_details/widgets/course_header.dart';
import 'package:praxis/features/course_details/widgets/course_purchase_button.dart';
import 'package:praxis/features/course_details/widgets/course_tab_section.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseDetail extends StatelessWidget {
  final CourseModel course;
  final bool isPurchased;

  const CourseDetail({
    super.key,
    required this.course,
    required this.isPurchased,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final userProfile = UserScope.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 180,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final topPadding = MediaQuery.of(context).padding.top;
              final collapsed =
                  constraints.maxHeight <= kToolbarHeight + topPadding + 8;

              return Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: course.thumbnailUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      Constants.placeholderCourseImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.scaffoldBackgroundColor.withValues(alpha: 0.65),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                if (context.canPop()) {
                                  context.pop();
                                }
                              },
                              icon: const Icon(Icons.arrow_back_ios_rounded),
                              label: Text(s.goBack),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.onSurface,
                                textStyle: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IgnorePointer(
                              ignoring: !collapsed,
                              child: AnimatedOpacity(
                                opacity: collapsed ? 1 : 0,
                                duration: const Duration(milliseconds: 180),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: _AppBarAction(
                                    course: course,
                                    isPurchased: isPurchased,
                                    userProfile: userProfile,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Wrapper(
            child: Column(
              children: [
                CourseHeader(course: course, isPurchased: isPurchased),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: CourseTabSection(course: course)),
      ],
    );
  }
}

class _AppBarAction extends StatelessWidget {
  final CourseModel course;
  final bool isPurchased;
  final UserProfileModel userProfile;

  const _AppBarAction({
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

    return CoursePurchaseButton(
      courseId: course.id,
      priceInCoins: course.priceInCoins,
      userProfile: userProfile,
      compact: true,
    );
  }
}
