import 'package:codium/s.dart';
import 'package:flutter/material.dart';

import 'step_progress_bar.dart';

class LabeledStepProgressBar extends StatelessWidget {
  final int completedCount;
  final int totalSteps;

  const LabeledStepProgressBar({
    super.key,
    required this.completedCount,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    if (totalSteps <= 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.taskProgressLabel(completedCount, totalSteps),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 6),
        StepProgressBar(
          totalSteps: totalSteps,
          completedCount: completedCount,
        ),
      ],
    );
  }
}
