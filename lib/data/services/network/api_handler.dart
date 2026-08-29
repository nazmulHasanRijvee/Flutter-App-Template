import 'dart:async';
import 'package:dio/dio.dart';
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
    } catch (e) {
      // 1. Backend returned a JSON map with 'message'
      if (e is DioException && e.response?.data != null) {
        final data = e.response!.data;

        if (data is Map<String, dynamic> && data['message'] != null) {
          await onError(data['message'].toString());
          return;
        }
      }

      // Provide a more generic fallback or exactly as thrown
      await onError(e.toString());
      return;
    }

    // Business logic runs outside try-catch
    await onSuccess(result.data);
  }
}
