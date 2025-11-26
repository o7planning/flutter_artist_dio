part of '../../../flutter_artist_dio.dart';

int __apiLogSequence = 1;

class ApiLogData {
  late final int apiLogId;
  late final RequestLogData requestLogData;

  final String? token = "???";

  ResponseLogData? get responseLogData => _responseLogData;

  DioErrorLogData? get dioErrorLogData => _dioErrorLogData;

  ApiError? get conversationError => _conversationError;

  ResponseLogData? _responseLogData;
  DioErrorLogData? _dioErrorLogData;

  // Conversation error:
  ApiError? _conversationError;

  ApiLogData(RequestOptions options) {
    apiLogId = __apiLogSequence++;
    requestLogData = RequestLogData(
      options: options,
    );
  }

  ApiError? getApiError() {
    return _dioErrorLogData?.toApiError() ?? conversationError;
  }

  bool get hasError => _dioErrorLogData != null || _conversationError != null;

  String? getResponseText() {
    if (_responseLogData != null) {
      return _responseLogData!.getResponseText();
    } else if (_dioErrorLogData != null) {
      return _dioErrorLogData!.getResponseText();
    } else {
      return null;
    }
  }

  Object? getRealJsonObjOrArray() {
    if (_responseLogData != null) {
      return _responseLogData!.getRealJsonObjOrArray();
    } else if (_dioErrorLogData != null) {
      return _dioErrorLogData!.getRealJsonObjOrArray();
    } else {
      return null;
    }
  }

  bool hasNoResponseData() {
    // TODO: Xem lai.
    return _responseLogData == null && _dioErrorLogData == null;
  }

  void _setResponseInfo(ResponseLogData responseInfo) {
    _responseLogData = responseInfo;
  }

  void _setErrorInfo(DioErrorLogData errorInfo) {
    _dioErrorLogData = errorInfo;
  }

  // Error after response successful (For example: Conversation error).
  void _setConversationError(ApiError? apiError) {
    _conversationError = apiError;
  }
}
