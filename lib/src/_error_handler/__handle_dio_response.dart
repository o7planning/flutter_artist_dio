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
    ApiError apiError = apiResult.toApiError()!;
    info?._setError(apiError);
  } else {
    info?._setResponseSuccessInfo(
      dioRequestID: restRequestId,
      responseData: response.data,
      responseStatusCode: response.statusCode,
      responseStatusMessage: response.statusMessage,
    );
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
  WrapApiResult? rawResult = WrapApiResult.fromDynamicData(response.data);
  if (rawResult == null) {
    return ApiResult.data(null);
  }
  ApiError? apiError = rawResult.toApiError();
  if (apiError != null) {
    return ApiResult<D>.error(
      statusCode: apiError.statusCode,
      apiErrorType: apiError.apiErrorType,
      errorMessage: apiError.errorMessage,
      errorDetails: apiError.errorDetails,
      originText: null,
      errorData: apiError.errorData,
    );
  }
  Map<String, dynamic>? data = rawResult.data;
  if (data == null) {
    return ApiResult<D>.data(null);
  }
  return ApiResult.fromMap<D>(
    map: data,
    dataConverter: converter,
    statusCode: response.statusCode,
  );
}
