import 'dart:async';

import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/utils/duration.dart';
import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/domain/usecases/tasks/get_task_by_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/request_task_hint_usecase.dart';
import 'package:codium/domain/usecases/tasks/submit_task_answer_usecase.dart';
import 'package:codium/features/tasks/bloc/bloc.dart';
import 'package:codium/features/tasks/widgets/widgets.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LessonTaskSessionScreen extends StatefulWidget {
  final int lessonId;
  final int userId;

  const LessonTaskSessionScreen({
    super.key,
    required this.lessonId,
    required this.userId,
  });

  @override
  State<LessonTaskSessionScreen> createState() =>
      _LessonTaskSessionScreenState();
}

class _LessonTaskSessionScreenState extends State<LessonTaskSessionScreen> {
  Timer? _autoAdvanceTimer;

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _handleTaskCompletion(
    BuildContext context,
    TaskState taskState,
    SessionActiveState sessionState,
  ) {
    if (taskState is TaskAnswerCorrectState) {
      context.read<LessonTaskSessionBloc>().add(
        CompleteCurrentTaskEvent(
          isCorrect: true,
          xpEarned: taskState.result.xpEarned,
        ),
      );

      if (!sessionState.isLastTask) {
        _autoAdvanceTimer?.cancel();
        _autoAdvanceTimer = Timer(const Duration(seconds: 2), () {
          if (!mounted) return;

          final sessionBloc = context.read<LessonTaskSessionBloc>();
          final taskBloc = context.read<TaskBloc>();
          final currentSessionState = sessionBloc.state;

          if (currentSessionState is SessionActiveState) {
            taskBloc.add(LoadTaskEvent(currentSessionState.currentTask.id));
          }
        });
      }
    } else if (taskState is TaskAnswerIncorrectState) {
      context.read<LessonTaskSessionBloc>().add(
        CompleteCurrentTaskEvent(
          isCorrect: false,
          xpEarned: taskState.result.xpEarned,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthAuthenticatedState
        ? authState.userId
        : null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<LessonTaskSessionBloc>()
            ..add(
              StartSessionEvent(
                lessonId: widget.lessonId,
                userId: widget.userId,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => TaskBloc(
            GetIt.I<GetTaskByIdUseCase>(),
            GetIt.I<SubmitTaskAnswerUseCase>(),
            GetIt.I<RequestTaskHintUseCase>(),
            userId: userId,
          )..add(const LoadTaskEvent(1)),
        ),
        BlocProvider(
          create: (context) => GetIt.I<TaskHintCubit>(param1: widget.userId),
        ),
      ],
      child: BlocConsumer<LessonTaskSessionBloc, LessonTaskSessionState>(
        listener: (context, sessionState) {
          if (sessionState is SessionCompletedState) {
            _showSessionSummaryDialog(context, sessionState);
          }
        },
        builder: (context, sessionState) {
          if (sessionState is SessionLoadingState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(s.taskSessionLoading),
                backgroundColor: theme.colorScheme.surface,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      s.taskSessionLoading,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          }

          if (sessionState is SessionErrorState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(s.taskError),
                backgroundColor: theme.colorScheme.surface,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      s.taskError,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        sessionState.message,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: Text(s.goBack),
                    ),
                  ],
                ),
              ),
            );
          }

          if (sessionState is SessionActiveState) {
            return BlocListener<TaskBloc, TaskState>(
              listener: (context, taskState) {
                _handleTaskCompletion(context, taskState, sessionState);
              },
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) async {
                  if (!didPop) {
                    final shouldExit = await _showExitConfirmationDialog(
                      context,
                    );
                    if (shouldExit && mounted) {
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  }
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      _getTaskTypeTitle(sessionState.currentTask, context),
                    ),
                    backgroundColor: theme.colorScheme.surface,
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final shouldExit = await _showExitConfirmationDialog(
                          context,
                        );
                        if (shouldExit && mounted) {
                          navigator.pop();
                        }
                      },
                    ),
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: TaskProgressBar(
                          completedTasks: sessionState.completedTasksCount,
                          totalTasks: sessionState.tasks.length,
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<TaskBloc, TaskState>(
                          builder: (context, taskState) {
                            if (taskState is TaskLoadingState) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      s.taskLoading,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (taskState is TaskErrorState) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: theme.colorScheme.error,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      s.taskError,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: theme.colorScheme.error,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                      ),
                                      child: Text(
                                        taskState.message,
                                        style: theme.textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<TaskBloc>().add(
                                          LoadTaskEvent(
                                            sessionState.currentTask.id,
                                          ),
                                        );
                                      },
                                      child: Text(s.retry),
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (taskState is TaskLoadedState) {
                              return _buildTaskContent(context, taskState.task);
                            }

                            if (taskState is TaskAnswerValidatingState) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      s.taskValidating,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (taskState is TaskAnswerCorrectState) {
                              return TaskFeedbackWidget(
                                task: taskState.task,
                                result: taskState.result,
                                isCorrect: true,
                              );
                            }

                            if (taskState is TaskAnswerIncorrectState) {
                              return TaskFeedbackWidget(
                                task: taskState.task,
                                result: taskState.result,
                                isCorrect: false,
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _getTaskTypeTitle(TaskModel task, BuildContext context) {
    final s = S.of(context);
    return task.getLocalizedTitle(
      () => s.taskMultipleChoice,
      () => s.taskCodeCompletion,
      () => s.taskMatching,
      () => s.taskTextInput,
    );
  }

  Widget _buildTaskContent(BuildContext context, TaskModel task) {
    final theme = Theme.of(context);

    // Используем полиморфизм - проверяем тип во время выполнения
    switch (task) {
      case MultipleChoiceTaskModel():
        return MultipleChoiceTaskWidget(task: task);
      case CodeCompletionTaskModel():
        return CodeCompletionTaskWidget(task: task);
      case MatchingTaskModel():
        return MatchingTaskWidget(task: task);
      case TextInputTaskModel():
        return TextInputTaskWidget(task: task);
      default:
        return Center(
          child: Text('Unknown task type', style: theme.textTheme.bodyLarge),
        );
    }
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final s = S.of(context);
    final theme = Theme.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.taskSessionExitTitle),
        content: Text(s.taskSessionExitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              s.cancel,
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(s.exit),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _showSessionSummaryDialog(
    BuildContext context,
    SessionCompletedState sessionState,
  ) {
    final s = S.of(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration, color: theme.colorScheme.primary, size: 32),
            const SizedBox(width: 12),
            Text(s.taskSessionCompleteTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.taskSessionCompleteMessage,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SummaryRow(
              icon: Icons.emoji_events,
              label: s.taskSessionTotalXp,
              value: '${sessionState.totalXpEarned} XP',
              theme: theme,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              icon: Icons.check_circle,
              label: s.taskSessionAccuracy,
              value: '${sessionState.accuracyPercentage.toStringAsFixed(1)}%',
              theme: theme,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              icon: Icons.timer,
              label: s.taskSessionTimeSpent,
              value: DurationFormatter.formatSeconds(
                sessionState.timeSpentSeconds,
                s,
              ),
              theme: theme,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              icon: Icons.task_alt,
              label: s.taskSessionTasksCompleted,
              value: '${sessionState.correctTasks}/${sessionState.totalTasks}',
              theme: theme,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: Text(s.done),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
