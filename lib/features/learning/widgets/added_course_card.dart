import 'package:cached_network_image/cached_network_image.dart';
import 'package:codium/core/utils/constants.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/course/course_model.dart';
import 'package:codium/domain/models/models.dart';
import 'package:codium/features/course_learning/widgets/widgets.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddedCourseCard extends StatelessWidget {
  const AddedCourseCard({
    required this.course,
    required this.userCourseStatistics,
    super.key,
  });

  final CourseModel course;
  final UserCourseStatisticsModel userCourseStatistics;

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
              imageUrl: course.coverImage ?? '',
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
                  course.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const Spacer(),
                CourseProgressBar(userCourseStatistics: userCourseStatistics),
                const SizedBox(height: 8),
                CourseInfo(
                  course: course,
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
                          S.of(context).learningContinue,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          context.push('/course/${course.id}');
                        },
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
