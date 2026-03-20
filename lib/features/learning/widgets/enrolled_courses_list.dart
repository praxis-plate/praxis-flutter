import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EnrolledCoursesList extends StatelessWidget {
  const EnrolledCoursesList({super.key, required this.courses});

  final List<CourseModel> courses;

  @override
  Widget build(BuildContext context) {
    final userProfile = UserScope.of(context);

    return Wrapper(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: courses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            userProfile: userProfile,
            course: course,
            isPurchased: true,
            onPressed: () => context.push('/course/${course.id}/learn'),
          );
        },
      ),
    );
  }
}
