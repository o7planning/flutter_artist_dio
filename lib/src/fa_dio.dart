part of '../flutter_artist_dio.dart';

/// A production-grade HTTP networking client wrapper built on top of the [Dio] package.
///
/// [FlutterArtistDio] standardizes Rest API execution workflows, automatically intercepts
/// network exceptions, flattens fragmented server validation errors via an [ErrorInfoExtractor],
/// and exposes data payloads cleanly as strongly typed [ApiResult] instances.
class FlutterArtistDio {
  static bool printOriginDioStackTrace = true;

  /// The strategic pipeline component handling multi-format remote server error bisections.
  final ErrorInfoExtractor errorInfoExtractor;
  final PageMapping pageMapping;

  /// The underlying standard network engine executor.
  final Dio dio;

  /// Creates a centralized [FlutterArtistDio] networking client.
  ///
  /// * [dio] The active configurations base object with target interceptors.
  /// * [errorInfoExtractor] Custom failure parser layout (defaults to [FlexibleErrorInfoExtractor]).
  // docs: 14751.
  FlutterArtistDio({
    required this.dio,
    required this.pageMapping,
    this.errorInfoExtractor = const FlexibleErrorInfoExtractor(),
  });

  /// Executes a secure asynchronous JSON `GET` network payload transaction request.
  ///
  /// Automatically captures HTTP errors or timeout lifetimes, and formats server metrics into an [ApiResult].
  ///
  /// Parameters:
  /// * [path] The specific resource target URL endpoint location.
  /// * [responseDataMode] Legacy parsing strategy selector.
  /// * [converter] Strongly-typed model generator function (e.g., `User.fromJson`).
  /// * [showDebug] Toggles verbose engineering logs across consoles.
  ///
  /// Example:
  /// ```dart
  /// ApiResult<User> result = await artistDio.jsonGet('/profile', converter: User.fromJson);
  /// ```
  ///
  /// Origin DIO Function:
  ///
  /// ```dart
  /// Future<Response<T>> get<T>(
  ///     String path, {
  ///     Object? data,
  ///     Map<String, dynamic>? queryParameters,
  ///     Options? options,
  ///     CancelToken? cancelToken,
  ///     ProgressCallback? onReceiveProgress,
  /// });
  /// ```
  ///
  Future<ApiResult<D>> jsonGet<D>(
    String path, {
    @Deprecated('Legacy parameter. Will be removed soon.')
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    required Converter<D>? converter,
    bool showDebug = false,
    //
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _jsonGet<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      converter: converter,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Public API to fetch structured pagination data seamlessly without boilerplate wrappers.
  Future<ApiResult<PageData<ITEM>>> jsonGetPage<ITEM>(
    String path, {
    required Converter<ITEM> converter,
    bool showDebug = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _jsonGet<PageData<ITEM>>(
      dio,
      path,
      responseDataMode: ResponseDataMode.realData,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,

      // Injecting the dynamic manual parser inside the converter block
      converter: (Map<String, dynamic> rawJson) {
        return _convertToPageData<ITEM>(
          pageMapping: pageMapping,
          converter: converter,
          rawJson: rawJson,
        );
      },
    );
  }

  /// Public API to fetch structured pagination data seamlessly without boilerplate wrappers.
  Future<ApiResult<ListData<ITEM>>> jsonGetList<ITEM>(
    String path, {
    required Converter<ITEM> converter,
    bool showDebug = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _jsonGet<ListData<ITEM>>(
      dio,
      path,
      responseDataMode: ResponseDataMode.realData,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      // Injecting the dynamic manual parser inside the converter block
      converter: (Map<String, dynamic> rawJson) {
        return _convertToListData<ITEM>(
          pageMapping: pageMapping,
          converter: converter,
          rawJson: rawJson,
        );
      },
    );
  }

  /// Executes a secure asynchronous JSON `POST` request payload mutation pipeline.
  ///
  /// Submits state modification requests to remote endpoints, wrapping exceptions into a predictable [ApiResult].
  ///
  /// Parameters:
  /// * [path] The targeted modification resource URL endpoint location.
  /// * [responseDataMode] Legacy parsing strategy selector.
  /// * [converter] Model parser layer mapped directly to structural maps.
  /// * [showDebug] Toggles console terminal network activity prints.
  ///
  /// Origin DIO Function:
  ///
  /// ```dart
  /// Future<Response<T>> post<T>(
  ///     String path, {
  ///     Object? data,
  ///     Map<String, dynamic>? queryParameters,
  ///     Options? options,
  ///     CancelToken? cancelToken,
  ///     ProgressCallback? onSendProgress,
  ///     ProgressCallback? onReceiveProgress,
  /// });
  /// ```
  ///
  Future<ApiResult<D>> jsonPost<D>(
    String path, {
    @Deprecated('Legacy parameter. Will be removed soon.')
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    required Converter<D>? converter,
    bool showDebug = false,
    //
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _jsonPost<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      converter: converter,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Public API to execute a secure JSON `POST` mutation request returning structured pagination data.
  Future<ApiResult<PageData<ITEM>>> jsonPostPage<ITEM>(
    String path, {
    required Converter<ITEM> converter,
    bool showDebug = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _jsonPost<PageData<ITEM>>(
      dio,
      path,
      responseDataMode: ResponseDataMode.realData,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      // Injecting the dynamic manual parser inside the converter block
      converter: (Map<String, dynamic> rawJson) {
        return _convertToPageData<ITEM>(
          pageMapping: pageMapping,
          converter: converter,
          rawJson: rawJson,
        );
      },
    );
  }

  /// Public API to execute a secure JSON `POST` mutation request returning flat list data.
  Future<ApiResult<ListData<ITEM>>> jsonPostList<ITEM>(
    String path, {
    required Converter<ITEM> converter,
    bool showDebug = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _jsonPost<ListData<ITEM>>(
      dio,
      path,
      responseDataMode: ResponseDataMode.realData,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      // Injecting the dynamic manual parser inside the converter block
      converter: (Map<String, dynamic> rawJson) {
        return _convertToListData<ITEM>(
          pageMapping: pageMapping,
          converter: converter,
          rawJson: rawJson,
        );
      },
    );
  }

  /// Executes a secure asynchronous JSON `PUT` state replacement network request.
  ///
  /// Updates existing system resources securely with validation safeguards.
  ///
  /// Parameters:
  /// * [path] The targeted resource URL endpoint location.
  /// * [responseDataMode] Legacy parsing strategy selector.
  /// * [converter] Structural conversion parsing function factory.
  /// * [showDebug] Enforces runtime telemetry log presentation.
  ///
  /// Origin DIO Function:
  ///
  /// ```
  /// Future<Response<T>> put<T>(
  ///     String path, {
  ///     Object? data,
  ///     Map<String, dynamic>? queryParameters,
  ///     Options? options,
  ///     CancelToken? cancelToken,
  ///     ProgressCallback? onSendProgress,
  ///     ProgressCallback? onReceiveProgress,
  /// });
  /// ```
  ///
  Future<ApiResult<D>> jsonPut<D>(
    String path, {
    @Deprecated('Legacy parameter. Will be removed soon.')
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    required Converter<D>? converter,
    bool showDebug = false,
    //
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _jsonPut<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      converter: converter,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Public API to execute a secure JSON `PUT` state replacement network request returning structured pagination data.
  Future<ApiResult<PageData<ITEM>>> jsonPutPage<ITEM>(
    String path, {
    required Converter<ITEM> converter,
    bool showDebug = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _jsonPut<PageData<ITEM>>(
      dio,
      path,
      responseDataMode: ResponseDataMode.realData,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      // Injecting the dynamic manual parser inside the converter block
      converter: (Map<String, dynamic> rawJson) {
        return _convertToPageData<ITEM>(
          pageMapping: pageMapping,
          converter: converter,
          rawJson: rawJson,
        );
      },
    );
  }

  /// Public API to execute a secure JSON `PUT` state replacement network request returning flat list data.
  Future<ApiResult<ListData<ITEM>>> jsonPutList<ITEM>(
    String path, {
    required Converter<ITEM> converter,
    bool showDebug = false,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _jsonPut<ListData<ITEM>>(
      dio,
      path,
      responseDataMode: ResponseDataMode.realData,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      converter: (Map<String, dynamic> rawJson) {
        return _convertToListData<ITEM>(
          pageMapping: pageMapping,
          converter: converter,
          rawJson: rawJson,
        );
      },
    );
  }

  /// Executes a secure asynchronous JSON `DELETE` resource destruction request lifecycle.
  ///
  /// Ideal for sending data mutation commands intended for backend entity erasure.
  ///
  /// Parameters:
  /// * [path] Target identifier resource URL endpoint location.
  /// * [responseDataMode] Legacy parsing strategy selector.
  /// * [converter] Structural validation mapping handler.
  /// * [showDebug] Activates terminal runtime stream tracking.
  ///
  /// Origin DIO Function:
  ///
  /// ```dart
  /// Future<Response<T>> delete<T>(
  ///     String path, {
  ///     Object? data,
  ///     Map<String, dynamic>? queryParameters,
  ///     Options? options,
  ///     CancelToken? cancelToken,
  /// });
  /// ```
  ///
  Future<ApiResult<D>> jsonDelete<D>(
    String path, {
    @Deprecated('Legacy parameter. Will be removed soon.')
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    required Converter<D>? converter,
    bool showDebug = false,
    //
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _jsonDelete<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      converter: converter,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  ///
  /// Executes an asynchronous stream request to download binary byte components.
  ///
  /// Extracts data arrays safely as a flat [List<int>] index wrapper.
  ///
  /// Parameters:
  /// * [path] Raw asset storage URL target.
  /// * [showDebug] Prints telemetry download progression statistics.
  /// * [onReceiveProgress] Callback function tracking precise live transfer weights.
  ///
  Future<ApiResult<List<int>?>> binaryGet(
    String path, {
    bool showDebug = false,
    //
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Object? data,
    Options? options,
  }) async {
    return await _binaryGet(
      dio,
      path,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      //
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      data: data,
      options: options,
    );
  }
}
