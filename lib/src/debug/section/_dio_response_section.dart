part of '../../../rest_debug_screen.dart';

class _DioResponseSection extends StatelessWidget {
  final ApiLogData info;
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
    // Dio Error or Conversion Error.
    final ApiError? apiError = info.getApiError();
    final String? errorMessage = apiError?.errorMessage;
    final List<String>? errorDetails = apiError?.errorDetails;
    //
    final int? statusCode =
        info.responseLogData?.statusCode ?? info.errorLogData?.statusCode;
    final String? statusMessage =
        info.responseLogData?.statusMessage ?? info.errorLogData?.statusMessage;
    //
    const double iconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconLabelText(
            icon: Icon(
              Icons.access_time_outlined,
              size: iconSize,
            ),
            label: 'Response Time: ',
            text: info.getResponseTimeAsString(),
          ),
          if (statusCode != null) const SizedBox(height: 10),
          if (statusCode != null)
            IconLabelText(
              icon: Icon(
                _getErrorIconData(apiError?.errorType),
                size: iconSize,
                color: apiError != null //
                    ? info.hasError
                        ? Colors.red
                        : Colors.blue
                    : Colors.blue,
              ),
              label: 'Response Status: ',
              text: statusCode.toString(),
            ),
          //
          if (statusMessage != null && statusMessage.isNotEmpty)
            const SizedBox(height: 10),
          if (statusMessage != null && statusMessage.isNotEmpty)
            IconLabelText(
              icon: const Icon(
                Icons.text_snippet_outlined,
                size: iconSize,
              ),
              label: 'Response Status Message: ',
              text: statusMessage,
            ),
          //
          if (apiError != null) const SizedBox(height: 10),
          if (apiError != null)
            IconLabelText(
              icon: Icon(
                _getErrorIconData(apiError.errorType),
                color: Colors.red,
                size: iconSize,
              ),
              label: 'Error Type: ',
              text: apiError.errorType?.description ?? ' - ',
              suffixIcon: apiError.errorType != ApiErrorType.conversion
                  ? null
                  : Tooltip(
                      message: "Remove a part of JSON to find errors easier.",
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          _errorDetector(context, apiError);
                        },
                        child: Icon(Icons.bug_report),
                      ),
                    ),
            ),
          if (apiError != null) const SizedBox(height: 10),
          if (apiError != null)
            IconLabelText(
              icon: Icon(
                _getErrorIconData(apiError.errorType),
                color: Colors.red,
                size: iconSize,
              ),
              label: 'Error Message: ',
              text: apiError.errorMessage,
              suffixIcon: TextButton(
                onPressed: () {
                  _copyText(context, apiError.errorMessage);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                ),
                child: Icon(
                  Icons.copy,
                  size: 14,
                ),
              ),
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
                apiLogData: info,
                onFullScreenPressed: onFullScreenPressed,
                fullView: fullView,
              ),
            ),
        ],
      ),
    );
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text ?? ""));
    _closeAllSnackBars(context);
    _showSnackBar(
      context,
      "Copied",
    );
  }

  void _errorDetector(BuildContext context, ApiError apiError) {
    Function(Map<String, dynamic>)? converter = apiError.usedConverter;
    if (converter == null) {
      print(">> No Converter");
      return;
    }
    Object realJsonOBJ = info.getRealJsonObjOrArray() ?? <String, dynamic>{};
    if (realJsonOBJ == null) {
      print(">> realJsonOBJ is null");
      return;
    }
    JsonConversionErrorDetector detector = JsonConversionErrorDetector(
      converter: converter,
      realJsonOBJ: realJsonOBJ,
    );
    Object? jsonOBJMinify = detector.miniatureTheErrorRange();
    if (jsonOBJMinify == null) {
      return;
    }
    showJsonTreeViewDialog(context, jsonObjOrArray: jsonOBJMinify);
  }
}
