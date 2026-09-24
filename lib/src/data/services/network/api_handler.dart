import 'dart:async';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/logger/app_logger.dart';

class Api {
  static Future<void> call<T>({
    required Future<HttpResponse<T>> action,
    required FutureOr<void> Function(T response) onSuccess,
    required FutureOr<void> Function(String error) onError,
  }) async {
    try {
      final result = await action;
      await onSuccess(result.data);
    } on DioException catch (err, stackTrace) {
      final response = err.response;
      final data = response?.data;

      AppLogger.error(
        'DioException [${err.type}] ${err.requestOptions.method} '
        '${err.requestOptions.uri} (status: ${response?.statusCode})',
        error: err.error,
        stackTrace: stackTrace,
      );

      // Check if the backend returned a JSON map with a 'message' field
      if (data != null && data is Map<String, dynamic>) {
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
      AppLogger.error(
        'Unexpected Exception',
        error: err,
        stackTrace: stackTrace,
      );
      await onError(err.toString());
      return;
    }
  }
}
