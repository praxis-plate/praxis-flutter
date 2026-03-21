import 'package:codium/core/error/app_error_code_extension.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/features.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CourseLearningScreen extends StatelessWidget {
  const CourseLearningScreen({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context) {
    final userId = UserScope.of(context, listen: false).id;

    return BlocProvider(
      create: (context) =>
          GetIt.I<CourseLearningBloc>()
            ..add(LoadCourseLearning(courseId: courseId, userId: userId)),
      child: const _CourseLearningView(),
    );
  }
}

class _CourseLearningView extends StatelessWidget {
  const _CourseLearningView();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: BlocBuilder<CourseLearningBloc, CourseLearningState>(
          builder: (context, state) {
            if (state is CourseLearningLoaded) {
              return Text(
                state.course.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              );
            }
            return Text(
              s.loading,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: BlocBuilder<CourseLearningBloc, CourseLearningState>(
            builder: (context, state) {
              if (state is CourseLearningLoaded) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            s.lessonsCompleted(
                              state.statistics.solvedTasks,
                              state.statistics.totalTasks,
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            s.courseProgressPercent(
                              state.statistics.progress.round(),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      CourseProgressBar(userCourseStatistics: state.statistics),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      body: BlocBuilder<CourseLearningBloc, CourseLearningState>(
        builder: (context, state) {
          if (state is CourseLearningLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseLearningError) {
            return ErrorScreen(
              message: state.failure.code.localizedMessage(context),
              onRetry: () {
                context.read<CourseLearningBloc>().add(const RefreshProgress());
              },
            );
          }

          if (state is CourseLearningLoaded) {
            final completedLessonIds = state.lessonProgress
                .where((progress) => progress.isCompleted)
                .map((progress) => progress.lessonId)
                .toSet();

            return _LessonsList(
              courseId: state.course.id,
              completedLessonIds: completedLessonIds,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LessonsList extends StatelessWidget {
  final int courseId;
  final Set<int> completedLessonIds;

  const _LessonsList({
    required this.courseId,
    required this.completedLessonIds,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocProvider(
      create: (context) =>
          GetIt.I<LessonsListBloc>()
            ..add(LoadLessonsListEvent(courseId: courseId)),
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
                  LoadLessonsListEvent(courseId: courseId),
                );
              },
            );
          }

          if (state is LessonsListLoadedState) {
            if (state.lessons.isEmpty) {
              return Center(child: Text(s.noLessonsAvailable));
            }

            return Wrapper(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.lessons.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final lesson = state.lessons[index];
                  return LessonCard(
                    lesson: lesson,
                    taskCount: state.taskCounts[lesson.id],
                    isCompleted: completedLessonIds.contains(lesson.id),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
