import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/lesson/lesson_model.dart';
import 'package:praxis/features/course_learning/bloc/bloc.dart';
import 'package:praxis/features/course_learning/widgets/course_learning_resume_card.dart';
import 'package:praxis/features/course_learning/widgets/lesson_card.dart';
import 'package:praxis/features/course_learning/widgets/module_header.dart';
import 'package:praxis/s.dart';

class LessonsList extends StatelessWidget {
  const LessonsList({
    super.key,
    required this.courseId,
    required this.completedLessonIds,
    required this.userId,
    this.topContent,
  });

  final int courseId;
  final Set<int> completedLessonIds;
  final String userId;
  final Widget? topContent;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocProvider(
      create: (context) =>
          GetIt.I<LessonsListBloc>()
            ..add(LoadLessonsListEvent(courseId: courseId, userId: userId)),
      child: BlocBuilder<LessonsListBloc, LessonsListState>(
        builder: (context, state) {
          if (state is LessonsListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LessonsListErrorState) {
            return ErrorScreen(
              message: state.failure.code.localizedMessage(context),
              onRetry: () {
                context.read<LessonsListBloc>().add(
                  LoadLessonsListEvent(courseId: courseId, userId: userId),
                );
              },
            );
          }

          if (state is! LessonsListLoadedState) {
            return const SizedBox.shrink();
          }

          if (state.lessons.isEmpty) {
            return Center(child: Text(s.noLessonsAvailable));
          }

          final nextLessonId = _resolveNextLessonId(
            state.lessons,
            completedLessonIds,
          );
          final lessonWidgets = _buildLessonWidgets(
            state,
            completedLessonIds,
            courseId,
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            children: [
              if (topContent != null) ...[
                topContent!,
                const SizedBox(height: 12),
              ],
              if (nextLessonId != null) ...[
                CourseLearningResumeCard(
                  courseId: courseId,
                  nextLessonId: nextLessonId,
                ),
                const SizedBox(height: 12),
              ],
              ...lessonWidgets,
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildLessonWidgets(
    LessonsListLoadedState state,
    Set<int> completedLessonIds,
    int courseId,
  ) {
    final modules = List.of(state.modules)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    if (modules.isEmpty) {
      return _buildFlatLessonWidgets(state, completedLessonIds, courseId);
    }

    final lessonsByModule = <int, List<LessonModel>>{};
    for (final lesson in state.lessons) {
      lessonsByModule.putIfAbsent(lesson.moduleId, () => []).add(lesson);
    }

    for (final lessons in lessonsByModule.values) {
      lessons.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }

    final widgets = <Widget>[];
    for (final module in modules) {
      final lessons = lessonsByModule[module.id] ?? [];
      if (lessons.isEmpty) {
        continue;
      }

      widgets.add(
        ModuleHeader(title: module.title, description: module.description),
      );

      for (final lesson in lessons) {
        widgets.add(
          LessonCard(
            lesson: lesson,
            courseId: courseId,
            taskCount: state.taskCounts[lesson.id],
            completedTaskCount: state.completedTaskCounts[lesson.id] ?? 0,
            isCompleted: completedLessonIds.contains(lesson.id),
          ),
        );
        widgets.add(const SizedBox(height: 8));
      }

      widgets.add(const SizedBox(height: 8));
    }

    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }

    return widgets;
  }

  List<Widget> _buildFlatLessonWidgets(
    LessonsListLoadedState state,
    Set<int> completedLessonIds,
    int courseId,
  ) {
    final lessons = List.of(state.lessons)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final widgets = <Widget>[];

    for (final lesson in lessons) {
      widgets.add(
        LessonCard(
          lesson: lesson,
          courseId: courseId,
          taskCount: state.taskCounts[lesson.id],
          completedTaskCount: state.completedTaskCounts[lesson.id] ?? 0,
          isCompleted: completedLessonIds.contains(lesson.id),
        ),
      );
      widgets.add(const SizedBox(height: 8));
    }

    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }

    return widgets;
  }

  int? _resolveNextLessonId(
    List<LessonModel> lessons,
    Set<int> completedLessonIds,
  ) {
    if (lessons.isEmpty) {
      return null;
    }

    final ordered = List.of(lessons)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    for (final lesson in ordered) {
      if (!completedLessonIds.contains(lesson.id)) {
        return lesson.id;
      }
    }

    return null;
  }
}
