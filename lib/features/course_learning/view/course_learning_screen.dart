import 'package:codium/core/error/app_error_code_extension.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/lesson/lesson_model.dart';
import 'package:codium/features/features.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

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
      child: _CourseLearningView(userId: userId, courseId: courseId),
    );
  }
}

class _CourseLearningView extends StatelessWidget {
  const _CourseLearningView({required this.userId, required this.courseId});

  final String userId;
  final int courseId;

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () => context.push('/course/$courseId'),
              tooltip: s.courseDetailsTitle,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                foregroundColor: theme.colorScheme.primary,
              ),
              icon: const Icon(Icons.info_outline),
            ),
          ),
        ],
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
              userId: userId,
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
  final String userId;

  const _LessonsList({
    required this.courseId,
    required this.completedLessonIds,
    required this.userId,
  });

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

          if (state is LessonsListLoadedState) {
            if (state.lessons.isEmpty) {
              return Center(child: Text(s.noLessonsAvailable));
            }

            final nextLessonId = _resolveNextLessonId(
              state.lessons,
              completedLessonIds,
            );

            final widgets = _buildLessonSectionWidgets(
              context,
              state,
              completedLessonIds,
              courseId,
              nextLessonId,
            );

            return Wrapper(
              child: ListView(padding: EdgeInsets.zero, children: widgets),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<Widget> _buildLessonSectionWidgets(
    BuildContext context,
    LessonsListLoadedState state,
    Set<int> completedLessonIds,
    int courseId,
    int? nextLessonId,
  ) {
    final modules = List.of(state.modules)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final lessonsByModule = <int, List<LessonModel>>{};

    if (modules.isEmpty) {
      final flatWidgets = _buildFlatLessonWidgets(state, completedLessonIds);
      return _prependLearningActions(flatWidgets, courseId, nextLessonId);
    }

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
        _ModuleHeader(title: module.title, description: module.description),
      );

      for (final lesson in lessons) {
        widgets.add(
          LessonCard(
            lesson: lesson,
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

    return _prependLearningActions(widgets, courseId, nextLessonId);
  }

  List<Widget> _buildFlatLessonWidgets(
    LessonsListLoadedState state,
    Set<int> completedLessonIds,
  ) {
    final lessons = List.of(state.lessons)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final widgets = <Widget>[];

    for (final lesson in lessons) {
      widgets.add(
        LessonCard(
          lesson: lesson,
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

    final nextLesson = ordered.firstWhere(
      (lesson) => !completedLessonIds.contains(lesson.id),
      orElse: () => ordered.last,
    );

    return nextLesson.id;
  }

  List<Widget> _prependLearningActions(
    List<Widget> widgets,
    int courseId,
    int? nextLessonId,
  ) {
    if (nextLessonId == null) {
      return widgets;
    }

    return [
      _CourseLearningResumeCard(nextLessonId: nextLessonId),
      const SizedBox(height: 12),
      ...widgets,
    ];
  }
}

class _CourseLearningResumeCard extends StatelessWidget {
  const _CourseLearningResumeCard({required this.nextLessonId});

  final int nextLessonId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Material(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.learningContinueHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.push('/lesson/$nextLessonId/tasks'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  s.learningContinue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleHeader extends StatelessWidget {
  final String title;
  final String description;

  const _ModuleHeader({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDescription = description.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (hasDescription) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
