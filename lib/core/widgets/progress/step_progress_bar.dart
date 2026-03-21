import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.totalSteps,
    this.activeIndex,
    this.completedCount,
    this.height = 4,
    this.gap = 6,
    this.activeColor,
    this.inactiveColor,
  });

  final int totalSteps;
  final int? activeIndex;
  final int? completedCount;
  final double height;
  final double gap;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    if (totalSteps <= 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final resolvedActive = activeColor ?? theme.colorScheme.primary;
    final resolvedInactive =
        inactiveColor ?? theme.colorScheme.primary.withValues(alpha: 0.2);

    return Row(
      children: List.generate(
        totalSteps,
        (index) {
          final isActive = completedCount != null
              ? index < completedCount!
              : index == (activeIndex ?? 0);

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == totalSteps - 1 ? 0 : gap,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: height,
                decoration: BoxDecoration(
                  color: isActive ? resolvedActive : resolvedInactive,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
