part of '../../../flutter_artist_dio.dart';

ApiResult<D> _handleDioResponse<D>({
  required ResponseDataMode responseDataMode,
  required Response response,
  required Converter? converter,
}) {
  final ApiLogData? apiLogData =
      ApiLogUtils.getApiLogData(response.requestOptions);
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
  required Converter? converter,
}) {
  ApiResult<D> apiResult = ApiResult.fromDynamicData(
    statusCode: response.statusCode,
    statusMessage: response.statusMessage,
    data: response.data,
    dataConverter: converter,
  );
  return apiResult;
}

// *****************************************************************************

ApiResult<D> __handleResponseAsWrappedData<D>({
  required Response response,
  required Converter? converter,
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
  return ApiResult.fromMap(
    statusCode: response.statusCode,
    statusMessage: response.statusMessage,
    map: data,
    dataConverter: converter,
  );
}

// *****************************************************************************
