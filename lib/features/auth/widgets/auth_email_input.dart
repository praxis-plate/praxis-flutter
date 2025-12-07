import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class AuthEmailInput extends StatelessWidget {
  final String? errorText;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const AuthEmailInput({
    super.key,
    this.errorText,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return TextFormField(
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: s.labelEmail,
        hintText: s.displayEmailHint,
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }
}
