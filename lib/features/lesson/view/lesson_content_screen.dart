import 'package:codium/core/error/app_error_code_extension.dart';
import 'package:codium/core/bloc/achievement_notification/achievement_notification_cubit.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/task/course_task.dart';
import 'package:codium/features/lesson/bloc/lesson_content_bloc.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LessonContentScreen extends StatelessWidget {
  const LessonContentScreen({
    super.key,
    required this.lessonId,
    required this.courseId,
  });

  final String lessonId;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<LessonContentBloc>()
        ..add(
          LoadLessonContent(lessonId: lessonId, userId: '', courseId: courseId),
        ),
      child: _LessonContentView(lessonId: lessonId, courseId: courseId),
    );
  }
}

class _LessonContentView extends StatelessWidget {
  const _LessonContentView({required this.lessonId, required this.courseId});

  final String lessonId;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocListener<LessonContentBloc, LessonContentState>(
      listener: (context, state) {
        if (state is LessonContentCompleted) {
          if (state.achievements.isNotEmpty) {
            for (final achievement in state.achievements) {
              context.read<AchievementNotificationCubit>().showAchievement(
                achievement,
              );
            }
          }
          _showCompletionDialog(context, state);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 16,
          title: BlocBuilder<LessonContentBloc, LessonContentState>(
            builder: (context, state) {
              if (state is LessonContentLoaded) {
                return Text(
                  state.lesson.title,
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
        ),
        body: BlocBuilder<LessonContentBloc, LessonContentState>(
          builder: (context, state) {
            if (state is LessonContentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LessonContentError) {
              return ErrorScreen(
                message: state.failure.code.localizedMessage(context),
                onRetry: () {
                  context.read<LessonContentBloc>().add(
                    LoadLessonContent(
                      lessonId: lessonId,
                      userId: '',
                      courseId: courseId,
                    ),
                  );
                },
              );
            }

            if (state is LessonContentLoaded) {
              return _LessonContent(
                lesson: state.lesson,
                isCompleted: state.isCompleted,
              );
            }

            if (state is LessonContentCompleting) {
              return const Center(child: CircularProgressIndicator());
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showCompletionDialog(
    BuildContext context,
    LessonContentCompleted state,
  ) {
    final s = S.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.lessonCompleted),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(s.coinsEarned(state.coinsEarned)),
            if (state.achievements.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(s.achievementUnlocked),
              ...state.achievements.map(
                (achievement) => Text(achievement.title),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  final CourseTask lesson;
  final bool isCompleted;

  const _LessonContent({required this.lesson, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

        return Wrapper(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        lesson.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushNamed(
                          'lesson-task-session',
                          pathParameters: {'lessonId': lesson.id.toString()},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: Text(
                        s.startLearning,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (!isCompleted) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          final bloc = context.read<LessonContentBloc>();
                          final state = bloc.state;
                          if (state is LessonContentLoaded) {
                            bloc.add(
                              CompleteLesson(
                                userId: '',
                                lessonId: lesson.id.toString(),
                                courseId: '',
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          s.completeLesson,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
