import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praxis/s.dart';

Future<bool> showTaskSessionExitConfirmationDialog(BuildContext context) async {
  final s = S.of(context);
  final theme = Theme.of(context);

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(s.taskSessionExitTitle),
      content: Text(s.taskSessionExitMessage),
      actions: [
        TextButton(
          onPressed: () => dialogContext.pop(false),
          child: Text(
            s.cancel,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
        TextButton(
          onPressed: () => dialogContext.pop(true),
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
          child: Text(s.exit),
        ),
      ],
    ),
  );

  return result ?? false;
}
