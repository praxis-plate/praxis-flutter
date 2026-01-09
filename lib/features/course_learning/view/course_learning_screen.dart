import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/course_learning/bloc/course_learning_bloc.dart';
import 'package:codium/features/course_learning/bloc/lessons_list_bloc.dart';
import 'package:codium/features/course_learning/widgets/widgets.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CourseLearningScreen extends StatelessWidget {
  const CourseLearningScreen({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<CourseLearningBloc>()
            ..add(LoadCourseLearning(courseId: courseId, userId: 1)),
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
        title: BlocBuilder<CourseLearningBloc, CourseLearningState>(
          builder: (context, state) {
            if (state is CourseLearningLoaded) {
              return Text(
                state.course.title,
                style: theme.textTheme.titleLarge,
              );
            }
            return Text(s.loading, style: theme.textTheme.titleLarge);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: BlocBuilder<CourseLearningBloc, CourseLearningState>(
            builder: (context, state) {
              if (state is CourseLearningLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      CourseProgressBar(userCourseStatistics: state.statistics),
                      const SizedBox(height: 8),
                      Text(
                        '${state.statistics.progress.toStringAsFixed(0)}% ${s.complete}',
                        style: theme.textTheme.bodySmall,
                      ),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CourseLearningBloc>().add(
                        const RefreshProgress(),
                      );
                    },
                    child: Text(s.retry),
                  ),
                ],
              ),
            );
          }

          if (state is CourseLearningLoaded) {
            return _LessonsList(courseId: state.course.id);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LessonsList extends StatelessWidget {
  final int courseId;

  const _LessonsList({required this.courseId});

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
            return Center(child: Text(state.message));
          }

          if (state is LessonsListLoadedState) {
            if (state.lessons.isEmpty) {
              return Center(child: Text(s.noLessonsAvailable));
            }

            return Wrapper(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.lessons.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final lesson = state.lessons[index];
                  return LessonCard(lesson: lesson);
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
