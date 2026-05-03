part of '../../../rest_debug_screen.dart';

class _DebugNetworkInspectorDialog extends StatelessWidget {
  final bool showJson;
  final bool showToken;
  final Function()? onHelpPressed;

  const _DebugNetworkInspectorDialog({
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
      titleText: "Debug Network Inspector",
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
    return DebugNetworkInspectorView(
      showJson: showJson,
      showToken: showToken,
      showInScrollView: true,
    );
  }
}

Future<void> showDebugNetworkInspector(
  BuildContext context, {
  required bool showJson,
  required bool showToken,
  Function()? onHelpPressed,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _DebugNetworkInspectorDialog(
        showJson: showJson,
        showToken: showToken,
        onHelpPressed: onHelpPressed,
      );
    },
  ).then((_) {
    apiLogger.resetFilters();
  });
}
