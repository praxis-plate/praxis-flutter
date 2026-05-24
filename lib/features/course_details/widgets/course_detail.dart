import 'package:flutter/material.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/models.dart';
import 'package:praxis/features/course_details/widgets/course_header.dart';
import 'package:praxis/features/course_details/widgets/course_hero_app_bar.dart';
import 'package:praxis/features/course_details/widgets/course_tab_section.dart';

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
    final userProfile = UserScope.of(context);

    return CustomScrollView(
      slivers: [
        CourseHeroAppBar(
          course: course,
          isPurchased: isPurchased,
          userProfile: userProfile,
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
