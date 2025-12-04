import 'package:codium/core/error/app_error_code.dart';
import 'package:equatable/equatable.dart';

abstract class AppError extends Equatable implements Exception {
  final AppErrorCode code;
  final String? message;
  final bool canRetry;

  const AppError({required this.code, this.message, this.canRetry = false});

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [code, message, canRetry];
}
