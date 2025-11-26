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

  @override
  void initState() {
    super.initState();
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
              key: Key("ResponseTextView-${widget.apiLogData.apiLogId}"),
              apiLogData: widget.apiLogData,
            ),
          ),
          Visibility(
            visible: showTree,
            child: _ResponseJsonTreeView(
              apiLogData: widget.apiLogData,
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
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
          activeChild: const Text('JSON Tree View'),
          inactiveChild: const Text('Response Text'),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          width: 130.0,
          height: 20.0,
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
            size: 18,
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
              size: 24,
            ),
          ),
      ],
    );
  }

  void _copy() {
    String? text = widget.apiLogData.getResponseText();
    Clipboard.setData(ClipboardData(text: text ?? ""));
    _closeAllSnackBars(context);
    _showSnackBar(
      context,
      "Copied",
    );
  }
}
