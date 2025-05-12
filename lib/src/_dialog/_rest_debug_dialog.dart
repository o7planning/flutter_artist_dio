part of '../../rest_debug_screen.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _RestDebugDialogDialog extends StatefulWidget {
  final bool showJson;
  final bool showToken;

  const _RestDebugDialogDialog({
    super.key,
    required this.showJson,
    required this.showToken,
  });

  @override
  State<_RestDebugDialogDialog> createState() {
    return __RestDebugDialogDialogState();
  }
}

class __RestDebugDialogDialogState extends State<_RestDebugDialogDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 1000,
      preferredHeight: 620,
    );

    Widget contentWidget = _CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: _buildMainWidget(),
    );

    FaAlertDialog alert = FaAlertDialog(
      titleText: "Rest Debug Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return RestDebugSection(
      showJson: widget.showJson,
      showToken: widget.showToken,
      showInScrollView: true,
    );
  }
}

Future<void> showRestDebugDialog(
  BuildContext context, {
  required bool showJson,
  required bool showToken,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _RestDebugDialogDialog(
        showJson: showJson,
        showToken: showToken,
      );
    },
  );
}
