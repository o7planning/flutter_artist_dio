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
        _DioRequestListSection(
          onSelectRequestId: _onSelectRequestId,
        ),
        if (apiLogData != null) const Divider(height: 6),
        if (apiLogData != null)
          _DioPathSection(
            info: apiLogData!,
            onFullScreenPressed: _onFullScreenPressed,
          ),
        SizedBox(height: 5),
        if (!fullView && apiLogData != null)
          Expanded(
            child: _buildMain(context),
          ),
        // if (fullView && apiLogData != null) Divider(height: 6),
        // if (fullView && apiLogData != null)
        //   Expanded(
        //     child: _ResponseView(
        //       apiLogData: apiLogData!,
        //       onFullScreenPressed: _onFullScreenPressed,
        //       fullView: fullView,
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildMain(BuildContext context) {
    List<TabData> tabs = [];

    if (apiLogData != null) {
      tabs.add(
        TabData(
          text: ' Request',
          closable: false,
          leading: (context, status) => Icon(
            Icons.request_page,
            color: Colors.black,
            size: 16,
          ),
          content: _DioRequestInfoSection(
            apiLogData: apiLogData!,
            showAuthorization: widget.showToken,
          ),
        ),
      );
    }
    if (apiLogData != null) {
      tabs.add(
        TabData(
          text: ' Response Headers',
          closable: false,
          leading: (context, status) => Icon(
            Icons.list_alt,
            color: apiLogData!.hasError ? Colors.red : Colors.black,
            size: 16,
          ),
          content: _DioResponseSection(
            apiLogData: apiLogData!,
            showJson: widget.showJson,
            onFullScreenPressed: _onFullScreenPressed,
            fullView: fullView,
          ),
        ),
      );
    }
    if (apiLogData != null) {
      tabs.add(
        TabData(
          text: ' Response Body',
          closable: false,
          leading: (context, status) => Icon(
            Icons.comment,
            color: Colors.black,
            size: 16,
          ),
          content: _ResponseView(
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
    _controller.onTabSelection = ((int? idx, __) {
      selectedTabIndex = idx ?? 0;
    });
    TabbedView tabbedView = TabbedView(controller: _controller);

    TabbedViewThemeData themeData = TabThemeUtils.getTabbedViewThemeData();

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
