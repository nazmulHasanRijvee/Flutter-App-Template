import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_app_template/core/logger/app_logger.dart';
import 'package:retrofit/retrofit.dart';

class Api {
  static Future<void> call<T>({
    required Future<HttpResponse<T>> action,
    required FutureOr<void> Function(T response) onSuccess,
    required FutureOr<void> Function(String error) onError,
  }) async {
    final HttpResponse<T> result;

    try {
      result = await action;
    } catch (err, stackTrace) {
      // 1. DioExceptioin occured and Backend returned a JSON map with 'message'
      if (err is DioException && err.response?.data != null) {
        final request = err.requestOptions;
        final response = err.response;
        final data = request.data;

        AppLogger.error(
          'DioException [${err.type}] ${request.method} ${request.uri}\n'
          'Status Code: ${response?.statusCode}\n'
          'Headers: ${request.headers}\n'
          'Request Body: ${request.data}\n'
          'Response Body: ${response?.data}',
          error: err,
          stackTrace: stackTrace
        );

        if (data is Map<String, dynamic> && data['message'] != null) {
          await onError(data['message'].toString());
          return;
        }
      }

      // Provide a more generic fallback or exactly as thrown
       AppLogger.error('Unexpected Exception', error: err, stackTrace: stackTrace);
      await onError(err.toString());
      return;
    }

    // Business logic runs outside try-catch
    await onSuccess(result.data);
  }
}
