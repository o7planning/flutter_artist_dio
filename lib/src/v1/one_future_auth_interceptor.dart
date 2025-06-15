import 'package:dio/dio.dart';
import 'package:flutter_artist_dio/src/v1/token_storage.dart';

import '../../fa_dio.dart';

// https://dev.to/7twilight/mastering-auth-in-flutter-with-dio-from-simple-access-tokens-to-a-refresh-flow-27cf
class OneFutureAuthInterceptor extends Interceptor {
  final Dio dio;

  // A class that reads/writes tokens
  final TokenStorage tokenStorage;
  final WriteTokenToHeaders writeTokenToHeaders;

  Future<String?>? _refreshTokenFuture;

  OneFutureAuthInterceptor({
    required this.dio,
    required this.tokenStorage,
    required this.writeTokenToHeaders,
  });

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await tokenStorage.readAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      // options.headers['Authorization'] = 'Bearer $accessToken';
      writeTokenToHeaders(headers: options.headers, accessToken: accessToken);
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_isUnauthorized(err) && _shouldRefresh(err.requestOptions)) {
      // Attempt refresh if not already happening
      _refreshTokenFuture ??= _refreshAccessToken();

      final newToken = await _refreshTokenFuture;
      if (newToken != null) {
        // Retry the original request
        final clonedRequest = _retryRequest(err.requestOptions, newToken);
        try {
          final response = await dio.fetch(clonedRequest);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(e as DioException);
        }
      }
      // If refresh fails, newToken == null => pass the 401 up
    }
    return handler.next(err);
  }

  bool _isUnauthorized(DioException err) {
    return err.response?.statusCode == 401;
  }

  bool _shouldRefresh(RequestOptions requestOptions) {
    // Avoid refreshing again if it's the refresh token call
    return !requestOptions.path.contains('/refresh');
  }

  RequestOptions _retryRequest(RequestOptions requestOptions, String newToken) {
    final newHeaders = Map<String, dynamic>.from(requestOptions.headers);
    newHeaders['Authorization'] = 'Bearer $newToken';
    return requestOptions.copyWith(headers: newHeaders);
  }

  Future<String?> _refreshAccessToken() async {
    try {
      // Call your /refresh endpoint
      // final response = await Dio().post('https://your.api/refresh', data: {...});
      // final newAccessToken = response.data['accessToken'];
      final newAccessToken = 'FAKE_NEW_TOKEN';

      await tokenStorage.saveAccessToken(newAccessToken);
      return newAccessToken;
    } catch (e) {
      // If fail, remove token or force user to re-log
      await tokenStorage.clearTokens();
      return null;
    } finally {
      // Allow future refresh attempts next time 401 is encountered
      _refreshTokenFuture = null;
    }
  }
}
