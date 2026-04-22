import 'package:praxis/s.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? title;
  final String message;
  final bool canRetry;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    super.key,
    this.title,
    required this.message,
    this.canRetry = false,
    this.onRetry,
    this.onDismiss,
  });

  static Future<bool?> show({
    required BuildContext context,
    String? title,
    required String message,
    bool canRetry = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) =>
          ErrorDialog(title: title, message: message, canRetry: canRetry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Text(title ?? s.error),
        ],
      ),
      content: Text(message),
      actions: [
        if (canRetry)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onRetry?.call();
            },
            child: Text(s.retry),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onDismiss?.call();
          },
          child: Text(canRetry ? s.cancel : s.ok),
        ),
      ],
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  final bool canRetry;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const ErrorBanner({
    super.key,
    required this.message,
    this.canRetry = false,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
          if (canRetry)
            TextButton(
              onPressed: onRetry,
              child: Text(
                s.retry,
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onErrorContainer,
              ),
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}
