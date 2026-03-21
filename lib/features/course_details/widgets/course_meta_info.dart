import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/features/course_details/widgets/meta_item.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class CourseMetaInfo extends StatelessWidget {
  const CourseMetaInfo({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 92,
      child: Builder(
        builder: (context) {
          final s = S.of(context);
          final priceDisplay = course.pricing.price.amount == 0
              ? s.free
              : '${course.pricing.price.amount}';

          final items = [
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
          ];

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.6),
              ),
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              separatorBuilder: (context, index) => VerticalDivider(
                width: 24,
                thickness: 1,
                color: theme.dividerColor.withValues(alpha: 0.6),
              ),
              itemBuilder: (context, index) => items[index],
            ),
          );
        },
      ),
    );
  }
}
