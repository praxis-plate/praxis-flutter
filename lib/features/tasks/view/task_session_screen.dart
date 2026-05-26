import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/core/error/app_error_code_extension.dart';
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
  static const _autoAdvanceDelay = Duration(seconds: 2);
  Timer? _autoAdvanceTimer;
  bool _isCompletingLastTask = false;
  bool _isSessionSummaryDialogOpen = false;

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

  void _handleTaskCompletion(
    BuildContext context,
    TaskState taskState,
    SessionActiveState sessionState,
  ) {
    if (taskState is TaskAnswerCorrectState) {
      if (sessionState.isLastTask) {
        if (_isCompletingLastTask) {
          return;
        }

        setState(() {
          _isCompletingLastTask = true;
        });

        _scheduleSessionCompletion(context, taskState.result.xpEarned);
        return;
      }

      context.read<LessonTaskSessionBloc>().add(
        CompleteCurrentTaskEvent(
          isCorrect: true,
          xpEarned: taskState.result.xpEarned,
        ),
      );

      _scheduleAutoAdvance(context);
    }
  }

  void _scheduleAutoAdvance(BuildContext context) {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(_autoAdvanceDelay, () {
      if (!mounted) {
        return;
      }

      final currentSessionState = context.read<LessonTaskSessionBloc>().state;
      if (currentSessionState is SessionActiveState) {
        context.read<TaskBloc>().add(
          LoadTaskEvent(currentSessionState.currentTask.id),
        );
      }
    });
  }

  void _scheduleSessionCompletion(BuildContext context, int xpEarned) {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(_autoAdvanceDelay, () {
      if (!mounted) {
        return;
      }

      context.read<LessonTaskSessionBloc>().add(
        CompleteCurrentTaskEvent(isCorrect: true, xpEarned: xpEarned),
      );
    });
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
    TaskRenderer taskRenderer,
    BuildContext context,
  ) {
    final lessonTitle = switch (state) {
      SessionLoadingState(:final lessonTitle) => lessonTitle,
      SessionActiveState(:final lessonTitle) => lessonTitle,
      SessionCompletedState(:final lessonTitle) => lessonTitle,
      SessionErrorState(:final lessonTitle) => lessonTitle,
      _ => null,
    };
    if (lessonTitle != null && lessonTitle.isNotEmpty) {
      return lessonTitle;
    }

    if (state is SessionActiveState) {
      return taskRenderer.describe(context, state.currentTask).title;
    }

    if (state is SessionErrorState) {
      return s.taskError;
    }

    return s.taskSessionLoading;
  }

  Future<void> _handlePopAttempt(BuildContext context) async {
    final shouldExit =
        await showDialog<bool>(
          context: context,
          builder: (_) => const TaskSessionExitConfirmationDialog(),
        ) ??
        false;

    if (shouldExit && mounted && context.mounted) {
      _exitSession(context);
    }
  }

  void _handleSessionStateChange(
    BuildContext context,
    LessonTaskSessionState sessionState,
  ) {
    _loadInitialSessionTask(context, sessionState);

    if (sessionState is! SessionActiveState &&
        _isCompletingLastTask &&
        mounted) {
      setState(() {
        _isCompletingLastTask = false;
      });
    }

    if (sessionState is SessionCompletedState && !_isSessionSummaryDialogOpen) {
      _isSessionSummaryDialogOpen = true;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => TaskSessionSummaryDialog(
          sessionState: sessionState,
          sessionBloc: context.read<LessonTaskSessionBloc>(),
          onFinish: () => _finishSession(context),
        ),
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
    final taskRenderer = context.read<TaskRenderer>();

    return BlocConsumer<LessonTaskSessionBloc, LessonTaskSessionState>(
      listener: _handleSessionStateChange,
      builder: (context, sessionState) {
        if (sessionState is SessionLoadingState) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              titleSpacing: 16,
              title: Text(
                _resolveAppBarTitle(sessionState, s, taskRenderer, context),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: const TaskSessionLoadingView(),
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
                _resolveAppBarTitle(sessionState, s, taskRenderer, context),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: TaskSessionErrorView(
              title: s.taskError,
              message: errorMessage,
              actionLabel: s.goBack,
              onAction: () => _exitSession(context),
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
                    _resolveAppBarTitle(sessionState, s, taskRenderer, context),
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
                    Expanded(
                      child: TaskSessionActiveBody(
                        sessionState: sessionState,
                        taskRenderer: taskRenderer,
                        showCurrentTaskAsCompleted: _isCompletingLastTask,
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
    );
  }
}
