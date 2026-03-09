import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/features/course_details/widgets/description_content.dart';
import 'package:codium/features/course_details/widgets/table_of_contents_content.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class CourseTabBar extends StatelessWidget {
  const CourseTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return TabBar(
      tabs: [
        Tab(text: s.courseDetailsDescriptionTab),
        Tab(text: s.courseDetailsContentsTab),
      ],
    );
  }
}

class CourseTabSection extends StatelessWidget {
  final CourseModel course;

  const CourseTabSection({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        DescriptionContent(course: course),
        const TableOfContentsContent(),
      ],
    );
  }
}
