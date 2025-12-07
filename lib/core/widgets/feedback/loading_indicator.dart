import 'package:codium/core/utils/duration.dart';
import 'package:codium/s.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Duration? estimatedTime;
  final bool showEstimatedTime;

  const LoadingIndicator({
    super.key,
    this.message,
    this.estimatedTime,
    this.showEstimatedTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (showEstimatedTime && estimatedTime != null) ...[
            const SizedBox(height: 8),
            Text(
              DurationFormatter.formatEstimated(estimatedTime!, s),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FullScreenLoadingIndicator extends StatelessWidget {
  final String? message;
  final Duration? estimatedTime;

  const FullScreenLoadingIndicator({
    super.key,
    this.message,
    this.estimatedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: LoadingIndicator(
        message: message,
        estimatedTime: estimatedTime,
        showEstimatedTime: true,
      ),
    );
  }
}
