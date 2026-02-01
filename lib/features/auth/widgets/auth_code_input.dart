import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class AuthCodeInput extends StatelessWidget {
  final String? errorText;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const AuthCodeInput({
    super.key,
    this.errorText,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassTextField(
          enabled: enabled,
          child: TextFormField(
            enabled: enabled,
            keyboardType: TextInputType.text,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(labelText: s.taskEnterCode),
            onChanged: onChanged,
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
