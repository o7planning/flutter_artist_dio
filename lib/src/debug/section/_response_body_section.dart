part of '../../../rest_debug_screen.dart';

class _ResponseBodySection extends StatefulWidget {
  final bool fullView;
  final EdgeInsets padding;
  final ApiLogData apiLogData;
  final Function()? onFullScreenPressed;

  const _ResponseBodySection({
    super.key,
    required this.apiLogData,
    required this.onFullScreenPressed,
    required this.fullView,
    this.padding = const EdgeInsets.all(5),
  });

  @override
  State<StatefulWidget> createState() {
    return _ResponseBodySectionState();
  }
}

class _ResponseBodySectionState extends State<_ResponseBodySection> {
  late ValueNotifier<bool> _switchController;
  bool showTree = true;
  late ApiLogData _apiLogData;

  @override
  void initState() {
    super.initState();
    _apiLogData = widget.apiLogData;
    _switchController = ValueNotifier<bool>(showTree);

    _switchController.addListener(() {
      setState(() {
        showTree = _switchController.value;
      });
    });
  }

  @override
  void dispose() {
    _switchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_ResponseBodySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_apiLogData.apiLogId != widget.apiLogData.apiLogId) {
      setState(() {
        _apiLogData = widget.apiLogData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: widget.padding,
      child: Column(
        children: [
          _buildControlBar(),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: showTree
                  ? _ResponseJsonTreeView(
                      key: Key("ResponseJsonTree-${_apiLogData.apiLogId}"),
                      apiLogData: _apiLogData,
                    )
                  : _ResponseTextView(
                      key: Key("ResponseTextView-${_apiLogData.apiLogId}"),
                      apiLogData: _apiLogData,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _CustomAppContainer.bar(
      child: Row(
        children: [
          AdvancedSwitch(
            controller: _switchController,
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.surfaceContainerHigh,
            activeChild: Text(
              'JSON TREE',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                  letterSpacing: 0.5),
            ),
            inactiveChild: Text(
              'RAW TEXT',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant),
            ),
            width: 85.0,
            height: 16.0,
          ),
          const Spacer(),
          SimpleSmallIconButton(
            iconData: Icons.copy_all_rounded,
            iconSize: 15,
            iconColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            onPressed: _copy,
          ),
          if (widget.onFullScreenPressed != null) ...[
            const SizedBox(width: 4),
            SimpleSmallIconButton(
              iconData: widget.fullView
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
              iconSize: 18,
              iconColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              onPressed: widget.onFullScreenPressed,
            ),
          ],
        ],
      ),
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
