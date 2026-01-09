import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/tasks/bloc/task/task_bloc.dart';
import 'package:codium/features/tasks/bloc/task_hint/task_hint_cubit.dart';
import 'package:codium/features/tasks/widgets/widgets.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetIt.I<TaskBloc>(param1: 1)..add(LoadTaskEvent(widget.taskId)),
        ),
        BlocProvider(create: (context) => GetIt.I<TaskHintCubit>(param1: 1)),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoadedState ||
                  state is TaskAnswerValidatingState ||
                  state is TaskAnswerCorrectState ||
                  state is TaskAnswerIncorrectState) {
                final task = state is TaskLoadedState
                    ? state.task
                    : state is TaskAnswerValidatingState
                    ? state.task
                    : state is TaskAnswerCorrectState
                    ? state.task
                    : (state as TaskAnswerIncorrectState).task;

                return Text(_getTaskTypeTitle(task, context));
              }
              return Text(S.of(context).taskMultipleChoice);
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
                        state.message,
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
              return _buildTaskContent(context, task);
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
              return TaskFeedbackWidget(
                task: state.task,
                result: state.result,
                isCorrect: true,
              );
            }

            if (state is TaskAnswerIncorrectState) {
              return TaskFeedbackWidget(
                task: state.task,
                result: state.result,
                isCorrect: false,
              );
            }

            return const SizedBox.shrink();
          },
        ),
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
}
