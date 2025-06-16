part of '../../flutter_artist_dio.dart';

var restLogger = RestLogger();

class RestLogger {
  final Map<int, RequestLogInfo> _map = SplayTreeMap((int a, int b) {
    return b - a;
  });

  int? _selectedDioRequestID;

  int? get selectedDioRequestID {
    if (_selectedDioRequestID == null && _map.isNotEmpty) {
      _selectedDioRequestID = _map.keys.first;
    }
    return _selectedDioRequestID;
  }

  int get requestCount => _map.length;

  void setSelectedDioRequestID(int selectedDioRequestID) {
    _selectedDioRequestID = selectedDioRequestID;
  }

  RequestLogInfo createRequestLogInfo({
    required int dioRequestId,
    required String baseUrl,
    required String requestPath,
    required String requestMethod,
    required Map<String, dynamic> requestHeaders,
    required Map<String, dynamic> requestQueryParameters,
    required dynamic formData,
    required String? token,
  }) {
    RequestLogInfo info = RequestLogInfo(
      dioRequestID: dioRequestId,
      baseUrl: baseUrl,
      requestPath: requestPath,
      requestMethod: requestMethod,
      requestHeaders: requestHeaders,
      requestQueryParameters: requestQueryParameters,
      formData: formData,
      token: token,
    );
    _map[dioRequestId] = info;
    if (_map.length > 20) {
      int lastKey = _map.keys.last;
      _map.remove(lastKey);
    }
    return info;
  }

  RequestLogInfo? getRequestLogInfo(int dioRequestId) {
    return _map[dioRequestId];
  }

  RequestLogInfo? getSelectedRequestLogInfo() {
    return _map[selectedDioRequestID];
  }

  RequestLogInfo? getLastRequestLogInfo() {
    if (_map.isEmpty) {
      return null;
    }
    return _map[_map.keys.first];
  }

  List<RequestLogInfo> getRequestLogInfos() {
    return _map.entries.map((e) => e.value).toList();
  }
}
