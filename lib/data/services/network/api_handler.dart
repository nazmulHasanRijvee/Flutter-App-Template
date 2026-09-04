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
    } on DioException catch (err, stackTrace) {
      // 1. DioException occured and Backend returned a JSON map with 'message'
      final request = err.requestOptions;
      final response = err.response;
      final data = response?.data;

      AppLogger.error(
          'DioException [${err.type}] ${request.method} ${request.uri}\n'
          'Status Code: ${response?.statusCode}\n'
          'Headers: ${request.headers}\n'
          'Request Body: ${request.data}\n'
          'Response Body: ${response?.data}',
          error: err,
          stackTrace: stackTrace
      );

      // Check if the backend returned a JSON map with a 'message' field
      if(data != null && data is Map<String, dynamic>) {
        final message = data['message'];

        // if "message" is not null, call onError with the message and stop further processing
        if (message != null) {
            await onError(message.toString());
            return;
        }
      }

      // If the backend did not return a 'message', use the DioException's message or a generic error message
      final errorMsg = err.message ?? err.toString();
      await onError(errorMsg);
      return;

    } catch (err, stackTrace) {
      // Generic fallback for unexpected errors like fromJson failures, TypeErors,
      // Anything Dio didn't wrap
      AppLogger.error('Unexpected Exception', error: err, stackTrace: stackTrace);
      await onError(err.toString());
      return;
    }

    // Business logic runs outside try-catch
    await onSuccess(result.data);
  }
}
