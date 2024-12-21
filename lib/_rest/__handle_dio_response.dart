part of '../flutter_artist_dio.dart';

ApiResult<D> _handleDioResponse<D>({
  required ResponseDataMode responseDataMode,
  required Response response,
  required Converter? converter,
  required int restRequestId,
  bool showDebug = false,
}) {
  RequestLogInfo? info = restLogger.getRequestLogInfo(restRequestId);
  //
  info?.setResponseSuccessInfo(
    dioRequestID: restRequestId,
    responseData: response.data,
    responseStatusCode: response.statusCode,
    responseStatusMessage: response.statusMessage,
  );

  //
  dynamic baseResultData;
  if (responseDataMode == ResponseDataMode.wrappedData) {
    WrapApiResult? rawResult = WrapApiResult.fromDynamicData(response.data);
    if (rawResult == null) {
      return ApiResult.data(null);
    } else {
      info?.setErrorParsingJson(
        errorParsingJson: false,
        errorParsingJsonMessage: "Response JSON is valid!",
      );
    }
    if (rawResult.errorMessage != null && rawResult.errorMessage!.isNotEmpty) {
      info?.setResponseErrorMessage(
        responseErrorMessage: rawResult.errorMessage,
        responseErrorDetails: rawResult.errorDetails,
      );
      return ApiResult(
        status: rawResult.status,
        errorMessage: rawResult.errorMessage,
        errorDetails: rawResult.errorDetails,
      );
    } else {
      baseResultData = rawResult.data;
    }
  }
  //
  else {
    baseResultData = response.data;
  }

  try {
    bool isEmpty = false;
    if (baseResultData != null) {
      if (baseResultData is Map && baseResultData.isEmpty) {
        baseResultData = null;
        isEmpty = true;
      }
    }
    D? data = baseResultData == null
        ? null
        : converter == null
            ? null
            : converter(baseResultData);
    if (data == null) {
      if (isEmpty || converter == null) {
        return ApiResult(data: null);
      } else {
        info?.setErrorConvertingJson(
          mainData: baseResultData,
          errorConvertingJson: true,
          errorConvertingJsonMessage: "Converter method return null",
        );
        return ApiResult(errorMessage: "Converter method return null");
      }
    } else {
      info?.setErrorConvertingJson(
        mainData: baseResultData,
        errorConvertingJson: false,
        errorConvertingJsonMessage: "Convert Successful",
      );
    }
    return ApiResult(data: data);
  } catch (e, stackTrace) {
    print("Convert Error: $e");
    print(stackTrace);
    info?.setErrorConvertingJson(
      mainData: baseResultData,
      errorConvertingJson: true,
      errorConvertingJsonMessage: "Convert Error: $e",
    );
    return ApiResult(errorMessage: "Convert Error: $e");
  }
}
