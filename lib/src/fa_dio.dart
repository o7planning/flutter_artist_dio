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

  /// Creates a centralized [FlutterArtistDio] networking client instance.
  ///
  /// * [dio] The active configurations base object with target interceptors.
  /// * [pageMapping] Custom strategy definitions for envelope list and page extraction.
  /// * [errorInfoExtractor] Custom failure parser layout (details and examples are fully documented inside [FlexibleErrorInfoExtractor]).
  ///
  /// ### Example 1: Standard Default Initialization
  /// *Uses default page key structures (`items`, `pagination`, `currentPage`, etc.)*
  /// ```dart
  /// final artistDio = FlutterArtistDio(
  ///   dio: Dio(BaseOptions(baseUrl: 'https://api.leantek.com')),
  ///   pageMapping: const PageMapping(), // Uses standard out-of-the-box key configurations
  /// );
  /// ```
  ///
  /// ### Example 2: Highly Customized Enterprise Layout Specifications
  /// *Overriding infrastructure keys to match customized legacy remote server payload rules.*
  /// ```dart
  /// final customArtistDio = FlutterArtistDio(
  ///   dio: Dio(BaseOptions(baseUrl: 'https://api.legacy-system.com')),
  ///   pageMapping: const PageMapping(
  ///     itemsKey: 'records',                // Custom matching node: "records" instead of "items"
  ///     paginationKey: 'meta',              // Custom matching node: "meta" instead of "pagination"
  ///     paginationDetailKeys: PaginationDetailKeys(
  ///       currentPage: 'pageIndex',         // Custom sub-key conversion binding
  ///       pageSize: 'limitCount',           // Custom sub-key conversion binding
  ///       totalItems: 'totalRecords',       // Custom sub-key conversion binding
  ///       totalPages: 'totalPageCount',     // Custom sub-key conversion binding
  ///     ),
  ///   ),
  /// );
  /// ```
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
  /// * [jsonConverter] Strongly-typed root model mapper ([FaJsonConverter]).
  /// * [showDebug] Toggles verbose engineering logs across consoles.
  ///
  /// ### Expected Root JSON Payload Layout:
  /// ```json
  /// {
  ///   "id": "USD",
  ///   "symbol": "$",
  ///   "name": "US Dollar"
  /// }
  /// ```
  ///
  /// ### Example:
  /// ```dart
  /// ApiResult<CurrencyInfo?> result = await artistDio.jsonGet(
  ///   '/api/v1/currencies/USD',
  ///   jsonConverter: CurrencyInfo.fromJson,
  /// );
  /// ```
  Future<ApiResult<D>> jsonGet<D>(
    String path, {
    required FaJsonConverter<D>? jsonConverter,
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
      jsonConverter: jsonConverter,
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

  /// Public API to fetch managed pagination data segments wrapped inside a [PageData] envelope.
  ///
  /// Parameters:
  /// * [path] The paginated resource search URL endpoint location.
  /// * [itemConverter] Strict non-nullable element processor applied sequentially on the inner array.
  ///
  /// ### Expected Envelope JSON Payload Layout (Based on default [PageMapping]):
  /// ```json
  /// {
  ///   "pagination": {
  ///     "currentPage": 1,
  ///     "pageSize": 10,
  ///     "totalItems": 45,
  ///     "totalPages": 5
  ///   },
  ///   "items": [
  ///     { "id": "USD", "symbol": "$", "name": "US Dollar" },
  ///     { "id": "EUR", "symbol": "€", "name": "Euro" }
  ///   ]
  /// }
  /// ```
  ///
  /// ### Example:
  /// ```dart
  /// ApiResult<PageData<CurrencyInfo>> result = await artistDio.jsonGetPage(
  ///   '/api/v1/currencies/search',
  ///   itemConverter: FaItemConverters.fromJsonConverter(CurrencyInfo.fromJson),
  /// );
  /// ```
  Future<ApiResult<PageData<ITEM>>> jsonGetPage<ITEM>(
    String path, {
    required FaItemConverter<ITEM> itemConverter,
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
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      jsonConverter: (dynamic data) {
        return _convertToPageData<ITEM>(
          pageMapping: pageMapping,
          itemConverter: itemConverter,
          data: data,
        );
      },
    );
  }

  /// Public API to fetch flat array collections securely wrapped into a unified [ListData].
  ///
  /// Parameters:
  /// * [path] The specific collection resource endpoint location.
  /// * [itemConverter] Strict non-nullable element processor applied sequentially on the inner array.
  ///
  /// ### Expected Envelope JSON Payload Layout (Based on default [PageMapping]):
  /// ```json
  /// {
  ///   "items": [
  ///     { "id": "USD", "symbol": "$", "name": "US Dollar" },
  ///     { "id": "EUR", "symbol": "€", "name": "Euro" }
  ///   ]
  /// }
  /// ```
  ///
  /// ### Example:
  /// ```dart
  /// ApiResult<ListData<CurrencyInfo>> result = await artistDio.jsonGetList(
  ///   '/api/v1/currencies/active-list',
  ///   itemConverter: FaItemConverters.fromJsonConverter(CurrencyInfo.fromJson),
  /// );
  /// ```
  Future<ApiResult<ListData<ITEM>>> jsonGetList<ITEM>(
    String path, {
    required FaItemConverter<ITEM> itemConverter,
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
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      jsonConverter: (dynamic data) {
        return _convertToListData<ITEM>(
          pageMapping: pageMapping,
          itemConverter: itemConverter,
          data: data,
        );
      },
    );
  }

  /// Executes an asynchronous JSON `POST` request payload mutation pipeline targeting a single root entity.
  ///
  /// Parameters:
  /// * [path] The targeted modification resource URL endpoint location.
  /// * [jsonConverter] Strongly-typed root model mapper ([FaJsonConverter]).
  ///
  /// ### Expected Input/Output JSON Payload Layout:
  /// ```json
  /// {
  ///   "id": "JPY",
  ///   "symbol": "¥",
  ///   "name": "Japanese Yen"
  /// }
  /// ```
  ///
  /// ### Example:
  /// ```dart
  /// final payload = { "id": "JPY", "symbol": "¥", "name": "Japanese Yen" };
  ///
  /// ApiResult<CurrencyInfo?> result = await artistDio.jsonPost(
  ///   '/api/v1/currencies/create',
  ///   data: payload,
  ///   jsonConverter: CurrencyInfo.fromJson,
  /// );
  /// ```
  Future<ApiResult<D>> jsonPost<D>(
    String path, {
    required FaJsonConverter<D>? jsonConverter,
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
      jsonConverter: jsonConverter,
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
  ///
  /// Parameters:
  /// * [path] The target query resource URL endpoint location.
  /// * [itemConverter] Strict non-nullable element processor applied sequentially on the inner array.
  ///
  /// ### Example:
  /// ```dart
  /// final searchFilter = { "searchKeyword": "dollar" };
  ///
  /// ApiResult<PageData<CurrencyInfo>> result = await artistDio.jsonPostPage(
  ///   '/api/v1/currencies/search-complex',
  ///   data: searchFilter,
  ///   itemConverter: FaItemConverters.fromJsonConverter(CurrencyInfo.fromJson),
  /// );
  /// ```
  Future<ApiResult<PageData<ITEM>>> jsonPostPage<ITEM>(
    String path, {
    required FaItemConverter<ITEM> itemConverter,
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
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      jsonConverter: (dynamic data) {
        return _convertToPageData<ITEM>(
          pageMapping: pageMapping,
          itemConverter: itemConverter,
          data: data,
        );
      },
    );
  }

  /// Public API to execute a secure JSON `POST` mutation request returning flat list data.
  ///
  /// Parameters:
  /// * [path] The target resource URL endpoint location.
  /// * [itemConverter] Strict non-nullable element processor applied sequentially on the inner array.
  Future<ApiResult<ListData<ITEM>>> jsonPostList<ITEM>(
    String path, {
    required FaItemConverter<ITEM> itemConverter,
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
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      jsonConverter: (dynamic data) {
        return _convertToListData<ITEM>(
          pageMapping: pageMapping,
          itemConverter: itemConverter,
          data: data,
        );
      },
    );
  }

  /// Public API to execute a secure JSON `POST` request designed specifically
  /// to fetch a flat dataset without pagination constraints (e.g., querying by IDs).
  ///
  /// This bridges the semantic gap when a query requires a large body payload
  /// (such as a massive array of target IDs) that would otherwise overflow standard HTTP GET URL limits.
  ///
  /// Parameters:
  /// * [path] The specific collection resource endpoint location.
  /// * [itemConverter] Strict non-nullable element processor applied sequentially on the inner array.
  ///
  /// ### Expected Envelope JSON Payload Layout:
  /// ```json
  /// {
  ///   "items": [
  ///     { "id": 1, "code": "A1", "name": "Favorite English Songs" },
  ///     { "id": 2, "code": "A2", "name": "Uncategorized" }
  ///   ]
  /// }
  /// ```
  ///
  /// ### Example:
  /// ```dart
  /// final payload = {
  ///   "ids": [1, 2, 3, 4, 5]
  /// };
  ///
  /// ApiResult<ListData<AlbumInfo>> result = await artistDio.jsonPostFetchList(
  ///   '/rest/list/album-info/fetch-by-ids',
  ///   data: payload,
  ///   itemConverter: FaItemConverters.fromJsonConverter(AlbumInfo.fromJson),
  /// );
  /// ```
  Future<ApiResult<ListData<ITEM>>> jsonPostFetchList<ITEM>(
    String path, {
    required FaItemConverter<ITEM> itemConverter,
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
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      jsonConverter: (dynamic data) {
        return _convertToListData<ITEM>(
          pageMapping: pageMapping,
          itemConverter: itemConverter,
          data: data,
        );
      },
    );
  }

  /// Public API to execute a secure JSON `POST` request designed specifically
  /// to fetch managed pagination data segments using a heavy body payload filter structure.
  ///
  /// Parameters:
  /// * [path] The paginated resource search URL endpoint location.
  /// * [itemConverter] Strict non-nullable element processor applied sequentially on the inner array.
  ///
  /// ### Expected Envelope JSON Payload Layout:
  /// ```json
  /// {
  ///   "pagination": {
  ///     "currentPage": 1,
  ///     "pageSize": 20,
  ///     "totalItems": 2,
  ///     "totalPages": 1
  ///   },
  ///   "items": [
  ///     { "id": 1, "code": "A1", "name": "Favorite English Songs" },
  ///     { "id": 2, "code": "A2", "name": "Uncategorized" }
  ///   ]
  /// }
  /// ```
  ///
  /// ### Example:
  /// ```dart
  /// final heavyCriteria = {
  ///   "targetDepartmentIds": [1, 5, 9, 12, 45],
  ///   "exclusionFlags": ["archived", "temporary"]
  /// };
  ///
  /// ApiResult<PageData<EmployeeInfo>> result = await artistDio.jsonPostFetchPage(
  ///   '/rest/page/employee-info/fetch-by-complex-criteria',
  ///   data: heavyCriteria,
  ///   itemConverter: FaItemConverters.fromJsonConverter(EmployeeInfo.fromJson),
  /// );
  /// ```
  Future<ApiResult<PageData<ITEM>>> jsonPostFetchPage<ITEM>(
    String path, {
    required FaItemConverter<ITEM> itemConverter,
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
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      jsonConverter: (dynamic data) {
        return _convertToPageData<ITEM>(
          pageMapping: pageMapping,
          itemConverter: itemConverter,
          data: data,
        );
      },
    );
  }

  /// Executes a secure asynchronous JSON `PUT` state replacement network request targeting a single root entity.
  ///
  /// Parameters:
  /// * [path] The targeted resource URL endpoint location.
  /// * [jsonConverter] Strongly-typed root model mapper ([FaJsonConverter]).
  ///
  /// ### Example:
  /// ```dart
  /// final updatePayload = { "name": "US Dollar Updated Version" };
  ///
  /// ApiResult<CurrencyInfo?> result = await artistDio.jsonPut(
  ///   '/api/v1/currencies/USD',
  ///   data: updatePayload,
  ///   jsonConverter: CurrencyInfo.fromJson,
  /// );
  /// ```
  Future<ApiResult<D>> jsonPut<D>(
    String path, {
    required FaJsonConverter<D> jsonConverter,
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
      jsonConverter: jsonConverter,
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

  /// Public API to execute a JSON `PUT` mutation returning structured pagination data wrappers.
  Future<ApiResult<PageData<ITEM>>> jsonPutPage<ITEM>(
    String path, {
    required FaItemConverter<ITEM> itemConverter,
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
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      jsonConverter: (dynamic data) {
        return _convertToPageData<ITEM>(
          pageMapping: pageMapping,
          itemConverter: itemConverter,
          data: data,
        );
      },
    );
  }

  /// Public API to execute a JSON `PUT` mutation returning flat list data containers.
  Future<ApiResult<ListData<ITEM>>> jsonPutList<ITEM>(
    String path, {
    required FaItemConverter<ITEM> itemConverter,
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
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      jsonConverter: (dynamic data) {
        return _convertToListData<ITEM>(
          pageMapping: pageMapping,
          itemConverter: itemConverter,
          data: data,
        );
      },
    );
  }

  /// Executes a secure asynchronous JSON `DELETE` resource destruction request lifecycle.
  ///
  /// Parameters:
  /// * [path] Target identifier resource URL endpoint location.
  /// * [jsonConverter] Strongly-typed root model mapper ([FaJsonConverter]).
  ///
  /// ### Example:
  /// ```dart
  /// ApiResult<void> result = await artistDio.jsonDelete(
  ///   '/api/v1/currencies/USD',
  ///   jsonConverter: null, // Pass null if the endpoint returns an empty plain body context
  /// );
  /// ```
  Future<ApiResult<D>> jsonDelete<D>(
    String path, {
    required FaJsonConverter<D>? jsonConverter,
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
      jsonConverter: jsonConverter,
      errorInfoExtractor: errorInfoExtractor,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Executes an asynchronous stream request to download binary asset byte components.
  ///
  /// Extracts data arrays safely as a flat non-nullable index wrapper [List<int>?].
  ///
  /// Parameters:
  /// * [path] Raw asset network storage file URL location.
  /// * [showDebug] Prints telemetry download progression statistics.
  /// * [onReceiveProgress] Callback function tracking precise live transfer weights.
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
