part of '../../rest_debug_screen.dart';

class _DioResponseSection extends StatelessWidget {
  final RequestLogInfo info;
  final bool showJson;

  const _DioResponseSection({
    super.key,
    required this.info,
    required this.showJson,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconLabelText(
            icon: Icon(
              info.isServerSideError ? Icons.error : Icons.check_box_rounded,
              size: iconSize,
              color: info.isServerSideError ? Colors.red : Colors.blue,
            ),
            label: 'Response Status Code:',
            text: info.responseStatusCode.toString(),
          ),
          const SizedBox(height: 10),
          _IconLabelText(
            icon: const Icon(
              Icons.text_snippet_outlined,
              size: iconSize,
            ),
            label: 'Response Status Message:',
            text: info.responseStatusMessage ?? '',
          ),
          const SizedBox(height: 10),
          _IconLabelText(
            icon: const Icon(
              Icons.text_snippet_outlined,
              size: iconSize,
            ),
            label: 'Error Message:',
            text: info.responseErrorMessage ?? '',
          ),
          if (info.errorParsingJson) const SizedBox(height: 10),
          if (info.errorParsingJson)
            _IconLabelText(
              icon: const Icon(
                Icons.error,
                color: Colors.red,
                size: iconSize,
              ),
              label: 'JSON Parse Error: ',
              text: info.errorParsingJsonMessage ?? '',
            ),
          //
          const SizedBox(height: 10),
          _IconLabelText(
            icon: Icon(
              Icons.dataset_outlined,
              size: iconSize,
            ),
            label: 'Response Data:',
            text: '',
          ),
          if (showJson) const SizedBox(height: 10),
          if (showJson) _DataView(data: info.responseData),
        ],
      ),
    );
  }
}
