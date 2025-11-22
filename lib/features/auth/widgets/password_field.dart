import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.textInputType,
    this.errorText,
  });

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool isObscure;
  final TextInputType? textInputType;
  final String? errorText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.labelText,
              style: theme.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            keyboardType: widget.textInputType,
            controller: widget.controller,
            style: theme.textTheme.bodyMedium,
            obscureText: isObscure,
            obscuringCharacter: '•',
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: widget.errorText,
              errorMaxLines: 3,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
