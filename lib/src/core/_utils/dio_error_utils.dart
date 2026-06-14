import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

/// A specialized conversion transformer utility engineered to sanitize and map
/// third-party [DioExceptionType] failures straight into ecosystem-pure network error profiles.
class DioErrorUtils {
  /// Translates concrete low-level [DioExceptionType] connection states
  /// into a structured ecosystem-compliant [ApiErrorType] token definition value.
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

  static ApiError parseErrorResponse({
    required Response<dynamic> errorResponse,
    required ApiErrorType apiErrorType,
    required ErrorInfoExtractor errorInfoExtractor,
  }) {
    final dynamic responseErrorData = errorResponse.data;
    if (responseErrorData == null) {
      return ApiError(
        statusCode: errorResponse.statusCode,
        statusMessage: errorResponse.statusMessage,
        errorType: apiErrorType,
        originErrorText: null,
        errorMessage: errorResponse.statusMessage ?? "Unknown Error",
        errorDetails: null,
      );
    }
    if (responseErrorData is String) {
      var jsonObj;
      try {
        jsonObj = jsonDecode(responseErrorData);
      } catch (e) {
        return ApiError(
          statusCode: errorResponse.statusCode,
          statusMessage: errorResponse.statusMessage,
          errorType: apiErrorType,
          originErrorText: responseErrorData,
          errorMessage: responseErrorData,
          errorDetails: null,
        );
      }
      if (jsonObj == null) {
        return ApiError(
          statusCode: errorResponse.statusCode,
          statusMessage: errorResponse.statusMessage,
          errorType: apiErrorType,
          originErrorText: responseErrorData,
          errorMessage: responseErrorData,
          errorDetails: null,
        );
      } else if (jsonObj is Map<String, dynamic>) {
        String? errorMessage =
            errorInfoExtractor.extractErrorMessage(errorJson: jsonObj);
        List<String>? errorDetails =
            errorInfoExtractor.extractErrorDetails(errorJson: jsonObj);
        //
        return ApiError(
          statusCode: errorResponse.statusCode,
          statusMessage: errorResponse.statusMessage,
          errorType: apiErrorType,
          errorMessage:
              errorMessage ?? errorResponse.statusMessage ?? "Unknown Error",
          errorDetails: errorDetails,
        );
      } else if (jsonObj is List) {
        return ApiError(
          statusCode: errorResponse.statusCode,
          statusMessage: errorResponse.statusMessage,
          errorType: apiErrorType,
          originErrorText: responseErrorData,
          errorMessage:
              errorResponse.statusMessage ?? "Unknown Error Message (Array)",
          errorDetails: null,
        );
      } else {
        return ApiError(
          statusCode: errorResponse.statusCode,
          statusMessage: errorResponse.statusMessage,
          errorType: apiErrorType,
          originErrorText: responseErrorData,
          errorMessage: errorResponse.statusMessage ?? "Unknown Error Message",
          errorDetails: null,
        );
      }
    } else if (responseErrorData is Map<String, dynamic>) {
      String? errorMessage =
          errorInfoExtractor.extractErrorMessage(errorJson: responseErrorData);
      List<String>? errorDetails =
          errorInfoExtractor.extractErrorDetails(errorJson: responseErrorData);
      //
      return ApiError(
        errorType: apiErrorType,
        statusCode: errorResponse.statusCode,
        statusMessage: errorResponse.statusMessage,
        errorMessage:
            errorMessage ?? errorResponse.statusMessage ?? "Unknown Error.",
        errorDetails: errorDetails,
      );
    } else {
      return ApiError(
        statusCode: errorResponse.statusCode,
        statusMessage: errorResponse.statusMessage,
        errorType: apiErrorType,
        originErrorText: responseErrorData,
        errorMessage: errorResponse.statusMessage ?? "Unknown Error Message",
        errorDetails: null,
      );
    }
  }
}
