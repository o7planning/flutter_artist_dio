import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/src/v1/token_storage.dart';

import 'one_future_auth_interceptor.dart';

part '_error_handler/__handle_dio_exception.dart';
part '_error_handler/__handle_dio_response.dart';
part '_error_handler/__handle_exception.dart';
part '_model/request_log_info.dart';
part 'core/__base.dart';
part 'core/_read_token_from_headers.dart';
part 'core/_write_token_to_headers.dart';
part 'fa_dio_interceptor.dart';
//
part 'json/_json_delete.dart';
part 'json/_json_get.dart';
part 'json/_json_post.dart';
part 'json/_json_put.dart';
part 'logger/rest_logger.dart';

class FaDio {
  late final Dio _dio;

  Dio get dio => _dio;

  FaDio({
    BaseOptions? baseOptions,
    required TokenStorage tokenStorage,
    required WriteTokenToHeaders writeTokenToHeaders,
    required ReadTokenFromHeaders readTokenFromHeaders,
  }) {
    _dio = Dio(baseOptions);
    _dio.interceptors.add(
      OneFutureAuthInterceptor(
        dio: _dio,
        tokenStorage: tokenStorage,
        writeTokenToHeaders: writeTokenToHeaders,
      ),
    );
    _dio.interceptors.add(
      FaDioInterceptor(
        readTokenFromHeaders: readTokenFromHeaders,
      ),
    );
  }
}
