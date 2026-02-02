import 'package:flutter/material.dart';

class SubmitTaskButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SubmitTaskButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: theme.colorScheme.primary,
        disabledBackgroundColor: theme.colorScheme.primary.withValues(
          alpha: 0.3,
        ),
        disabledForegroundColor: theme.colorScheme.onSurface.withValues(
          alpha: 0.6,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 0),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
