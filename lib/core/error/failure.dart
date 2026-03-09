import 'package:codium/core/error/app_error_code.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:equatable/equatable.dart';

class AppFailure extends Equatable {
  final AppErrorCode code;
  final String message;
  final bool canRetry;

  const AppFailure({
    required this.code,
    required this.message,
    this.canRetry = false,
  });

  const AppFailure.parsing({String? message})
    : code = AppErrorCode.apiGeneral,
      message = message ?? 'Failed to parse response',
      canRetry = false;

  factory AppFailure.fromError(AppError error) {
    return AppFailure(
      code: error.code,
      message: error.message ?? 'Unknown error occurred',
      canRetry: error.canRetry,
    );
  }

  factory AppFailure.fromException(Object error) {
    if (error is AppError) {
      return AppFailure.fromError(error);
    }

    final message = switch (error) {
      StateError(:final message) => message,
      ArgumentError(:final message) => message?.toString() ?? error.toString(),
      Error() => error.toString(),
      Exception() => error.toString(),
      _ => error.toString(),
    };

    return AppFailure(
      code: AppErrorCode.unknown,
      message: message.isEmpty ? 'Unknown error occurred' : message,
      canRetry: false,
    );
  }

  factory AppFailure.fromDioException(dynamic dioException) {
    final error = dioException.error;
    if (error is AppError) {
      return AppFailure.fromError(error);
    }
    return AppFailure(
      code: AppErrorCode.unknown,
      message: error?.toString() ?? 'Unknown error occurred',
      canRetry: false,
    );
  }

  @override
  List<Object?> get props => [code, message, canRetry];

  @override
  bool get stringify => true;
}
