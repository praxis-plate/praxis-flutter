import 'package:praxis/core/exceptions/app_error.dart';
import 'package:praxis/core/exceptions/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    GetIt.I<Talker>().warning('DioException: ${err.message}');

    final appError = _mapDioExceptionToAppError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appError,
        type: err.type,
        response: err.response,
      ),
    );
  }

  AppError _mapDioExceptionToAppError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkError.timeout();
    }

    final statusCode = e.response?.statusCode;

    if (statusCode == null) {
      return const NetworkError.noConnection();
    }

    return switch (statusCode) {
      404 => const NetworkError.notFound(),
      429 => const NetworkError.tooManyRequests(),
      >= 500 => const NetworkError.serverError(),
      _ => NetworkError.general(
        message: 'Request failed with status $statusCode',
      ),
    };
  }
}
