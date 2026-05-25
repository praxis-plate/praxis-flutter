import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/tasks/bloc/bloc.dart';
import 'package:praxis/features/tasks/renderers/task_renderer.dart';
import 'package:praxis/features/tasks/widgets/task_feedback_correct_widget.dart';
import 'package:praxis/features/tasks/widgets/task_feedback_incorrect_widget.dart';
import 'package:praxis/s.dart';

class TaskSessionLoadingView extends StatelessWidget {
  const TaskSessionLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            S.of(context).taskSessionLoading,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class TaskSessionErrorView extends StatelessWidget {
  const TaskSessionErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class TaskSessionActiveBody extends StatelessWidget {
  const TaskSessionActiveBody({
    super.key,
    required this.sessionState,
    required this.taskRenderer,
  });

  final SessionActiveState sessionState;
  final TaskRenderer taskRenderer;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              return switch (taskState) {
                TaskInitialState() ||
                TaskLoadingState() => const TaskSessionLoadingView(),
                TaskErrorState(:final failure) => TaskSessionErrorView(
                  title: S.of(context).taskError,
                  message: failure.code.localizedMessage(context),
                  actionLabel: S.of(context).retry,
                  onAction: () {
                    context.read<TaskBloc>().add(
                      LoadTaskEvent(sessionState.currentTask.id),
                    );
                  },
                ),
                TaskLoadedState(:final task) =>
                  taskRenderer.describe(context, task).body,
                TaskAnswerValidatingState() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).taskValidating,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                TaskAnswerCorrectState(:final task, :final result) =>
                  TaskFeedbackCorrectWidget(task: task, result: result),
                TaskAnswerIncorrectState(:final task, :final result) =>
                  TaskFeedbackIncorrectWidget(task: task, result: result),
                _ => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ],
    );
  }
}
