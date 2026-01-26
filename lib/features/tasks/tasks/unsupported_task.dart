import 'package:codium/domain/models/task/task_model.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class UnsupportedTask extends StatelessWidget {
  final TaskModel task;

  const UnsupportedTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          s.taskUnsupportedType(task.taskType),
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
