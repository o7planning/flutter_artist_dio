part of '../../../rest_debug_screen.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _RestJsonTreeViewDialog extends StatelessWidget {
  final bool showJson;
  final bool showToken;

  const _RestJsonTreeViewDialog({
    super.key,
    required this.showJson,
    required this.showToken,
  });

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
      icon: Icon(
        Icons.bug_report,
        size: 20,
        color: Colors.indigo,
      ),
      titleText: "Rest Debug Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return RestDebugView(
      showJson: showJson,
      showToken: showToken,
      showInScrollView: true,
    );
  }
}

Future<void> showJsonTreeViewDialog(
  BuildContext context, {
  required bool showJson,
  required bool showToken,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _RestJsonTreeViewDialog(
        showJson: showJson,
        showToken: showToken,
      );
    },
  );
}
