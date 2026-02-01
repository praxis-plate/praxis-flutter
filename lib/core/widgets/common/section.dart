import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  const Section({required this.title, required this.widget, super.key});

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        widget,
        const SizedBox(height: 8),
      ],
    );
  }
}
