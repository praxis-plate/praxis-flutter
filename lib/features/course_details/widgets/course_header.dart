import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/features/course_details/widgets/start_learning_button.dart';
import 'package:flutter/material.dart';

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
    final userProfile = UserScope.of(context);

    return Column(
      children: [
        CourseCard(
          userProfile: userProfile,
          course: course,
          onPressed: null,
          isPurchased: isPurchased,
        ),
        if (isPurchased) ...[
          const SizedBox(height: 12),
          StartLearningButton(courseId: course.id),
        ],
        const SizedBox(height: 16),
        const Divider(indent: 0, endIndent: 0),
      ],
    );
  }
}
