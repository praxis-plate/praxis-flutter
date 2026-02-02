import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/features/course_details/widgets/meta_item.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class CourseMetaInfo extends StatelessWidget {
  const CourseMetaInfo({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Builder(
          builder: (context) {
            final s = S.of(context);
            final priceDisplay = course.pricing.price.amount == 0
                ? s.free
                : '${course.pricing.price.amount}';

            return ListView(
              scrollDirection: Axis.horizontal,
              children: [
                MetaItem(value: priceDisplay, label: s.courseDetailsPrice),
                MetaItem(value: course.author, label: s.courseDetailsAuthor),
                MetaItem(
                  value: '${course.statistics.averageRating}/5',
                  label: s.courseDetailsRating,
                ),
                MetaItem(
                  value: '${course.totalTasks}',
                  label: s.courseDetailsLessonsLabel,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
