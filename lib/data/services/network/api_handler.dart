import 'dart:async';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class Api {
  static Future<void> call<T>({
    required Future<HttpResponse<T>> action,
    required FutureOr<void> Function(T response) onSuccess,
    required FutureOr<void> Function(String error) onError,
  }) async {
    try {
      final result = await action;
      if (result.response.statusCode == 200 ||
          result.response.statusCode == 201) {
        await onSuccess(result.data);
      } else {
        await onError(result.response.statusMessage ?? 'Unknown error');
      }
    } catch (e) {
      if (e is DioException && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          await onError(data['message'].toString());
          return;
        }
      }
      // Provide a more generic fallback or exactly as thrown
      await onError(e.toString());
    }
  }
}
