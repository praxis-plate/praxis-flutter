import 'package:flutter/material.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/domain/models/task/task_result_model.dart';
import 'package:praxis/s.dart';

import 'task_feedback_hero.dart';

class TaskFeedbackContent extends StatelessWidget {
  const TaskFeedbackContent({
    super.key,
    required this.result,
    required this.isCorrect,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.onRetry,
    this.fallbackExplanation,
    this.shiftState,
  });

  final TaskResultModel result;
  final bool isCorrect;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final VoidCallback? onRetry;
  final String? fallbackExplanation;
  final ShiftState? shiftState;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final explanation =
        result.explanation ?? (!isCorrect ? fallbackExplanation : null);
    final positiveColor = theme.colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (shiftState != null)
            ScaleTransition(
              scale: scaleAnimation,
              child: TaskFeedbackHero(
                isCorrect: isCorrect,
                shiftState: shiftState!,
                label: isCorrect ? s.taskCorrectLabel : s.taskIncorrectLabel,
                title: isCorrect ? s.taskCorrectFeedback : s.taskIncorrectTitle,
                subtitle: isCorrect ? null : s.taskIncorrectSubtitle,
                xpEarned: result.xpEarned,
                accentColor: isCorrect
                    ? positiveColor
                    : theme.colorScheme.error,
                backgroundColor: Color.alphaBlend(
                  (isCorrect ? positiveColor : theme.colorScheme.error)
                      .withValues(alpha: isCorrect ? 0.1 : 0.08),
                  theme.colorScheme.surfaceContainerHighest,
                ),
                illustrationRotation: isCorrect ? -0.12 : 0.08,
                illustrationAlignment: isCorrect
                    ? Alignment.topRight
                    : Alignment.centerRight,
                badgeBackgroundColor: isCorrect
                    ? positiveColor.withValues(alpha: 0.12)
                    : theme.colorScheme.error.withValues(alpha: 0.12),
              ),
            )
          else
            ScaleTransition(
              scale: scaleAnimation,
              child: SurfaceCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                borderRadius: BorderRadius.circular(16),
                borderColor:
                    (isCorrect ? positiveColor : theme.colorScheme.error)
                        .withValues(alpha: 0.5),
                backgroundColor: isCorrect
                    ? Color.alphaBlend(
                        positiveColor.withValues(alpha: 0.08),
                        theme.colorScheme.surfaceContainerHighest,
                      )
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      size: 48,
                      color: isCorrect
                          ? positiveColor
                          : theme.colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    if (isCorrect)
                      Text(
                        s.taskCorrectFeedback,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: positiveColor,
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
          if (!isCorrect && result.correctAnswer != null) ...[
            const SizedBox(height: 24),
            SurfaceCard(
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
            const SizedBox(height: 16),
            SurfaceCard(
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
            const SizedBox(height: 16),
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
}
