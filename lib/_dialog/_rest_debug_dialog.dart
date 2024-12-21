part of '../rest_debug_screen.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _RestDebugDialogDialog extends StatefulWidget {
  const _RestDebugDialogDialog({
    super.key,
  });

  @override
  State<_RestDebugDialogDialog> createState() {
    return __RestDebugDialogDialogState();
  }
}

class __RestDebugDialogDialogState extends State<_RestDebugDialogDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = _calculateDebugDialogSize(context);

    Widget contentWidget = _CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: _buildMainWidget(),
    );

    AlertDialog alert = _CustomAlertDialog(
      titleText: "Rest Debug Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
      closeDialog: () {
        Navigator.of(context).pop();
      },
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return const RestDebugSection();
  }
}

Future<void> showRestDebugDialog(
  BuildContext context,
) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return const _RestDebugDialogDialog();
    },
  );
}
