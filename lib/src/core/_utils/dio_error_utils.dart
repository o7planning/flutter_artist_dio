import 'package:dio/dio.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

class DioExceptionUtils {
  static ApiErrorType toApiErrorType(DioExceptionType dioExceptionType) {
    switch (dioExceptionType) {
      case DioExceptionType.connectionTimeout:
        return ApiErrorType.connectionTimeout;
      case DioExceptionType.sendTimeout:
        return ApiErrorType.sendTimeout;
      case DioExceptionType.receiveTimeout:
        return ApiErrorType.receiveTimeout;
      case DioExceptionType.badCertificate:
        return ApiErrorType.badCertificate;
      case DioExceptionType.badResponse:
        return ApiErrorType.badResponse;
      case DioExceptionType.cancel:
        return ApiErrorType.cancel;
      case DioExceptionType.connectionError:
        return ApiErrorType.connectionError;
      case DioExceptionType.unknown:
        return ApiErrorType.unknown;
    }
  }
}
