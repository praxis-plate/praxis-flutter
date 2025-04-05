import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
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
              labelText,
              style: theme.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            keyboardType: textInputType,
            controller: controller,
            style: theme.textTheme.bodyMedium,
            obscureText: isObscure,
            obscuringCharacter: '•',
            decoration: InputDecoration(
              hintText: hintText,
              errorText: errorText,
              errorMaxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
