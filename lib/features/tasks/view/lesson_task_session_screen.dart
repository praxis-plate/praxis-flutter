import 'dart:async';

import 'package:codium/core/router/route_constants.dart';
import 'package:codium/core/utils/duration.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/domain/usecases/tasks/get_task_by_id_usecase.dart';
import 'package:codium/domain/usecases/tasks/request_task_hint_usecase.dart';
import 'package:codium/domain/usecases/tasks/submit_task_answer_usecase.dart';
import 'package:codium/features/tasks/bloc/bloc.dart';
import 'package:codium/features/tasks/renderers/task_renderer.dart';
import 'package:codium/features/tasks/widgets/widgets.dart';
import 'package:codium/l10n/app_localizations.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LessonTaskSessionScreen extends StatefulWidget {
  final int lessonId;

  const LessonTaskSessionScreen({super.key, required this.lessonId});

  @override
  State<LessonTaskSessionScreen> createState() =>
      _LessonTaskSessionScreenState();
}

class _LessonTaskSessionScreenState extends State<LessonTaskSessionScreen> {
  Timer? _autoAdvanceTimer;

  void _exitSession(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(RouteConstants.learning);
  }

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

  String _resolveSessionErrorMessage(
    SessionErrorState state,
    AppLocalizations s,
  ) {
    if (state.message != null && state.message!.isNotEmpty) {
      return state.message!;
    }

    switch (state.type) {
      case LessonTaskSessionErrorType.noTasks:
        return s.taskSessionNoTasks;
      case LessonTaskSessionErrorType.generic:
        return s.taskError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final userProfile = UserScope.of(context, listen: false);
    final renderer = GetIt.I<TaskRenderer>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<LessonTaskSessionBloc>()
            ..add(
              StartSessionEvent(
                lessonId: widget.lessonId,
                userId: userProfile.id,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => TaskBloc(
            GetIt.I<GetTaskByIdUseCase>(),
            GetIt.I<SubmitTaskAnswerUseCase>(),
            GetIt.I<RequestTaskHintUseCase>(),
            userId: userProfile.id,
          )..add(const LoadTaskEvent(1)),
        ),
        BlocProvider(
          create: (context) => GetIt.I<TaskHintCubit>(param1: userProfile.id),
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
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(s.taskSessionLoading),
                backgroundColor: Colors.transparent,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
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
            final errorMessage = _resolveSessionErrorMessage(sessionState, s);
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(s.taskError),
                backgroundColor: Colors.transparent,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
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
                        errorMessage,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _exitSession(context),
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
                        _exitSession(context);
                      }
                    }
                  }
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: Text(
                      _getTaskTypeTitle(sessionState.currentTask, context),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        final shouldExit = await _showExitConfirmationDialog(
                          context,
                        );
                        if (shouldExit && context.mounted) {
                          _exitSession(context);
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
                              return renderer.build(context, taskState.task);
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
                              return TaskFeedbackCorrectWidget(
                                task: taskState.task,
                                result: taskState.result,
                              );
                            }

                            if (taskState is TaskAnswerIncorrectState) {
                              return TaskFeedbackIncorrectWidget(
                                task: taskState.task,
                                result: taskState.result,
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
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: SizedBox.expand(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    borderRadius: BorderRadius.circular(20),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.celebration,
                              color: theme.colorScheme.primary,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(s.taskSessionCompleteTitle),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          s.taskSessionCompleteMessage,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 20),
                        SummaryRow(
                          icon: Icons.emoji_events,
                          label: s.taskSessionTotalXp,
                          value: '${sessionState.totalXpEarned} XP',
                          theme: theme,
                        ),
                        const SizedBox(height: 12),
                        SummaryRow(
                          icon: Icons.check_circle,
                          label: s.taskSessionAccuracy,
                          value:
                              '${sessionState.accuracyPercentage.toStringAsFixed(1)}%',
                          theme: theme,
                        ),
                        const SizedBox(height: 12),
                        SummaryRow(
                          icon: Icons.timer,
                          label: s.taskSessionTimeSpent,
                          value: DurationFormatter.formatSeconds(
                            sessionState.timeSpentSeconds,
                            s,
                          ),
                          theme: theme,
                        ),
                        const SizedBox(height: 12),
                        SummaryRow(
                          icon: Icons.task_alt,
                          label: s.taskSessionTasksCompleted,
                          value:
                              '${sessionState.correctTasks}/${sessionState.totalTasks}',
                          theme: theme,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              _exitSession(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                            child: Text(s.done),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
