import 'package:cached_network_image/cached_network_image.dart';
import 'package:codium/core/utils/constants.dart';
import 'package:codium/core/widgets/course_info.dart';
import 'package:codium/core/widgets/get_button.dart';
import 'package:codium/repositories/codium_courses/models/course.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    required this.course,
    super.key,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              height: 140,
              width: 140,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              imageUrl: course.imagePath,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Image(
                image: AssetImage(Constants.placeholderCourseImagePath),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    course.title,
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    course.previewDescription,
                    style: theme.textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: CourseInfo(course: course),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GetButton(
                      price: course.price,
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
