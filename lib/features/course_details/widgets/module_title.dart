import 'package:flutter/material.dart';

class ModuleTitle extends StatelessWidget {
  final String text;

  const ModuleTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
