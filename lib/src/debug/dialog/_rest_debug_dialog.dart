part of '../../../rest_debug_screen.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _RestDebugDialog extends StatelessWidget {
  final bool showJson;
  final bool showToken;
  final Function()? onHelpPressed;

  const _RestDebugDialog({
    super.key,
    required this.showJson,
    required this.showToken,
    required this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 1000,
      preferredHeight: 620,
    );

    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        Icons.bug_report,
        size: 20,
        color: Colors.indigo,
      ),
      titleText: "Rest Debug Viewer",
      content: Container(
        padding: const EdgeInsets.all(2),
        width: size.width,
        height: size.height,
        child: _buildMainWidget(),
      ),
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

Future<void> showRestDebugDialog(
  BuildContext context, {
  required bool showJson,
  required bool showToken,
  Function()? onHelpPressed,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _RestDebugDialog(
        showJson: showJson,
        showToken: showToken,
        onHelpPressed: onHelpPressed,
      );
    },
  );
}
