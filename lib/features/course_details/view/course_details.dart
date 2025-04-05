import 'package:codium/core/widgets/course_card.dart';
import 'package:codium/core/widgets/course_carousel.dart';
import 'package:codium/core/widgets/wrapper.dart';
import 'package:codium/repositories/codium_courses/models/course.dart';
import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({
    required this.course,
    super.key,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courses = [
      Course(
        title: 'Course-1',
        previewDescription: 'Preview Description',
        imagePath: 'assets/images/course_1.png',
        author: 'Author',
        taskNodes: [],
      ),
    ];
    final courseCards = courses.map((e) => CourseCard(course: e)).toList();
    final tableOfContents = course.tableOfContents();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COURSE-1',
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Wrapper(
        child: ListView(
          children: [
            CourseCard(course: courses.first),
            const SizedBox(height: 16),
            const Divider(
              indent: 0,
              endIndent: 0,
            ),
            CourseDetailsList(course: course),
            const Divider(
              indent: 0,
              endIndent: 0,
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Text(
              course.description!,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Table of contents',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Text(
              tableOfContents,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Recommend',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            CourseCarousel(
              courseCards: courseCards,
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailsList extends StatelessWidget {
  const CourseDetailsList({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Detail(
              value: '${course.price}',
              label: 'Price',
            ),
            Detail(
              value: course.author,
              label: 'Author',
            ),
            Detail(
              value: '${course.ratingScores}/5',
              label: 'Rating',
            ),
            Detail(
              value: '${course.lessonsCount}',
              label: 'Lessons',
            ),
          ],
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  const Detail({
    required this.value,
    required this.label,
    super.key,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: theme.textTheme.titleSmall,
          ),
          Text(
            label,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
