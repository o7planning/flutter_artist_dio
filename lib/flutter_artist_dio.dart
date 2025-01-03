import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_artist_rest_core/flutter_artist_rest_core.dart';

part '_interceptor/app_dio_interceptor.dart';
part '_model/request_log_info.dart';
part '_rest/__base.dart';
part '_rest/__handle_dio_exception.dart';
part '_rest/__handle_dio_response.dart';
part '_rest/__handle_exception.dart';
part '_rest/_delete.dart';
part '_rest/_get.dart';
part '_rest/_post.dart';
part '_rest/_put.dart';
part 'logger/rest_logger.dart';

// -----------------------------------------------------------------------------
//
//
//
// -----------------------------------------------------------------------------

class FlutterArtistDio {
  final String _appBaseURL;
  final String? Function()? _getCurrentToken;
  late final Dio dio;

  FlutterArtistDio({
    required String appBaseURL,
    required String? Function()? getCurrentToken,
    required void Function(Map<String, dynamic> headers, String accessToken)?
        addAuthorizationToHeaders,
  })  : _appBaseURL = appBaseURL,
        _getCurrentToken = getCurrentToken {
    dio = Dio(
      BaseOptions(
        baseUrl: appBaseURL,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      AppDioInterceptor(
        appBaseURL: appBaseURL,
        getCurrentUserToken: getCurrentToken,
        addAuthorizationToHeaders: addAuthorizationToHeaders,
      ),
    );
  }

  String get appBaseURL {
    return _appBaseURL;
  }

  String? getCurrentUserToken() {
    return _getCurrentToken!();
  }

  Future<ApiResult<D>> restGet<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    int restRequestId = 0;
    try {
      headers ??= {};
      restRequestId = _addRequestIdToHeaders(headers: headers);
      //
      if (token != null) {
        headers["Authorization"] = token;
      }
      Options options = Options(
        headers: headers,
        contentType: 'application/json',
        followRedirects: false,
        validateStatus: (status) => true,
      );
      //
      final response = await dio.get(
        path,
        options: options,
        queryParameters: queryParameters,
      );

      return _handleDioResponse<D>(
        responseDataMode: responseDataMode,
        response: response,
        converter: converter,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } on DioException catch (e, stackTrace) {
      return _handleDioException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } catch (e, stackTrace) {
      return _handleException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    }
  }

  Future<ApiResult<D>> restPost<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    int restRequestId = 0;
    try {
      headers ??= {};
      restRequestId = _addRequestIdToHeaders(headers: headers);
      //
      final response = await dio.post(
        path,
        options: Options(headers: headers),
        queryParameters: queryParameters,
        data: data,
      );
      //
      return _handleDioResponse<D>(
        responseDataMode: responseDataMode,
        response: response,
        converter: converter,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } on DioException catch (e, stackTrace) {
      return _handleDioException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } catch (e, stackTrace) {
      return _handleException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    }
  }

  Future<ApiResult<D>> restPut<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    int restRequestId = 0;
    try {
      headers ??= {};
      restRequestId = _addRequestIdToHeaders(headers: headers);
      //
      final response = await dio.put(
        path,
        options: Options(
          headers: headers,
          receiveTimeout: const Duration(seconds: 10),
        ),
        queryParameters: queryParameters,
        data: data,
      );
      //
      return _handleDioResponse<D>(
        responseDataMode: responseDataMode,
        response: response,
        converter: converter,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } on DioException catch (e, stackTrace) {
      return _handleDioException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } catch (e, stackTrace) {
      return _handleException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    }
  }

  Future<ApiResult<D>> restDelete<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    int restRequestId = 0;
    try {
      headers ??= {};
      restRequestId = _addRequestIdToHeaders(headers: headers);
      //
      final response = await dio.delete(
        path,
        options: Options(headers: headers),
        queryParameters: queryParameters,
        data: data,
      );
      //
      return _handleDioResponse<D>(
        responseDataMode: responseDataMode,
        response: response,
        converter: converter,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } on DioException catch (e, stackTrace) {
      return _handleDioException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } catch (e, stackTrace) {
      return _handleException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    }
  }

  Future<ApiResult<D>> getDownload<D>(
    String path, {
    required ResponseDataMode responseDataMode,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    int restRequestId = 0;
    try {
      headers ??= {};
      restRequestId = _addRequestIdToHeaders(headers: headers);
      //
      if (token != null) {
        headers["Authorization"] = token;
      }
      // Content-Type: application/octet-stream
      // Content-Disposition: attachment; filename="picture.png"
      Options options = Options(
        headers: headers,
        contentType: 'application/octet-stream',
        followRedirects: false,
        validateStatus: (status) => true,
      );
      //
      final response = await dio.get(
        path,
        options: options,
        queryParameters: queryParameters,
      );

      return _handleDioResponse<D>(
        responseDataMode: responseDataMode,
        response: response,
        converter: converter,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } on DioException catch (e, stackTrace) {
      return _handleDioException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    } catch (e, stackTrace) {
      return _handleException(
        e,
        stackTrace: stackTrace,
        restRequestId: restRequestId,
        showDebug: showDebug,
      );
    }
  }
}
