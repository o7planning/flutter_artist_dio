part of '../../../rest_debug_screen.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _RestJsonTreeViewDialog extends StatelessWidget {
  final Object jsonObjOrArray;

  const _RestJsonTreeViewDialog({
    super.key,
    required this.jsonObjOrArray,
  });

  @override
  Widget build(BuildContext context) {
    Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 800,
      preferredHeight: 520,
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
    return _JsonTreeView(
      jsonObjOrArray: jsonObjOrArray,
    );
  }
}

Future<void> showJsonTreeViewDialog(
  BuildContext context, {
  required Object jsonObjOrArray,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _RestJsonTreeViewDialog(
        jsonObjOrArray: jsonObjOrArray,
      );
    },
  );
}
