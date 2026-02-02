import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/features/learning/widgets/enrolled_course_card.dart';
import 'package:flutter/material.dart';

class EnrolledCoursesList extends StatelessWidget {
  const EnrolledCoursesList({super.key, required this.courses});

  final List<CourseModel> courses;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: courses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = courses[index];
          return EnrolledCourseCard(course: course);
        },
      ),
    );
  }
}
