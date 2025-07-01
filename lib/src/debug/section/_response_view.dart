part of '../../../rest_debug_screen.dart';

class _ResponseView extends StatefulWidget {
  final RequestLogInfo requestLogInfo;

  const _ResponseView({super.key, required this.requestLogInfo});

  @override
  State<StatefulWidget> createState() {
    return _ResponseViewState();
  }
}

class _ResponseViewState extends State<_ResponseView> {
  bool showTree = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!showTree)
          _ResponseTextView(
            text: widget.requestLogInfo.toResponseText(),
          ),
        if (showTree)
          SizedBox(
            height: 400,
            child: _ResponseJsonTreeView(
              jsonObj: widget.requestLogInfo.toResponseJson(),
            ),
          ),
        Positioned(
          top: 5,
          right: 5,
          child: AdvancedSwitch(
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
        ),
      ],
    );
  }
}
