import 'dart:async';

import 'package:codium/core/exceptions/exceptions.dart';

class RetryLogic {
  static Future<T> retry<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    bool Function(Exception)? shouldRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      attempt++;
      try {
        return await operation();
      } catch (e) {
        if (attempt >= maxAttempts) {
          rethrow;
        }

        if (e is Exception) {
          if (shouldRetry != null && !shouldRetry(e)) {
            rethrow;
          }
        }

        await Future.delayed(delay);
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).round(),
        );
      }
    }
  }

  static Future<T> retryWithExponentialBackoff<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    Duration maxDelay = const Duration(seconds: 30),
  }) async {
    return retry<T>(
      operation: operation,
      maxAttempts: maxAttempts,
      initialDelay: initialDelay,
      backoffMultiplier: 2,
      shouldRetry: (exception) => true,
    );
  }

  static bool shouldRetryException(Exception exception) {
    if (exception is RateLimitError) {
      return false;
    }

    if (exception is NetworkError) {
      return exception.canRetry;
    }

    if (exception is DatabaseError) {
      return exception.canRetry;
    }

    if (exception is AppError) {
      return exception.canRetry;
    }

    return false;
  }
}
