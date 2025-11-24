part of '../../../flutter_artist_dio.dart';

int __apiLogSequence = 1;

class ApiLogData {
  late final int apiLogId;
  late final RequestLogData requestLogData;

  final String? token = "???";

  ResponseLogData? get responseLogData => _responseLogData;

  ErrorLogData? get errorLogData => _errorLogData;

  ApiError? get conversationError => _conversationError;

  ResponseLogData? _responseLogData;
  ErrorLogData? _errorLogData;

  // Conversation error:
  ApiError? _conversationError;

  ApiLogData(RequestOptions options) {
    apiLogId = __apiLogSequence++;
    requestLogData = RequestLogData(
      options: options,
    );
  }

  bool get isResponseError =>
      _errorLogData != null || _conversationError != null;

  String? getResponseText() {
    if (_responseLogData != null) {
      return _responseLogData!.getResponseText();
    } else if (_errorLogData != null) {
      return _errorLogData!.getResponseText();
    } else {
      return null;
    }
  }

  Object? getRealJsonObjOrArray() {
    if (_responseLogData != null) {
      return _responseLogData!.getRealJsonObjOrArray();
    } else if (_errorLogData != null) {
      return _errorLogData!.getRealJsonObjOrArray();
    } else {
      return null;
    }
  }

  bool hasNoResponseData() {
    // TODO: Xem lai.
    return _responseLogData == null && _errorLogData == null;
  }

  void _setResponseInfo(ResponseLogData responseInfo) {
    _responseLogData = responseInfo;
  }

  void _setErrorInfo(ErrorLogData errorInfo) {
    _errorLogData = errorInfo;
  }

  // Error after response successful (For example: Conversation error).
  void _setConversationError(ApiError? apiError) {
    _conversationError = apiError;
  }
}
