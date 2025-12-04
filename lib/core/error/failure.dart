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

  factory AppFailure.fromError(AppError error) {
    return AppFailure(
      code: error.code,
      message: error.message ?? 'Unknown error occurred',
      canRetry: error.canRetry,
    );
  }

  factory AppFailure.fromException(Exception exception) {
    if (exception is AppError) {
      return AppFailure.fromError(exception);
    }
    return AppFailure(
      code: AppErrorCode.unknown,
      message: exception.toString(),
      canRetry: false,
    );
  }

  @override
  List<Object?> get props => [code, message, canRetry];

  @override
  bool get stringify => true;
}
