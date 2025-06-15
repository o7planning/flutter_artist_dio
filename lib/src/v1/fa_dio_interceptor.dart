part of 'fa_dio.dart';

class FaDioInterceptor extends Interceptor {
  final ReadTokenFromHeaders readTokenFromHeaders;

  FaDioInterceptor({
    required this.readTokenFromHeaders,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var dioRequestID = _getRequestIdFromHeaders(headers: options.headers!);

    String? token = readTokenFromHeaders(headers: options.headers);

    restLogger.createRequestLogInfo(
      dioRequestId: dioRequestID,
      baseUrl: options.baseUrl,
      requestPath: options.path,
      requestMethod: options.method,
      requestHeaders: options.headers,
      requestQueryParameters: options.queryParameters,
      formData: options.data,
      token: token,
    );
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Pass the error to the next interceptor in the chain.
    handler.next(err);
  }
}
