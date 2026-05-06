part of '../../flutter_artist_dio.dart';

class DebugNetworkInspectorView extends StatefulWidget {
  final bool showJson;
  final bool showToken;
  final bool showInScrollView;

  const DebugNetworkInspectorView({
    super.key,
    required this.showJson,
    required this.showToken,
    required this.showInScrollView,
  });

  @override
  State<StatefulWidget> createState() => _DebugNetworkInspectorViewState();
}

class _DebugNetworkInspectorViewState extends State<DebugNetworkInspectorView> {
  ApiLogData? primaryLog;
  ApiLogData? comparisonLog;

  bool fullView = false;
  int selectedTabIndex = 0;

  final Map<String, int> _tabIndexes = {"PRIMARY": 0, "COMPARISON": 0};

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      primaryLog = ApiLogger.instance.getSelectedApiLogData();
      comparisonLog = ApiLogger.instance.getComparisonApiLogData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // 1. Header: List request chips
          _RequestListSection(
            onSelectRequestId: _onSelectRequestId,
            onRefresh: _refreshData,
            onClear: _onClearLogs,
          ),

          // 2. Main Content
          Expanded(
            child: primaryLog == null
                ? _buildEmptyState(theme)
                : _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (ApiLogger.instance.splitMode) {
      return Row(
        children: [
          Expanded(
              child: _buildLogDetailColumn(context, primaryLog!, "PRIMARY")),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: comparisonLog != null
                ? _buildLogDetailColumn(context, comparisonLog!, "COMPARISON")
                : const Center(child: Text("Select a log for comparison")),
          ),
        ],
      );
    }

    return _buildLogDetailColumn(context, primaryLog!, null);
  }

  Widget _buildLogDetailColumn(
      BuildContext context, ApiLogData log, String? label) {
    final String key = label ?? "PRIMARY";

    return Column(
      children: [
        _PathSection(
          info: log,
          label: label,
          onFullScreenPressed: _onFullScreenPressed,
        ),
        Expanded(
          child: (!fullView)
              ? _buildMainTabs(context, log, key)
              : _ResponseBodySection(
                  key: ValueKey("full_body_${log.apiLogId}"),
                  apiLogData: log,
                  onFullScreenPressed: _onFullScreenPressed,
                  fullView: fullView,
                ),
        ),
      ],
    );
  }

  Widget _buildMainTabs(BuildContext context, ApiLogData log, String sideKey) {
    List<TabData> tabs = [
      _createTab(
          log,
          " Headers",
          Icons.http,
          _RequestHeadersSection(
              apiLogData: log, showAuthorization: widget.showToken)),
      _createTab(log, " Params", Icons.find_in_page_outlined,
          _RequestQueryParamsSection(apiLogData: log)),
      _createTab(
          log, " Body", Icons.input, _RequestBodySection(apiLogData: log)),
      _createTab(
          log,
          " Res. Headers",
          Icons.list_alt,
          _ResponseHeadersSection(
              apiLogData: log,
              showJson: widget.showJson,
              onFullScreenPressed: _onFullScreenPressed,
              fullView: fullView),
          isError: log.hasError),
      _createTab(
          log,
          " Res. Body",
          Icons.list_alt,
          _ResponseBodySection(
            key: ValueKey("res_body_${log.apiLogId}"),
            apiLogData: log,
            onFullScreenPressed: _onFullScreenPressed,
            fullView: fullView,
          )),
    ];

    final controller = TabbedViewController(tabs);

    controller.selectedIndex = _tabIndexes[sideKey] ?? 0;

    controller.onTabSelected = (sel) {
      if (mounted) {
        setState(() {
          _tabIndexes[sideKey] = sel?.index ?? 0;
        });
      }
    };

    return TabbedViewTheme(
      data: TabThemeUtils.getTabbedViewThemeData(context),
      child: TabbedView(controller: controller),
    );
  }

  TabData _createTab(ApiLogData log, String title, IconData icon, Widget view,
      {bool isError = false}) {
    return TabData(
      id: "${log.apiLogId}_$title",
      text: title,
      closable: false,
      leading: (context, status) => Icon(
        icon,
        size: 14,
        color: isError
            ? Theme.of(context).colorScheme.error
            : TabThemeUtils.getTabIconColor(context, status),
      ),
      view: view,
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.api_outlined,
              size: 48, color: theme.disabledColor.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text("No logs selected",
              style: TextStyle(color: theme.disabledColor)),
        ],
      ),
    );
  }

  void _onSelectRequestId(int requestId) {
    ApiLogger.instance.setSelectedDioRequestID(requestId);
    _refreshData();
  }

  void _onClearLogs() {
    ApiLogger.instance.clearLogs();
    _refreshData();
    Navigator.of(context).pop();
  }

  void _onFullScreenPressed() {
    setState(() {
      fullView = !fullView;
    });
  }
}
