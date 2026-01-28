import 'package:codium/domain/models/task/task_models.dart';
import 'package:codium/features/tasks/renderers/task_renderer.dart';
import 'package:codium/features/tasks/tasks/tasks.dart';
import 'package:flutter/widgets.dart';

class DefaultTaskRenderer implements TaskRenderer {
  const DefaultTaskRenderer();

  @override
  Widget build(BuildContext context, TaskModel task) {
    switch (task) {
      case MultipleChoiceTaskModel():
        return MultipleChoiceTask(task: task);
      case CodeCompletionTaskModel():
        return CodeCompletionTask(task: task);
      case MatchingTaskModel():
        return MatchingTask(task: task);
      case TextInputTaskModel():
        return TextInputTask(task: task);
    }
  }
}
