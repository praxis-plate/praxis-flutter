import 'package:flutter/material.dart';

class MetaItem extends StatelessWidget {
  const MetaItem({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: theme.textTheme.titleSmall),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}
