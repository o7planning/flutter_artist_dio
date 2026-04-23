part of '../../../rest_debug_screen.dart';

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
    final Size preferContentSize = calculatePreferredDialogSize(
      context,
      preferredWidth: 1200,
      preferredHeight: 620,
    );

    FaDialog alert = FaDialog(
      iconData: Icons.bug_report,
      titleText: "Rest Debug Viewer",
      contentPadding: EdgeInsets.all(5),
      allowFullScreen: true,
      preferredContentWidth: preferContentSize.width,
      preferredContentHeight: preferContentSize.height,
      content: _buildMainWidget(),
       enableFullscreenAnimation: true,
       resizable: false,
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
  ).then((_) {
    apiLogger.resetFilters();
  });
}
