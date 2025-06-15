import 'package:dio/dio.dart';
import 'package:flutter_artist_dio/src/v1/token_storage.dart';

import '../../flutter_artist_dio.dart';
import 'one_future_auth_interceptor.dart';

part 'core/__base.dart';
part 'core/_read_token_from_headers.dart';
part 'core/_write_token_to_headers.dart';
part 'fa_dio_interceptor.dart';

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
