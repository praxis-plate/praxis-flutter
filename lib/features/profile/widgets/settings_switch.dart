import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
    required this.value,
    required this.onChanged,
  });

  final VoidCallback? onTap;
  final String title;
  final Icon? icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      child: Row(
        children: [
          if (icon != null) icon!,
          if (icon != null) const SizedBox(width: 8),
          Text(title, style: theme.textTheme.bodyMedium),
          const Expanded(child: SizedBox()),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
