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
    return Wrapper(
      child: ListView(
        children: [
          CourseHeader(course: course, isPurchased: isPurchased),
          CourseMetaInfo(course: course),
          CourseTabSection(course: course),
        ],
      ),
    );
  }
}
