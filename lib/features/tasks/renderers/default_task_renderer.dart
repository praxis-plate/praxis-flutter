import 'package:praxis/domain/models/task/task_models.dart';
import 'package:praxis/features/tasks/renderers/task_renderer.dart';
import 'package:praxis/features/tasks/tasks/tasks.dart';
import 'package:flutter/widgets.dart';
import 'package:praxis/s.dart';

class DefaultTaskRenderer implements TaskRenderer {
  const DefaultTaskRenderer();

  @override
  TaskScreenDescriptor describe(BuildContext context, TaskModel task) {
    final s = S.of(context);

    switch (task) {
      case MultipleChoiceTaskModel():
        return TaskScreenDescriptor(
          title: s.taskMultipleChoice,
          body: MultipleChoiceTask(task: task),
        );
      case CodeCompletionTaskModel():
        return TaskScreenDescriptor(
          title: s.taskCodeCompletion,
          body: CodeCompletionTask(task: task),
        );
      case MatchingTaskModel():
        return TaskScreenDescriptor(
          title: s.taskMatching,
          body: MatchingTask(task: task),
        );
      case TextInputTaskModel():
        return TaskScreenDescriptor(
          title: s.taskTextInput,
          body: TextInputTask(task: task),
        );
    }
  }
}
