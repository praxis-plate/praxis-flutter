import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class AuthPasswordInput extends StatelessWidget {
  final String? errorText;
  final bool enabled;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleVisibility;

  const AuthPasswordInput({
    super.key,
    this.errorText,
    required this.enabled,
    required this.obscureText,
    required this.onChanged,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return TextFormField(
      enabled: enabled,
      obscureText: obscureText,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: s.labelPassword,
        hintText: s.displayPasswordHint,
        errorText: errorText,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          splashRadius: 20,
          padding: const EdgeInsets.only(right: 16),
          onPressed: enabled ? onToggleVisibility : null,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
