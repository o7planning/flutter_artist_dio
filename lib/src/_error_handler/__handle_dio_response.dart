part of '../../flutter_artist_dio.dart';

ApiResult<D> _handleDioResponse<D>({
  required ResponseDataMode responseDataMode,
  required Response response,
  required Converter? converter,
  required int restRequestId,
  bool showDebug = false,
}) {
  RequestLogInfo? info = restLogger.getRequestLogInfo(restRequestId);
  //
  info?._setResponseInfo(
    dioRequestID: restRequestId,
    responseData: response.data,
    responseStatusCode: response.statusCode,
    responseStatusMessage: response.statusMessage,
  );
  //
  ApiResult<D> apiResult;
  if (responseDataMode == ResponseDataMode.wrappedData) {
    apiResult = __handleResponseAsWrappedData(
      response: response,
      converter: converter,
      restRequestId: restRequestId,
      showDebug: showDebug,
    );
  }
  // ResponseDataMode.realData:
  else {
    apiResult = __handleResponseAsDirectData<D>(
      response: response,
      converter: converter,
      restRequestId: restRequestId,
      showDebug: showDebug,
    );
  }
  //
  if (apiResult.isError()) {
    info?._setError(apiResult.apiError!);
  }
  return apiResult;
}

ApiResult<D> __handleResponseAsDirectData<D>({
  required Response response,
  required Converter? converter,
  required int restRequestId,
  bool showDebug = false,
}) {
  ApiResult<D> apiResult = ApiResult.fromDynamicData<D>(
    statusCode: response.statusCode,
    statusMessage: response.statusMessage,
    data: response.data,
    dataConverter: converter,
  );
  return apiResult;
}

// *****************************************************************************
// *****
// *****************************************************************************

ApiResult<D> __handleResponseAsWrappedData<D>({
  required Response response,
  required Converter? converter,
  required int restRequestId,
  bool showDebug = false,
}) {
  WrapApiResult? rawResult = WrapApiResult.fromDynamicData(
    statusCode: response.statusCode,
    statusMessage: response.statusMessage,
    data: response.data,
  );
  if (rawResult == null) {
    return ApiResult<D>.data(
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      data: null,
    );
  }
  ApiError? apiError = rawResult.apiError;
  if (apiError != null) {
    return ApiResult<D>.apiError(apiError);
  }
  Map<String, dynamic>? data = rawResult.data;
  if (data == null) {
    return ApiResult<D>.data(
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      data: null,
    );
  }
  return ApiResult.fromMap<D>(
    statusCode: response.statusCode,
    statusMessage: response.statusMessage,
    map: data,
    dataConverter: converter,
  );
}
