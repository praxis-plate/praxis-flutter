import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/s.dart';

class TaskSessionExitConfirmationDialog extends StatelessWidget {
  const TaskSessionExitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(s.taskSessionExitTitle),
      content: Text(s.taskSessionExitMessage),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(
            s.cancel,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
          child: Text(s.exit),
        ),
      ],
    );
  }
}
