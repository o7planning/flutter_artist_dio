part of '../../../flutter_artist_dio.dart';

ApiResult<D> _handleDioResponse<D>({
  required Response response,
  required FaJsonConverter<D>? jsonConverter,
}) {
  final ApiLogData? apiLogData =
      _ApiLogHelper.getApiLogData(response.requestOptions);
  //
  ApiResult<D> apiResult = __handleResponseAsDirectData<D>(
    response: response,
    jsonConverter: jsonConverter,
  );
  //
  if (apiResult.isError()) {
    apiLogData?._setConversationError(apiResult.error);
  }
  return apiResult;
}

// *****************************************************************************

ApiResult<D> __handleResponseAsDirectData<D>({
  required Response response,
  required FaJsonConverter<D>? jsonConverter,
}) {
  final dynamic data = response.data;

  // Case 1: Void or empty resource response interpretation
  if (data == null) {
    return ApiResult<D>.success(
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      data: null,
    );
  }

  // Case 2: Standard structured JSON Map parsed automatically by Dio
  if (data is Map<String, dynamic>) {
    return _fromJson<D>(
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      map: data,
      jsonConverter: jsonConverter,
      printOriginDioStackTrace: FlutterArtistDio.printOriginDioStackTrace,
    );
  }

  // Case 3: Raw unparsed String boundary (Could be raw JSON, raw Text, or HTML)
  if (data is String) {
    final String standardized = data.trim();
    if (standardized.isEmpty) {
      return ApiResult<D>.success(
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        data: null,
      );
    }

    // Strict validation requirement: A valid root JSON Object must start with '{' and end with '}'
    if (standardized.startsWith('{') && standardized.endsWith('}')) {
      try {
        final dynamic decoded = jsonDecode(standardized);
        if (decoded is Map<String, dynamic>) {
          return _fromJson<D>(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            map: decoded,
            jsonConverter: jsonConverter,
            printOriginDioStackTrace: FlutterArtistDio.printOriginDioStackTrace,
          );
        }
      } catch (e) {
        return ApiResult<D>.fromError(
          ApiError(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            errorType: ApiErrorType.notJson,
            errorMessage:
                "Ecosystem Deserialization Failure: Failed to decode structured JSON string. Details: $e",
            originErrorText: standardized,
          ),
        );
      }
    }

    // Handle malformed payload states (e.g., HTML strings like <html>...</html> or plain text)
    final String truncatedText = standardized.length > 200
        ? "${standardized.substring(0, 200)}..."
        : standardized;

    return ApiResult<D>.fromError(
      ApiError(
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        errorType: ApiErrorType.notJson,
        errorMessage:
            "Ecosystem Contract Violation: Expected a structured JSON Map object payload, "
            "but encountered an un-parsable plain text or HTML response stream.",
        originErrorText: truncatedText,
      ),
    );
  }

  // Case 4: Totally unsupported runtime data types (e.g., raw List array at root)
  return ApiResult<D>.fromError(
    ApiError(
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      errorType: ApiErrorType.notJson,
      errorMessage:
          "Ecosystem Contract Violation: Unsupported data payload type context: ${data.runtimeType}",
      originErrorText: data.toString(),
    ),
  );
}

// *****************************************************************************

ApiResult<D> _fromJson<D>({
  required int? statusCode,
  required String? statusMessage,
  required Map<String, dynamic> map,
  required FaJsonConverter<D>? jsonConverter,
  bool printOriginDioStackTrace = true,
}) {
  D? retData;
  try {
    retData = jsonConverter?.call(map);
  } catch (e, stackTrace) {
    if (printOriginDioStackTrace) {
      print(stackTrace);
    }
    return ApiResult<D>.fromError(
      ApiError(
        statusCode: statusCode,
        statusMessage: statusMessage,
        errorType: ApiErrorType.conversion,
        errorMessage: "Data Convert error: $e",
        originErrorText: FaJsonUtils.jsonEncodeMap(map: map),
        usedConverter: jsonConverter,
      ),
    );
  }
//
  return ApiResult<D>.success(
    statusCode: statusCode,
    statusMessage: statusMessage,
    data: retData,
  );
}
