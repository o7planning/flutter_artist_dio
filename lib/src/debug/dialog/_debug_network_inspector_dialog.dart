part of '../../../flutter_artist_dio.dart';

class DebugNetworkInspectorDialog extends StatelessWidget {
  final bool showJson;
  final bool showToken;
  final Function()? onHelpPressed;

  const DebugNetworkInspectorDialog._({
    super.key,
    required this.showJson,
    required this.showToken,
    required this.onHelpPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required bool showJson,
    required bool showToken,
    Function()? onHelpPressed,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugNetworkInspectorDialog._(
          showJson: showJson,
          showToken: showToken,
          onHelpPressed: onHelpPressed,
        );
      },
    ).then((_) {
      ApiLogger.instance.resetFilters();
    });
  }

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
