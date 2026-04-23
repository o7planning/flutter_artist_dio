part of '../../rest_debug_screen.dart';

class RestDebugView extends StatefulWidget {
  final bool showJson;
  final bool showToken;
  final bool showInScrollView;

  const RestDebugView({
    super.key,
    required this.showJson,
    required this.showToken,
    required this.showInScrollView,
  });

  @override
  State<StatefulWidget> createState() {
    return _RestDebugViewState();
  }
}

class _RestDebugViewState extends State<RestDebugView> {
  ApiLogData? apiLogData;
  bool fullView = false;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    apiLogData = apiLogger.getSelectedApiLogData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RequestListSection(
          onSelectRequestId: _onSelectRequestId,
        ),
        if (apiLogData != null) const Divider(height: 6),
        if (apiLogData != null)
          _PathSection(
            info: apiLogData!,
            onFullScreenPressed: _onFullScreenPressed,
          ),
        SizedBox(height: 5),
        if (!fullView && apiLogData != null)
          Expanded(
            child: _buildMain(context),
          ),
        if (fullView && apiLogData != null) Divider(height: 6),
        if (fullView && apiLogData != null)
          Expanded(
            child: _ResponseBodySection(
              apiLogData: apiLogData!,
              onFullScreenPressed: _onFullScreenPressed,
              fullView: fullView,
            ),
          ),
      ],
    );
  }

  Widget _buildMain(BuildContext context) {
    List<TabData> tabs = [];

    if (apiLogData != null) {
      tabs.add(
        TabData(
          id: "RequestHeaders",
          text: ' Request Headers',
          closable: false,
          leading: (context, status) => Icon(
            Icons.request_page,
            color: TabThemeUtils.getTabIconColor(context, status),
            size: 16,
          ),
          view: _RequestHeadersSection(
            apiLogData: apiLogData!,
            showAuthorization: widget.showToken,
          ),
        ),
      );
      tabs.add(
        TabData(
          id: "RequestQueryParams",
          text: ' Query Params',
          closable: false,
          leading: (context, status) => Icon(
            Icons.request_page,
            color: TabThemeUtils.getTabIconColor(context, status),
            size: 16,
          ),
          view: _RequestQueryParamsSection(
            apiLogData: apiLogData!,
          ),
        ),
      );
      tabs.add(
        TabData(
          id: "RequestBody",
          text: ' Request Body',
          closable: false,
          leading: (context, status) => Icon(
            Icons.request_page,
            color: TabThemeUtils.getTabIconColor(context, status),
            size: 16,
          ),
          view: _RequestBodySection(
            apiLogData: apiLogData!,
          ),
        ),
      );
      tabs.add(
        TabData(
          id: "Response Headers",
          text: ' Response Headers',
          closable: false,
          leading: (context, status) => Icon(
            Icons.list_alt,
            color: apiLogData!.hasError
                ? Colors.red
                : TabThemeUtils.getTabIconColor(context, status),
            size: 16,
          ),
          view: _ResponseHeadersSection(
            apiLogData: apiLogData!,
            showJson: widget.showJson,
            onFullScreenPressed: _onFullScreenPressed,
            fullView: fullView,
          ),
        ),
      );
      tabs.add(
        TabData(
          id: "Response Body",
          text: ' Response Body',
          closable: false,
          leading: (context, status) => Icon(
            Icons.comment,
            color: TabThemeUtils.getTabIconColor(context, status),
            size: 16,
          ),
          view: _ResponseBodySection(
            key: Key("_ResponseView-${apiLogData!.apiLogId}"),
            apiLogData: apiLogData!,
            onFullScreenPressed: _onFullScreenPressed,
            fullView: fullView,
          ),
        ),
      );
    }
    //
    TabbedViewController _controller = TabbedViewController(tabs);
    _controller.selectedIndex = selectedTabIndex;
    _controller.onTabSelected = ((TabSelection? tabSelection) {
      selectedTabIndex = tabSelection?.index ?? 0;
    });
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData =
        TabThemeUtils.getTabbedViewThemeData(context);

    TabbedViewTheme tabbedViewTheme = TabbedViewTheme(
      data: themeData,
      child: tabbedView,
    );
    //
    return tabbedViewTheme;
  }

  void _onSelectRequestId(int requestId) {
    apiLogger.setSelectedDioRequestID(requestId);
    apiLogData = apiLogger.getSelectedApiLogData();
    setState(() {});
  }

  void _onFullScreenPressed() {
    setState(() {
      fullView = !fullView;
    });
  }
}
