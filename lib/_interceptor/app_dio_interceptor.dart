part of '../flutter_artist_dio.dart';

class AppDioInterceptor extends Interceptor {
  final String refreshTokenApiPath = "/refreshToken";
  final String appBaseURL;

  final String? Function()? getCurrentUserToken;
  final void Function(Map<String, dynamic> headers, String accessToken)?
      addAuthorizationToHeaders;

  AppDioInterceptor({
    required this.appBaseURL,
    required this.getCurrentUserToken,
    required this.addAuthorizationToHeaders,
  });

  // Internal Dio Object. Used in this class only.
  late Dio internalDio = Dio(BaseOptions(baseUrl: appBaseURL));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var dioRequestID = _getRequestIdFromHeaders(headers: options.headers!);

    String? token = getCurrentUserToken == null ? null : getCurrentUserToken!();
    //
    if (token != null && addAuthorizationToHeaders != null) {
      addAuthorizationToHeaders!(options.headers, token);
    }
    
    options.headers.addAll({"Content-Type": "application/json"});

    //
    // Get token from the storage
    //
    // if (token != null) {
    //   // WWW-Authenticate: <type> realm=<realm>
    //   // WWW-Authenticate: Basic realm="myRealm"
    //   options.headers.addAll({
    //     "Authorization": token,
    //   });
    // }
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
    // print(">>> AppDioInterceptor.onResponse(): $response");
    //
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // print(">>> AppDioInterceptor.onError(): ${err.response}");
    //
    // Check if the user is unauthorized.
    //
    if (err.response?.statusCode == 401111) {
      // Refresh the user's authentication token.
      await refreshToken();
      // Retry the request.
      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        // If the request fails again, pass the error to the next interceptor in the chain.
        handler.next(e);
      }
      // Return to prevent the next interceptor in the chain from being executed.
      return;
    }
    // Pass the error to the next interceptor in the chain.
    handler.next(err);
  }

  Future<void> refreshToken() async {
    print(">>> AppDioInterceptor.refreshToken()");
    var response = await internalDio.post(
      refreshTokenApiPath,
      options: Options(
        headers: {"Refresh-Token": "refresh-token"},
      ),
    );
    // on success response, deserialize the response
    if (response.statusCode == 200) {
      // LoginRequestResponse requestResponse =
      //    LoginRequestResponse.fromJson(response.data);
      // UPDATE the STORAGE with new access and refresh-tokens
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    print(">>> AppDioInterceptor._retry()");
    //
    String? token = getCurrentUserToken == null ? null : getCurrentUserToken!();
    //
    Map<String, dynamic> headers = requestOptions.headers;
    if (token != null) {
      headers.addAll({
        "Authorization": "Bearer $token",
      });
    }
    //
    // Create a new `RequestOptions` object with the same method,
    // path, data, and query parameters as the original request.
    //
    final options = Options(
      method: requestOptions.method,
      headers: headers,
    );

    // Retry the request with the new `RequestOptions` object.
    return internalDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
