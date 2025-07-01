part of '../../../rest_debug_screen.dart';

class _DioResponseSection extends StatelessWidget {
  final RequestLogInfo info;
  final bool showJson;
  final Function() onFullScreenPressed;
  final bool fullView;

  const _DioResponseSection({
    super.key,
    required this.info,
    required this.showJson,
    required this.onFullScreenPressed,
    required this.fullView,
  });

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
              info.apiError != null //
                  ? Icons.error
                  : Icons.check_box_rounded,
              size: iconSize,
              color: info.apiError != null //
                  ? Colors.red
                  : Colors.blue,
            ),
            label: 'Response Status Code:',
            text: info.responseStatusCode.toString(),
          ),
          //
          if (info.responseStatusMessage != null) const SizedBox(height: 10),
          if (info.responseStatusMessage != null)
            IconLabelText(
              icon: const Icon(
                Icons.text_snippet_outlined,
                size: iconSize,
              ),
              label: 'Response Status Message:',
              text: info.responseStatusMessage!,
            ),
          //
          // if (info.responseErrorMessage != null) const SizedBox(height: 10),
          // if (info.responseErrorMessage != null)
          //   IconLabelText(
          //     icon: const Icon(
          //       Icons.text_snippet_outlined,
          //       size: iconSize,
          //     ),
          //     label: 'Error Message:',
          //     text: info.responseErrorMessage!,
          //   ),
          //
          if (info.apiError != null) const SizedBox(height: 10),
          if (info.apiError != null)
            IconLabelText(
              icon: const Icon(
                Icons.error,
                color: Colors.red,
                size: iconSize,
              ),
              label: 'Error Type: ',
              text: info.apiError!.apiErrorType?.description ?? ' - ',
            ),
          //
          // if (info.errorConvertingJsonMessage != null)
          //   const SizedBox(height: 10),
          // if (info.errorConvertingJsonMessage != null)
          //   IconLabelText(
          //     icon: const Icon(
          //       Icons.error,
          //       color: Colors.red,
          //       size: iconSize,
          //     ),
          //     label: 'Conversion Error: ',
          //     text: info.errorConvertingJsonMessage!,
          //   ),
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
          if (showJson) const SizedBox(height: 10),
          if (showJson)
            _CustomAppContainer(
              height: 400,
              child: _ResponseView(
                padding: EdgeInsets.zero,
                requestLogInfo: info,
                onFullScreenPressed: onFullScreenPressed,
                fullView: fullView,
              ),
            ),
        ],
      ),
    );
  }
}
