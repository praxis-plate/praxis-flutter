import 'package:codium/core/bloc/achievement_notification/achievement_notification_cubit.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/task/course_task.dart';
import 'package:codium/features/lesson/bloc/lesson_content_bloc.dart';
import 'package:codium/l10n/app_localizations.dart';
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
      child: const _LessonContentView(),
    );
  }
}

class _LessonContentView extends StatelessWidget {
  const _LessonContentView();

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
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
          title: BlocBuilder<LessonContentBloc, LessonContentState>(
            builder: (context, state) {
              if (state is LessonContentLoaded) {
                return Text(
                  state.lesson.title,
                  style: theme.textTheme.titleLarge,
                );
              }
              return Text(s.loading, style: theme.textTheme.titleLarge);
            },
          ),
        ),
        body: BlocBuilder<LessonContentBloc, LessonContentState>(
          builder: (context, state) {
            if (state is LessonContentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LessonContentError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: Text(s.retry),
                    ),
                  ],
                ),
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
    final s = AppLocalizations.of(context)!;

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
    final s = AppLocalizations.of(context)!;
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
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(lesson.content, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          if (!isCompleted)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: Text(
                      s.completeLesson,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
