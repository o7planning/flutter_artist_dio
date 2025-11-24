part of '../../../flutter_artist_dio.dart';

final apiLogger = ApiLogger();

class ApiLogger {
  final Map<int, ApiLogData> _map = SplayTreeMap((int a, int b) {
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

  void _addApiLogData(ApiLogData apiLogData) {
    _map[apiLogData.apiLogId] = apiLogData;
  }

  void setSelectedDioRequestID(int selectedDioRequestID) {
    _selectedDioRequestID = selectedDioRequestID;
  }

  ApiLogData? getApiLogData(int dioRequestId) {
    return _map[dioRequestId];
  }

  ApiLogData? getSelectedApiLogData() {
    return _map[selectedDioRequestID];
  }

  ApiLogData? getLastApiLogData() {
    if (_map.isEmpty) {
      return null;
    }
    return _map[_map.keys.first];
  }

  List<ApiLogData> getApiLogDatas() {
    return _map.entries.map((e) => e.value).toList();
  }
}
