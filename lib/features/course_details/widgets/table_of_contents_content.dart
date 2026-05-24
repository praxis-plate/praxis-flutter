import 'package:praxis/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:praxis/features/course_details/widgets/course_contents_module_section.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TableOfContentsContent extends StatelessWidget {
  const TableOfContentsContent({super.key});

  void _handleLessonTap(
    BuildContext context, {
    required bool isPurchased,
    required int courseId,
    required int lessonId,
  }) {
    if (!isPurchased) {
      final s = S.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.purchaseCourseToViewLessons)));
      return;
    }

    context.pushNamed(
      'lesson-content',
      pathParameters: {'lessonId': lessonId.toString()},
      queryParameters: {'courseId': courseId.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<CourseDetailBloc, CourseDetailState>(
      builder: (context, state) {
        if (state is! CourseDetailLoadSuccessState) {
          return const Center(child: CircularProgressIndicator());
        }

        final tableOfContents = state.tableOfContents;
        final isPurchased = state.isPurchased;
        if (tableOfContents == null) {
          return Center(child: Text(s.noLessonsAvailable));
        }

        final modules = List.of(tableOfContents.modules)
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        return Column(
          children: modules
              .expand(
                (module) => [
                  CourseContentsModuleSection(
                    module: module,
                    isPurchased: isPurchased,
                    onLessonTap: (lessonId) => _handleLessonTap(
                      context,
                      isPurchased: isPurchased,
                      courseId: state.course.id,
                      lessonId: lessonId,
                    ),
                  ),
                ],
              )
              .toList(),
        );
      },
    );
  }
}
