import 'package:praxis/core/error/app_error_code_extension.dart';
import 'package:praxis/domain/models/task/task_models.dart';
import 'package:praxis/features/tasks/bloc/task/task_bloc.dart';
import 'package:praxis/features/tasks/renderers/task_renderer.dart';
import 'package:praxis/features/tasks/widgets/widgets.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskScreen extends StatefulWidget {
  final int taskId;

  const TaskScreen({super.key, required this.taskId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final taskRenderer = context.read<TaskRenderer>();

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskStateWithTask) {
              final task = (state as TaskStateWithTask).task;
              return Text(_getTaskTypeTitle(task, context));
            }
            return Text(s.taskMultipleChoice);
          },
        ),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(s.taskLoading, style: theme.textTheme.bodyLarge),
                ],
              ),
            );
          }

          if (state is TaskErrorState) {
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
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.failure.code.localizedMessage(context),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(
                        LoadTaskEvent(widget.taskId),
                      );
                    },
                    child: Text(s.retry),
                  ),
                ],
              ),
            );
          }

          if (state is TaskLoadedState) {
            final task = state.task;
            return taskRenderer.build(context, task);
          }

          if (state is TaskAnswerValidatingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(s.taskValidating, style: theme.textTheme.bodyLarge),
                ],
              ),
            );
          }

          if (state is TaskAnswerCorrectState) {
            return TaskFeedbackCorrectWidget(
              task: state.task,
              result: state.result,
            );
          }

          if (state is TaskAnswerIncorrectState) {
            return TaskFeedbackIncorrectWidget(
              task: state.task,
              result: state.result,
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
}
