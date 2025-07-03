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
    final ApiError? apiError = info.apiError;
    final String? errorMessage = apiError?.errorMessage;
    final List<String>? errorDetails = apiError?.errorDetails;
    //
    const double iconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (info.responseStatusCode != null)
            IconLabelText(
              icon: Icon(
                apiError != null //
                    ? info.isResponseError
                        ? _getErrorIconData(apiError)
                        : Icons.check_box_rounded
                    : Icons.check_box_rounded,
                size: iconSize,
                color: apiError != null //
                    ? info.isResponseError
                        ? Colors.red
                        : Colors.blue
                    : Colors.blue,
              ),
              label: 'Response Status Code: ',
              text: info.responseStatusCode.toString(),
            ),
          //
          if (info.responseStatusMessage != null &&
              info.responseStatusMessage!.isNotEmpty)
            const SizedBox(height: 10),
          if (info.responseStatusMessage != null &&
              info.responseStatusMessage!.isNotEmpty)
            IconLabelText(
              icon: const Icon(
                Icons.text_snippet_outlined,
                size: iconSize,
              ),
              label: 'Response Status Message: ',
              text: info.responseStatusMessage!,
            ),
          //
          if (apiError != null) const SizedBox(height: 10),
          if (apiError != null)
            IconLabelText(
              icon: Icon(
                _getErrorIconData(apiError),
                color: Colors.red,
                size: iconSize,
              ),
              label: 'Error Type: ',
              text: apiError.apiErrorType?.description ?? ' - ',
            ),
          if (apiError != null) const SizedBox(height: 10),
          if (apiError != null)
            IconLabelText(
              icon: Icon(
                _getErrorIconData(apiError),
                color: Colors.red,
                size: iconSize,
              ),
              label: 'Error Message: ',
              text: apiError.errorMessage,
            ),
          if (apiError != null &&
              errorDetails != null &&
              errorDetails.isNotEmpty)
            ...errorDetails.map(
              (detail) => Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 2, 5),
                child: IconLabelText(
                  icon: Icon(
                    Icons.arrow_right_alt,
                    size: 16,
                  ),
                  text: detail,
                  textStyle: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ),
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
