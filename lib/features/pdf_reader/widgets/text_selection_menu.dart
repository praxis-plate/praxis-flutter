import 'package:flutter/material.dart';

class TextSelectionMenu extends StatelessWidget {
  final String selectedText;
  final VoidCallback onExplain;
  final VoidCallback onDismiss;

  const TextSelectionMenu({
    super.key,
    required this.selectedText,
    required this.onExplain,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              tooltip: 'Explain',
              onPressed: onExplain,
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
