import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/user/user_course_statistics.dart';
import 'package:flutter/material.dart';

import 'enrolled_course_card.dart';

class EnrolledCoursesList extends StatelessWidget {
  const EnrolledCoursesList({
    super.key,
    required this.courses,
    required this.courseStatistics,
  });

  final List<CourseModel> courses;
  final Map<int, UserCourseStatistics> courseStatistics;

  @override
  Widget build(BuildContext context) {
    final userId = UserScope.of(context).id;

    return Wrapper(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: courses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = courses[index];
          return EnrolledCourseCard(
            course: course,
            statistics: courseStatistics[course.id],
            userId: userId,
          );
        },
      ),
    );
  }
}
