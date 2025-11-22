import 'package:flutter/material.dart';

class TextSelectionMenu extends StatelessWidget {
  final String selectedText;
  final VoidCallback onExplain;
  final VoidCallback onDismiss;
  final bool isOffline;

  const TextSelectionMenu({
    super.key,
    required this.selectedText,
    required this.onExplain,
    required this.onDismiss,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.lightbulb_outline,
                color: isOffline ? theme.disabledColor : null,
              ),
              tooltip: isOffline ? 'Offline - AI features disabled' : 'Explain',
              onPressed: isOffline ? null : onExplain,
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close',
              onPressed: onDismiss,
            ),
          ],
        ),
      ),
    );
  }
}
