part of '../../../flutter_artist_dio.dart';

ApiResult<D> _handleDioResponse<D>({
  required ResponseDataMode responseDataMode,
  required Response response,
  required Converter? converter,
  required int restRequestId,
  bool showDebug = false,
}) {
  RequestLogInfo? info = restLogger.getRequestLogInfo(restRequestId);
  //
  info?._setResponseSuccessInfo(
    dioRequestID: restRequestId,
    responseData: response.data,
    responseStatusCode: response.statusCode,
    responseStatusMessage: response.statusMessage,
  );
  //
  if (responseDataMode == ResponseDataMode.wrappedData) {
    return __handleResponseAsWrappedData(
      info: info,
      response: response,
      converter: converter,
      restRequestId: restRequestId,
      showDebug: showDebug,
    );
  }
  // ResponseDataMode.realData:
  else {
    return __handleResponseAsDirectData<D>(
      info: info,
      response: response,
      converter: converter,
      restRequestId: restRequestId,
      showDebug: showDebug,
    );
  }
}

ApiResult<D> __handleResponseAsDirectData<D>({
  required RequestLogInfo? info,
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
  if (apiResult.isError()) {
    info?._setResponseErrorMessage(
      errorType: ErrorType.apiError,
      responseErrorMessage: apiResult.errorMessage,
      responseErrorDetails: apiResult.errorDetails,
    );
  }
  return apiResult;
}

// *****************************************************************************
// *****
// *****************************************************************************

ApiResult<D> __handleResponseAsWrappedData<D>({
  required RequestLogInfo? info,
  required Response response,
  required Converter? converter,
  required int restRequestId,
  bool showDebug = false,
}) {
  WrapApiResult? rawResult = WrapApiResult.fromDynamicData(response.data);
  if (rawResult == null) {
    return ApiResult.data(null);
  }
  if (rawResult.errorMessage != null && rawResult.errorMessage!.isNotEmpty) {
    info?._setResponseErrorMessage(
      errorType: ErrorType.apiError,
      responseErrorMessage: rawResult.errorMessage,
      responseErrorDetails: rawResult.errorDetails,
    );
    return ApiResult(
      status: rawResult.status,
      errorMessage: rawResult.errorMessage,
      errorDetails: rawResult.errorDetails,
    );
  } else {
    dynamic baseResultData = rawResult.data;
    //
    ApiResult<D> apiResult = ApiResult.fromDynamicData<D>(
      statusCode: response.statusCode,
      data: baseResultData,
      dataConverter: converter,
    );
    if (apiResult.isError()) {
      info?._setResponseErrorMessage(
        errorType: ErrorType.apiError,
        responseErrorMessage: apiResult.errorMessage,
        responseErrorDetails: apiResult.errorDetails,
      );
    }
    return apiResult;
  }
}
