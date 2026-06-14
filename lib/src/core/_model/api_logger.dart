part of '../../../flutter_artist_dio.dart';

/// The central telemetry tracking ledger and state management coordinator
/// for the FlutterArtist network monitoring infrastructure.
///
/// It encapsulates an internal memory-backed storage buffer, maintains multi-filter criteria
/// configurations, and orchestrates secondary layout alignment keys ([splitMode], [syncMode])
/// without leaking mutation side-effects to the presentation layer.
class ApiLogger {
  /// The internal auto-incrementing transactional identity sequence pointer token.
  int __apiLogSequence = 1;

  /// The maximum capacity threshold ceiling restricting how many monitored HTTP request
  /// nodes are retained inside the volatile local buffer memory before purging.
  final int maxLogEntryCount = 50;

  /// The internal sorted index map holding transaction historical records.
  ///
  /// Arranged using a specialized inverted lookup sorting pattern `(int a, int b) => b - a`
  /// to ensure the newest captured packet logs consistently occupy top positioning ranks.
  final Map<int, ApiLogData> _map = SplayTreeMap((int a, int b) => b - a);

  /// The explicit database identity sequence pointer indicating the primary target selected for detail viewing.
  int? _selectedDioRequestID;

  /// The explicit secondary identity sequence pointer tracking the comparison evaluation target row.
  int? _comparisonDioRequestID;

  /// The active historical HTTP request verb filter criteria tracking collection (e.g., GET, POST).
  ///
  /// When this collection is empty, all captured method verb channels pass evaluation boundaries safely.
  final Set<String> selectedMethods = {};

  /// Dictates if request records without structural connection errors or bad response codes
  /// should be filtered out from active lookups.
  bool showOnlyErrors = false;

  /// Governs whether the layout interface splits into a dual-pane side-by-side transaction analyzer.
  bool splitMode = false;

  /// Dictates if the comparison panel pointer automatically locks and duplicates the primary target ID.
  bool syncMode = true;

  /// The absolute global singleton access gateway instance exposing the unified network ledger pipeline.
  static final ApiLogger instance = ApiLogger._();

  ApiLogger._();

  /// Internal factory generator transforming standard [RequestOptions] telemetry frames
  /// straight into initialized, identity-stamped [ApiLogData] record packages.
  ApiLogData _createApiLogData(RequestOptions options) {
    return ApiLogData._(__apiLogSequence++, options);
  }

  /// Resolves the valid runtime primary target log identifier.
  ///
  /// If the current selection pool falls empty, it resets to `null`. If the previous cached index
  /// becomes invalid due to cache purge operations, it gracefully self-corrects to track the latest record entry.
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

  /// Resolves the valid runtime comparison target log identifier.
  ///
  /// Gracefully falls back to inherit the exact value of the [selectedDioRequestID] pipeline
  /// whenever the targeted key drops outside the active buffered record index track limits.
  int? get comparisonDioRequestID {
    if (_comparisonDioRequestID == null ||
        !_contains(_comparisonDioRequestID!)) {
      _comparisonDioRequestID = selectedDioRequestID;
    }
    return _comparisonDioRequestID;
  }

  /// Performs an internal localized structural scan to determine if a specific [id] exists
  /// inside the currently filtered data transaction pool list bounds.
  bool _contains(int id) {
    var logs = getApiLogDatas();
    for (ApiLogData log in logs) {
      if (log.apiLogId == id) {
        return true;
      }
    }
    return false;
  }

  /// flattens and resets all active filtering parameters, reverting data query pipelines back to baseline views.
  void resetFilters() {
    selectedMethods.clear();
    showOnlyErrors = false;
  }

  /// Injects a newly compiled [ApiLogData] node straight into the local index ledger array map.
  ///
  /// Automatically drops the oldest trace pointer entry whenever the current collection length
  /// slips beyond the hardcoded [maxLogEntryCount] allocation barrier.
  void _addApiLogData(ApiLogData apiLogData) {
    _map[apiLogData.apiLogId] = apiLogData;
    if (_map.length > maxLogEntryCount) {
      _map.remove(_map.keys.last); // remove oldest
    }
  }

  /// Clears out all current transient database logs, drops active pointers, and wipes filter variables clean.
  void clearLogs() {
    _map.clear();
    _selectedDioRequestID = null;
    resetFilters();
  }

  /// Switches the dual-pane rendering orientation framework flag dynamically.
  ///
  /// Automatically mirrors the primary target pointer over to the secondary tracking key
  /// if [syncMode] is concurrently active upon initiation ticks.
  void toggleSplitMode() {
    splitMode = !splitMode;
    if (splitMode && syncMode) {
      _comparisonDioRequestID = _selectedDioRequestID;
    }
  }

  /// Toggles the automated comparison target tracking synchronizer alignment switch state.
  ///
  /// Instantly binds the secondary key pointer back to the primary selection path value when activated.
  void toggleSyncMode() {
    syncMode = !syncMode;
    if (syncMode) {
      _comparisonDioRequestID = _selectedDioRequestID;
    }
  }

  /// Forces the primary selection path database pointer to target a specific transaction [id].
  ///
  /// Automatically updates comparison targets down the pipe if [syncMode] is enabled.
  void setSelectedDioRequestID(int id) {
    _selectedDioRequestID = id;
    if (syncMode) {
      _comparisonDioRequestID = id;
    }
  }

  /// Assigns a specialized comparison data target pointer directly via an explicit nullable [id].
  void setComparisonDioRequestID(int? id) {
    _comparisonDioRequestID = id;
  }

  /// Harvests and evaluates the unique collection set of all distinct HTTP request verb strings
  /// currently tracked inside the un-filtered volatile memory buffer.
  List<String> getAvailableMethods() {
    return _map.values.map((e) => e.requestLogData.method).toSet().toList();
  }

  /// Queries and extracts the active list collection of [ApiLogData] elements,
  /// matching records strictly against the current [selectedMethods] and [showOnlyErrors] constraints.
  List<ApiLogData> getApiLogDatas() {
    return _map.values.where((log) {
      bool matchMethod = selectedMethods.isEmpty ||
          selectedMethods.contains(log.requestLogData.method);
      bool matchError = !showOnlyErrors || log.hasError;
      return matchMethod && matchError;
    }).toList();
  }

  /// Returns the absolute numerical size count of all requests currently cached in memory bounds.
  int get requestCount => _map.length;

  /// Retrieves a specific immutable packet tracking record matching a concrete [dioRequestId].
  ///
  /// Returns `null` if the reference target has been pruned or unpopulated.
  ApiLogData? getApiLogData(int dioRequestId) => _map[dioRequestId];

  /// Returns the current active primary [ApiLogData] segment mapped to the selection index pointer.
  ApiLogData? getSelectedApiLogData() => _map[selectedDioRequestID];

  /// Returns the current active comparison [ApiLogData] segment mapped to the secondary evaluation track pointer.
  ApiLogData? getComparisonApiLogData() {
    return _map[comparisonDioRequestID];
  }

  /// Filters and returns an isolated list map track containing only failed connection or bad response log payloads.
  List<ApiLogData> getErrorLogs() =>
      _map.values.where((e) => e.hasError).toList();

  /// Returns the absolute newest captured packet record node added into the storage matrix buffer.
  ApiLogData? getLastApiLogData() {
    if (_map.isEmpty) {
      return null;
    }
    return _map[_map.keys.first];
  }
}
