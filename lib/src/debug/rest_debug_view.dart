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
  RequestLogInfo? info;
  bool fullView = false;

  @override
  void initState() {
    super.initState();
    info = restLogger.getSelectedRequestLogInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DioRequestListSection(
          onSelectRequestId: _onSelectRequestId,
        ),
        if (info != null) const Divider(height: 6),
        if (info != null)
          _DioPathSection(
            info: info!,
          ),
        const Divider(height: 6),
        if (fullView && info != null)
          Expanded(
            child: _ResponseView(
              requestLogInfo: info!,
              onFullScreenPressed: _onFullScreenPressed,
              fullView: fullView,
            ),
          ),
        if ((!fullView || info == null) && widget.showInScrollView)
          Expanded(
            child: SingleChildScrollView(
              child: _buildMain(context),
            ),
          ),
        if ((!fullView || info == null) && !widget.showInScrollView)
          SingleChildScrollView(
            child: _buildMain(context),
          ),
      ],
    );
  }

  Widget _buildMain(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          if (info != null) //
            _DioRequestInfoSection(info: info!, showToken: widget.showToken),
          if (info != null) const SizedBox(height: 10),
          if (info != null) //
            _DioResponseSection(
              info: info!,
              showJson: widget.showJson,
              onFullScreenPressed: _onFullScreenPressed,
              fullView: fullView,
            ),
        ],
      ),
    );
  }

  void _onSelectRequestId(int requestId) {
    restLogger.setSelectedDioRequestID(requestId);
    info = restLogger.getSelectedRequestLogInfo();
    setState(() {});
  }

  void _onFullScreenPressed() {
    setState(() {
      fullView = !fullView;
    });
  }
}
