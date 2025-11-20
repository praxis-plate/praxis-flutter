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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (showEstimatedTime && estimatedTime != null) ...[
            const SizedBox(height: 8),
            Text(
              'Estimated time: ${_formatDuration(estimatedTime!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} seconds';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    } else {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    }
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
