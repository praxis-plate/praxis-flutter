import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/features/course_details/widgets/course_header.dart';
import 'package:codium/features/course_details/widgets/course_meta_info.dart';
import 'package:codium/features/course_details/widgets/course_tab_section.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Wrapper(
                child: Column(
                  children: [
                    CourseHeader(course: course, isPurchased: isPurchased),
                    CourseMetaInfo(course: course),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _CourseDetailTabBarDelegate(
                child: ColoredBox(
                  color: theme.scaffoldBackgroundColor,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CourseTabBar(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: CourseTabSection(course: course),
      ),
    );
  }
}

class _CourseDetailTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _CourseDetailTabBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _CourseDetailTabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
