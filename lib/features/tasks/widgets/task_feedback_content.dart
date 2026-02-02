import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/domain/models/task/task_result_model.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

Widget buildTaskFeedbackContent({
  required BuildContext context,
  required TaskResultModel result,
  required bool isCorrect,
  required Animation<double> scaleAnimation,
  required Animation<double> fadeAnimation,
  required VoidCallback? onRetry,
  String? fallbackExplanation,
}) {
  final s = S.of(context);
  final theme = Theme.of(context);
  final explanation =
      result.explanation ?? (!isCorrect ? fallbackExplanation : null);

  return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScaleTransition(
          scale: scaleAnimation,
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            borderRadius: BorderRadius.circular(16),
            borderColor:
                (isCorrect
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error)
                    .withValues(alpha: 0.35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  size: 48,
                  color: isCorrect
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
                const SizedBox(height: 12),
                if (isCorrect)
                  Text(
                    s.taskCorrectFeedback,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  Column(
                    children: [
                      Text(
                        s.taskIncorrectTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.taskIncorrectSubtitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        if (isCorrect && result.xpEarned > 0) ...[
          const SizedBox(height: 24),
          FadeTransition(
            opacity: fadeAnimation,
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(12),
              borderColor: theme.colorScheme.primary.withValues(alpha: 0.25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stars, color: theme.colorScheme.primary, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    s.taskXpEarned(result.xpEarned),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (!isCorrect && result.correctAnswer != null) ...[
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(12),
            borderColor: theme.colorScheme.outline.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.taskCorrectAnswer,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(result.correctAnswer!, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
        if (explanation != null) ...[
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(12),
            borderColor: theme.colorScheme.outline.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.tertiary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.taskExplanation,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(explanation, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
        if (!isCorrect && onRetry != null) ...[
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              s.taskRetry,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
