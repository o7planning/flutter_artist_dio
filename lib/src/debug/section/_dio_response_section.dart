part of '../../../rest_debug_screen.dart';

class _DioResponseSection extends StatefulWidget {
  final RequestLogInfo info;
  final bool showJson;

  const _DioResponseSection({
    super.key,
    required this.info,
    required this.showJson,
  });

  @override
  State<StatefulWidget> createState() {
    return __DioResponseSectionState();
  }
}

class __DioResponseSectionState extends State<_DioResponseSection> {
  bool showTree = true;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconLabelText(
            icon: Icon(
              widget.info.errorType == ErrorType.apiError //
                  ? Icons.error
                  : Icons.check_box_rounded,
              size: iconSize,
              color: widget.info.errorType == ErrorType.apiError //
                  ? Colors.red
                  : Colors.blue,
            ),
            label: 'Response Status Code:',
            text: widget.info.responseStatusCode.toString(),
          ),
          //
          if (widget.info.responseStatusMessage != null)
            const SizedBox(height: 10),
          if (widget.info.responseStatusMessage != null)
            IconLabelText(
              icon: const Icon(
                Icons.text_snippet_outlined,
                size: iconSize,
              ),
              label: 'Response Status Message:',
              text: widget.info.responseStatusMessage!,
            ),
          //
          if (widget.info.responseErrorMessage != null)
            const SizedBox(height: 10),
          if (widget.info.responseErrorMessage != null)
            IconLabelText(
              icon: const Icon(
                Icons.text_snippet_outlined,
                size: iconSize,
              ),
              label: 'Error Message:',
              text: widget.info.responseErrorMessage!,
            ),
          //
          if (widget.info.errorParsingJsonMessage != null)
            const SizedBox(height: 10),
          if (widget.info.errorParsingJsonMessage != null)
            IconLabelText(
              icon: const Icon(
                Icons.error,
                color: Colors.red,
                size: iconSize,
              ),
              label: 'JSON Parse Error: ',
              text: widget.info.errorParsingJsonMessage ?? '',
            ),
          //
          if (widget.info.errorConvertingJsonMessage != null)
            const SizedBox(height: 10),
          if (widget.info.errorConvertingJsonMessage != null)
            IconLabelText(
              icon: const Icon(
                Icons.error,
                color: Colors.red,
                size: iconSize,
              ),
              label: 'Conversion Error: ',
              text: widget.info.errorConvertingJsonMessage!,
            ),
          //
          const SizedBox(height: 10),
          IconLabelText(
            icon: Icon(
              Icons.dataset_outlined,
              size: iconSize,
            ),
            label: 'Response Data:',
            text: '',
          ),
          if (widget.showJson) const SizedBox(height: 10),
          if (widget.showJson) _buildJsonView(),
        ],
      ),
    );
  }

  Widget _buildJsonView() {
    return Stack(
      children: [
        if (!showTree) _JsonDataView(data: widget.info.responseData),
        if (showTree)
          SizedBox(
            height: 400,
            child: _JsonTreeView(
              rootData: widget.info.responseData,
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
