import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/task/task_models.dart';
import 'package:praxis/domain/usecases/lesson/get_lesson_by_id_usecase.dart';
import 'package:praxis/domain/usecases/tasks/get_task_by_id_usecase.dart';
import 'package:praxis/domain/usecases/tasks/request_task_hint_usecase.dart';
import 'package:praxis/domain/usecases/tasks/submit_task_answer_usecase.dart';
import 'package:praxis/features/tasks/bloc/bloc.dart';
import 'package:praxis/features/tasks/dialogs/dialogs.dart';
import 'package:praxis/features/tasks/renderers/task_renderer.dart';
import 'package:praxis/features/tasks/widgets/widgets.dart';
import 'package:praxis/l10n/app_localizations.dart';
import 'package:praxis/s.dart';

class TaskSessionScreen extends StatefulWidget {
  const TaskSessionScreen({super.key, required this.lessonId, this.courseId});

  final int lessonId;
  final String? courseId;

  @override
  State<TaskSessionScreen> createState() => _TaskSessionScreenState();
}

class _TaskSessionScreenState extends State<TaskSessionScreen> {
  Timer? _autoAdvanceTimer;
  String? _lessonTitle;
  bool _isCompletingLastTask = false;
  bool _isSessionSummaryDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _loadLessonTitle();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _exitSession(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go('/learning');
  }

  void _finishSession(BuildContext context) {
    if (context.canPop()) {
      context.pop();

      if (context.canPop()) {
        context.pop();
        return;
      }
    }

    final courseId = widget.courseId;
    if (courseId != null && courseId.isNotEmpty) {
      context.go('/course/$courseId/learn');
      return;
    }

    context.go('/learning');
  }

  Future<void> _loadLessonTitle() async {
    final result = await GetIt.I<GetLessonByIdUseCase>()(widget.lessonId);
    if (!mounted) {
      return;
    }

    setState(() {
      _lessonTitle = result.dataOrNull?.title;
    });
  }

  void _handleTaskCompletion(
    BuildContext context,
    TaskState taskState,
    SessionActiveState sessionState,
  ) {
    if (taskState is TaskAnswerCorrectState) {
      if (sessionState.isLastTask && !_isCompletingLastTask) {
        setState(() {
          _isCompletingLastTask = true;
        });
      }

      context.read<LessonTaskSessionBloc>().add(
        CompleteCurrentTaskEvent(
          isCorrect: true,
          xpEarned: taskState.result.xpEarned,
        ),
      );

      if (!sessionState.isLastTask) {
        _autoAdvanceTimer?.cancel();
        _autoAdvanceTimer = Timer(const Duration(seconds: 2), () {
          if (!mounted) {
            return;
          }

          final currentSessionState = context
              .read<LessonTaskSessionBloc>()
              .state;

          if (currentSessionState is SessionActiveState) {
            context.read<TaskBloc>().add(
              LoadTaskEvent(currentSessionState.currentTask.id),
            );
          }
        });
      }
      return;
    }

    if (taskState is TaskAnswerIncorrectState) {
      if (sessionState.isLastTask && !_isCompletingLastTask) {
        setState(() {
          _isCompletingLastTask = true;
        });
      }

      context.read<LessonTaskSessionBloc>().add(
        CompleteCurrentTaskEvent(
          isCorrect: false,
          xpEarned: taskState.result.xpEarned,
        ),
      );
    }
  }

  void _loadInitialSessionTask(
    BuildContext context,
    LessonTaskSessionState sessionState,
  ) {
    if (sessionState is! SessionActiveState) {
      return;
    }

    final taskBloc = context.read<TaskBloc>();
    if (taskBloc.state is TaskInitialState) {
      taskBloc.add(LoadTaskEvent(sessionState.currentTask.id));
    }
  }

  String _resolveSessionErrorMessage(
    SessionErrorState state,
    AppLocalizations s,
    BuildContext context,
  ) {
    final failure = state.failure;
    if (failure != null) {
      if (failure.message.isNotEmpty) {
        return failure.message;
      }
      return failure.code.localizedMessage(context);
    }

    switch (state.type) {
      case LessonTaskSessionErrorType.noTasks:
        return s.taskSessionNoTasks;
      case LessonTaskSessionErrorType.generic:
        return s.taskError;
    }
  }

  String _resolveAppBarTitle(
    LessonTaskSessionState state,
    AppLocalizations s,
    BuildContext context,
  ) {
    final lessonTitle = _lessonTitle;
    if (lessonTitle != null && lessonTitle.isNotEmpty) {
      return lessonTitle;
    }

    if (state is SessionActiveState) {
      return _getTaskTypeTitle(state.currentTask, context);
    }

    if (state is SessionErrorState) {
      return s.taskError;
    }

    return s.taskSessionLoading;
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

  Future<void> _handlePopAttempt(BuildContext context) async {
    final shouldExit = await showTaskSessionExitConfirmationDialog(context);
    if (shouldExit && mounted && context.mounted) {
      _exitSession(context);
    }
  }

  void _handleSessionStateChange(
    BuildContext context,
    LessonTaskSessionState sessionState,
  ) {
    _loadInitialSessionTask(context, sessionState);

    if (sessionState is SessionCompletedState && !_isSessionSummaryDialogOpen) {
      _isSessionSummaryDialogOpen = true;
      showTaskSessionSummaryDialog(
        context: context,
        sessionState: sessionState,
        sessionBloc: context.read<LessonTaskSessionBloc>(),
        onFinish: () => _finishSession(context),
      ).whenComplete(() {
        if (mounted) {
          _isSessionSummaryDialogOpen = false;
        }
      });
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
          ),
        ),
        BlocProvider(
          create: (context) => GetIt.I<TaskHintCubit>(param1: userProfile.id),
        ),
      ],
      child: BlocConsumer<LessonTaskSessionBloc, LessonTaskSessionState>(
        listener: _handleSessionStateChange,
        builder: (context, sessionState) {
          if (sessionState is SessionLoadingState) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                titleSpacing: 16,
                title: Text(
                  _resolveAppBarTitle(sessionState, s, context),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
            final errorMessage = _resolveSessionErrorMessage(
              sessionState,
              s,
              context,
            );

            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                titleSpacing: 16,
                title: Text(
                  _resolveAppBarTitle(sessionState, s, context),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
                    await _handlePopAttempt(context);
                  }
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      _resolveAppBarTitle(sessionState, s, context),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    centerTitle: false,
                    titleSpacing: 16,
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _handlePopAttempt(context),
                    ),
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: LabeledStepProgressBar(
                          completedCount: sessionState.completedTasksCount,
                          totalSteps: sessionState.tasks.length,
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<TaskBloc, TaskState>(
                          builder: (context, taskState) {
                            if (taskState is TaskInitialState ||
                                taskState is TaskLoadingState) {
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
                                        taskState.failure.code.localizedMessage(
                                          context,
                                        ),
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
                              if (_isCompletingLastTask) {
                                return const SizedBox.shrink();
                              }

                              return TaskFeedbackCorrectWidget(
                                task: taskState.task,
                                result: taskState.result,
                              );
                            }

                            if (taskState is TaskAnswerIncorrectState) {
                              if (_isCompletingLastTask) {
                                return const SizedBox.shrink();
                              }

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
}
