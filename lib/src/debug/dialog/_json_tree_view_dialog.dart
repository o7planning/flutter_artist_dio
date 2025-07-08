part of '../../../rest_debug_screen.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _RestJsonTreeViewDialog extends StatefulWidget {
  final Object jsonObjOrArray;

  const _RestJsonTreeViewDialog({
    super.key,
    required this.jsonObjOrArray,
  });

  @override
  State<StatefulWidget> createState() {
    return __RestJsonTreeViewDialogState();
  }
}

class __RestJsonTreeViewDialogState extends State<_RestJsonTreeViewDialog> {
  bool showTree = true;

  @override
  Widget build(BuildContext context) {
    Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 800,
      preferredHeight: 520,
    );
    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        Icons.bug_report,
        size: 20,
        color: Colors.indigo,
      ),
      titleText: "Find data conversion errors.",
      content: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(5),
        child: _buildMainWidget(),
      ),
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
              "The JSON version has been amputated to find errors easier."),
        ),
        Divider(),
        Expanded(
          child: Stack(
            children: [
              if (showTree)
                _JsonTreeView(
                  jsonObjOrArray: widget.jsonObjOrArray,
                ),
              if (!showTree)
                _TextView(
                  text: JsonUtils.toBeautifulJson(widget.jsonObjOrArray) ?? "",
                ),
              Positioned(top: 5, right: 5, child: _buildControlBar()),
            ],
          ),
        ),
      ],
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
      ],
    );
  }

  void _copy() {
    String? text = JsonUtils.toBeautifulJson(widget.jsonObjOrArray);
    Clipboard.setData(ClipboardData(text: text ?? ""));
    _closeAllSnackBars(context);
    _showSnackBar(
      context,
      "Copied",
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
