part of '../../flutter_artist_dio.dart';

class RequestLogInfo {
  int dioRequestID;
  String baseUrl;
  String requestPath;
  String requestMethod;
  String? token;
  late Map<String, dynamic> requestHeaders;
  late Map<String, dynamic> requestQueryParameters;
  late Map<String, dynamic> mapData;

  //
  int? responseStatusCode;
  String? responseStatusMessage;

  //
  bool __jsonDataReady = false;
  bool __hasNoResponseData = false;
  Object? __responseJsonObjOrArray;
  String? __responseText;
  dynamic responseData;

  ApiError? __apiError;

  ApiError? get apiError => __apiError;

  bool get isResponseError {
    if (responseStatusCode == null || responseStatusCode == 304) {
      return false;
    }
    if (responseStatusCode! >= 200 && responseStatusCode! < 300) {
      return false;
    }
    return true;
  }

  RequestLogInfo({
    required this.dioRequestID,
    required this.baseUrl,
    required this.requestPath,
    required this.requestMethod,
    required Map<String, dynamic> requestHeaders,
    required Map<String, dynamic> requestQueryParameters,
    required dynamic formData,
    required this.token,
  }) {
    this.requestHeaders = {};
    this.requestHeaders.addAll(requestHeaders);
    const authKey = 'Authorization';
    if (this.requestHeaders.containsKey(authKey)) {
      String value = this.requestHeaders[authKey];
      this.requestHeaders[authKey] =
          value.length > 20 ? "${value.substring(0, 20)}..." : value;
    }
    this.requestHeaders.remove(_keyDioRequestID);
    //
    this.requestQueryParameters = {};
    this.requestQueryParameters.addAll(requestQueryParameters);
    mapData = {};
    if (formData != null) {
      if (formData is FormData) {
        for (MapEntry<String, String> e in formData.fields) {
          mapData[e.key] = e.value;
        }
      } else if (formData is Map<String, dynamic>) {
        mapData.addAll(formData);
      } else if (formData is Map<dynamic, dynamic>) {
        mapData.addAll({});
      } else if (formData is String) {
        mapData.addAll(jsonDecode(formData));
      } else {
        print(">>>>>>>>> TODO: $formData --> type: ${formData.runtimeType}");
        throw Error();
      }
    }
  }

  void __convertResponse() {
    if (!__jsonDataReady) {
      // Response Null.
      if (responseData == null) {
        __responseJsonObjOrArray = null;
        __responseText = null;
        __hasNoResponseData = true;
      }
      // String
      else if (responseData is String) {
        __responseText = responseData;
        __responseJsonObjOrArray = __jsonDecode(responseData);
        if (__responseJsonObjOrArray != null) {
          String? json = toBeautifulJson(__responseJsonObjOrArray!);
          if (json != null) {
            __responseText = json;
          }
        }
        __hasNoResponseData = false;
      }
      // List or Map:
      else if (responseData is List || responseData is Map) {
        __responseJsonObjOrArray = responseData;
        __responseText = toBeautifulJson(__responseJsonObjOrArray!);
        __hasNoResponseData = false;
      }
      // Others:
      else {
        __responseJsonObjOrArray = null;
        __responseText = null;
        __hasNoResponseData = false;
      }
      __jsonDataReady = true;
    }
  }

  bool hasNoResponseData() {
    return __hasNoResponseData;
  }

  Object? toJsonObjOrArray() {
    __convertResponse();
    return __responseJsonObjOrArray;
  }

  String? toResponseText() {
    __convertResponse();
    return __responseText;
  }

  Object? __jsonDecode(String text) {
    try {
      return jsonDecode(text);
    } catch (e) {
      return null;
    }
  }

  bool get isError {
    return __apiError != null;
  }

  void _setError(ApiError apiError) {
    __apiError = apiError;
    //
    responseStatusCode = apiError.statusCode;
    responseStatusMessage = apiError.statusMessage;
  }

  // The Server return data.
  void _setResponseInfo({
    required int dioRequestID,
    required dynamic responseData,
    required int? responseStatusCode,
    required String? responseStatusMessage,
  }) {
    assert(this.dioRequestID == dioRequestID);
    //
    this.responseStatusCode = responseStatusCode;
    this.responseStatusMessage = responseStatusMessage;
    this.responseData = responseData;
  }
}
