part of '../../../flutter_artist_dio.dart';

class ApiLogger {
  int __apiLogSequence = 1;
  final int maxLogEntryCount = 50;
  final Map<int, ApiLogData> _map = SplayTreeMap((int a, int b) => b - a);
  int? _selectedDioRequestID;
  int? _comparisonDioRequestID;

  // Multi-filter logic
  final Set<String> selectedMethods = {};
  bool showOnlyErrors = false;

  bool splitMode = false;
  bool syncMode = true;

  static final ApiLogger instance = ApiLogger._();

  ApiLogger._();

  ApiLogData _createApiLogData(RequestOptions options) {
    return ApiLogData._(__apiLogSequence++, options);
  }

  int? get selectedDioRequestID {
    var logs = getApiLogDatas();
    if (logs.isEmpty) {
      _selectedDioRequestID = null;
    } else if (_selectedDioRequestID == null ||
        !_contains(_selectedDioRequestID!)) {
      _selectedDioRequestID = logs.first.apiLogId;
    }
    return _selectedDioRequestID;
  }

  int? get comparisonDioRequestID {
    if (_comparisonDioRequestID == null ||
        !_contains(_comparisonDioRequestID!)) {
      _comparisonDioRequestID = selectedDioRequestID;
    }
    return _comparisonDioRequestID;
  }

  bool _contains(int id) {
    var logs = getApiLogDatas();
    for (ApiLogData log in logs) {
      if (log.apiLogId == id) {
        return true;
      }
    }
    return false;
  }

  void resetFilters() {
    selectedMethods.clear();
    showOnlyErrors = false;
  }

  void _addApiLogData(ApiLogData apiLogData) {
    _map[apiLogData.apiLogId] = apiLogData;
    if (_map.length > maxLogEntryCount) {
      _map.remove(_map.keys.last); // remove oldest
    }
  }

  void clearLogs() {
    _map.clear();
    _selectedDioRequestID = null;
    resetFilters();
  }

  void toggleSplitMode() {
    splitMode = !splitMode;
    if (splitMode && syncMode) {
      _comparisonDioRequestID = _selectedDioRequestID;
    }
  }

  void toggleSyncMode() {
    syncMode = !syncMode;
    if (syncMode) {
      _comparisonDioRequestID = _selectedDioRequestID;
    }
  }

  void setSelectedDioRequestID(int id) {
    _selectedDioRequestID = id;
    if (syncMode) {
      _comparisonDioRequestID = id;
    }
  }

  void setComparisonDioRequestID(int? id) {
    _comparisonDioRequestID = id;
  }

  List<String> getAvailableMethods() {
    return _map.values.map((e) => e.requestLogData.method).toSet().toList();
  }

  List<ApiLogData> getApiLogDatas() {
    return _map.values.where((log) {
      bool matchMethod = selectedMethods.isEmpty ||
          selectedMethods.contains(log.requestLogData.method);
      bool matchError = !showOnlyErrors || log.hasError;
      return matchMethod && matchError;
    }).toList();
  }

  int get requestCount => _map.length;

  ApiLogData? getApiLogData(int dioRequestId) => _map[dioRequestId];

  ApiLogData? getSelectedApiLogData() => _map[selectedDioRequestID];

  ApiLogData? getComparisonApiLogData() {
    return _map[comparisonDioRequestID];
  }

  List<ApiLogData> getErrorLogs() =>
      _map.values.where((e) => e.hasError).toList();

  ApiLogData? getLastApiLogData() {
    if (_map.isEmpty) {
      return null;
    }
    return _map[_map.keys.first];
  }
}
