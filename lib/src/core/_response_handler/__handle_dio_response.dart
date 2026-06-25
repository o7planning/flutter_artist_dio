part of '../../../flutter_artist_dio.dart';

ApiResult<D> _handleDioResponse<D>({
  required ResponseDataMode responseDataMode,
  required Response response,
  required FaJsonConverter<D>? converter,
}) {
  final ApiLogData? apiLogData =
      _ApiLogHelper.getApiLogData(response.requestOptions);
  //
  switch (responseDataMode) {
    case ResponseDataMode.wrappedData:
      ApiResult<D> apiResult = __handleResponseAsWrappedData<D>(
        response: response,
        converter: converter,
      );
      //
      if (apiResult.isError()) {
        apiLogData?._setConversationError(apiResult.error);
      }
      return apiResult;
    case ResponseDataMode.realData:
      ApiResult<D> apiResult = __handleResponseAsDirectData<D>(
        response: response,
        converter: converter,
      );
      //
      if (apiResult.isError()) {
        apiLogData?._setConversationError(apiResult.error);
      }
      return apiResult;
  }
}

// *****************************************************************************

ApiResult<D> __handleResponseAsDirectData<D>({
  required Response response,
  required FaJsonConverter<D>? converter,
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
    return ApiResult<D>.fromJson(
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      map: data,
      jsonConverter: converter,
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
          return ApiResult<D>.fromJson(
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            map: decoded,
            jsonConverter: converter,
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

ApiResult<D> __handleResponseAsWrappedData<D>({
  required Response response,
  required FaJsonConverter<D>? converter,
}) {
  WrapApiResult? rawResult = WrapApiResult.fromDynamicData(
    statusCode: response.statusCode,
    statusMessage: response.statusMessage,
    data: response.data,
  );
  if (rawResult == null) {
    return ApiResult<D>.success(
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      data: null,
    );
  }
  ApiError? apiError = rawResult.error;
  if (apiError != null) {
    return ApiResult<D>.fromError(apiError);
  }
  Map<String, dynamic>? data = rawResult.data;
  if (data == null) {
    return ApiResult<D>.success(
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      data: null,
    );
  }
  return ApiResult.fromJson(
    statusCode: response.statusCode,
    statusMessage: response.statusMessage,
    map: data,
    jsonConverter: converter,
    printOriginDioStackTrace: FlutterArtistDio.printOriginDioStackTrace,
  );
}

// *****************************************************************************
