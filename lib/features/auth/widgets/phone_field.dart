import 'package:flutter/material.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.hintText,
    required this.controller,
    this.errorText,
  });

  final TextEditingController controller;
  final String hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: controller,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          errorText: errorText,
          errorMaxLines: 3,
        ),
      ),
    );
  }
}
