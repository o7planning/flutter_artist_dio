part of '../../../rest_debug_screen.dart';

class _ResponseView extends StatefulWidget {
  final bool fullView;
  final EdgeInsets padding;
  final ApiLogData apiLogData;
  final Function()? onFullScreenPressed;

  const _ResponseView({
    super.key,
    required this.apiLogData,
    required this.onFullScreenPressed,
    required this.fullView,
    this.padding = const EdgeInsets.all(5),
  });

  @override
  State<StatefulWidget> createState() {
    return _ResponseViewState();
  }
}

class _ResponseViewState extends State<_ResponseView> {
  bool showTree = true;
  late ApiLogData _apiLogData;

  @override
  void initState() {
    super.initState();
    _apiLogData = widget.apiLogData;
  }

  @override
  void didUpdateWidget(_ResponseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_apiLogData.apiLogId != widget.apiLogData.apiLogId) {
      setState(() {
        _apiLogData = widget.apiLogData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Stack(
        children: [
          Visibility(
            visible: !showTree,
            child: _ResponseTextView(
              key: Key("ResponseTextView-${_apiLogData.apiLogId}"),
              apiLogData: _apiLogData,
            ),
          ),
          Visibility(
            visible: showTree,
            child: _ResponseJsonTreeView(
              key: Key("_ResponseJsonTreeView-${_apiLogData.apiLogId}"),
              apiLogData: _apiLogData,
            ),
          ),
          Positioned(
            top: 5,
            right: 0,
            child: _buildControlBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        AdvancedSwitch(
          initialValue: showTree,
          activeColor: Colors.indigo,
          inactiveColor: Colors.grey,
          activeChild: const Text(
            'JSON Tree View',
            style: TextStyle(fontSize: 12),
          ),
          inactiveChild: const Text(
            'Response Text',
            style: TextStyle(fontSize: 12),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          width: 130.0,
          height: 18.0,
          enabled: true,
          onChanged: (dynamic checked) {
            showTree = !showTree;
            setState(() {});
          },
        ),
        SizedBox(width: 10),
        TextButton(
          onPressed: _copy,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
          ),
          child: Icon(
            Icons.copy,
            size: 16,
          ),
        ),
        if (widget.onFullScreenPressed != null) SizedBox(width: 10),
        if (widget.onFullScreenPressed != null)
          TextButton(
            onPressed: widget.onFullScreenPressed,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
            child: Icon(
              widget.fullView ? Icons.fullscreen_exit : Icons.fullscreen,
              size: 22,
            ),
          ),
      ],
    );
  }

  void _copy() {
    String? text = _apiLogData.getResponseText();
    Clipboard.setData(ClipboardData(text: text ?? ""));
    _closeAllSnackBars(context);
    _showSnackBar(
      context,
      "Copied",
    );
  }
}
