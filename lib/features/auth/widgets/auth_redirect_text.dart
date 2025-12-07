import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthRedirectText extends StatelessWidget {
  final String questionText;
  final String actionText;
  final String route;

  const AuthRedirectText({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.go(route),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall,
          text: questionText,
          children: [
            TextSpan(
              text: ' $actionText',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
