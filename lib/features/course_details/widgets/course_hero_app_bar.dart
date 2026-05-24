import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/core/utils/constants.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/course_details/widgets/course_primary_action_button.dart';
import 'package:praxis/s.dart';

class CourseHeroAppBar extends StatelessWidget {
  const CourseHeroAppBar({
    super.key,
    required this.course,
    required this.isPurchased,
    required this.userProfile,
  });

  final CourseModel course;
  final bool isPurchased;
  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
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
          final isCollapsed =
              constraints.maxHeight <= kToolbarHeight + topPadding + 8;

          return Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: course.thumbnailUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: theme.colorScheme.surfaceContainerHighest),
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
                      const Align(
                        alignment: Alignment.topLeft,
                        child: _CourseBackButton(),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IgnorePointer(
                          ignoring: !isCollapsed,
                          child: AnimatedOpacity(
                            opacity: isCollapsed ? 1 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: CoursePrimaryActionButton(
                                course: course,
                                isPurchased: isPurchased,
                                userProfile: userProfile,
                                compact: true,
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
    );
  }
}

class _CourseBackButton extends StatelessWidget {
  const _CourseBackButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton.icon(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        }
      },
      icon: const Icon(Icons.arrow_back_ios_rounded),
      label: Text(S.of(context).goBack),
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurface,
        textStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
