import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class AuthPasswordInput extends StatefulWidget {
  final String? errorText;
  final bool isEnabled;
  final ValueChanged<String> onChanged;

  const AuthPasswordInput({
    super.key,
    this.errorText,
    required this.onChanged,
    required this.isEnabled,
  });

  @override
  State<AuthPasswordInput> createState() => _AuthPasswordInputState();
}

class _AuthPasswordInputState extends State<AuthPasswordInput> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: widget.isEnabled,
          obscureText: _isPasswordHidden,
          keyboardType: TextInputType.visiblePassword,
          enableSuggestions: false,
          autocorrect: false,
          textInputAction: TextInputAction.done,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          obscuringCharacter: '•',
          decoration: InputDecoration(
            labelText: s.labelPassword,
            hintText: s.displayPasswordHint,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(shape: const CircleBorder()),
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: widget.isEnabled
                      ? theme.colorScheme.onSurface
                      : theme.disabledColor,
                ),
                splashRadius: 20,
                onPressed: () {
                  _isPasswordHidden = !_isPasswordHidden;
                  setState(() {});
                },
              ),
            ),
          ),
          onChanged: widget.onChanged,
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
