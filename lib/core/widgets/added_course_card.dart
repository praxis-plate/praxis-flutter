import 'package:cached_network_image/cached_network_image.dart';
import 'package:codium/core/utils/constants.dart';
import 'package:codium/core/widgets/course_info.dart';
import 'package:codium/core/widgets/course_progress_bar.dart';
import 'package:codium/repositories/codium_courses/models/user_course_statistics.dart';
import 'package:flutter/material.dart';

class AddedCourseCard extends StatelessWidget {
  const AddedCourseCard({
    required this.courseStatistics,
    super.key,
  });

  final UserCourseStatistics courseStatistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 120,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              height: 120,
              width: 120,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              imageUrl: courseStatistics.course.imagePath,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Image.asset(Constants.placeholderCourseImagePath),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  courseStatistics.course.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const Spacer(),
                CourseProgressBar(
                  courseStatistics: courseStatistics,
                ),
                const SizedBox(height: 8),
                CourseInfo(
                  course: courseStatistics.course,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        label: Text(
                          'Continue',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        onPressed: () {},
                        iconAlignment: IconAlignment.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
