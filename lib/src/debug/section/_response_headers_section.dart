part of '../../../flutter_artist_dio.dart';

class _ResponseHeadersSection extends StatelessWidget {
  final ApiLogData apiLogData;
  final bool showJson;
  final Function() onFullScreenPressed;
  final bool fullView;

  const _ResponseHeadersSection({
    required this.apiLogData,
    required this.showJson,
    required this.onFullScreenPressed,
    required this.fullView,
  });

  @override
  Widget build(BuildContext context) {
    // Dio Error or Conversion Error.
    final ApiError? apiError = apiLogData.getApiError();
    // final String? errorMessage = apiError?.errorMessage;
    final List<String>? errorDetails = apiError?.errorDetails;
    //
    final int? statusCode = apiLogData.responseLogData?.statusCode ??
        apiLogData.errorLogData?.statusCode;
    final String? statusMessage = apiLogData.responseLogData?.statusMessage ??
        apiLogData.errorLogData?.statusMessage;
    //
    const double defaultIconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconLabelText(
              icon: Icon(
                Icons.access_time_outlined,
                size: defaultIconSize,
              ),
              label: 'Response Time: ',
              text: apiLogData.getResponseTimeAsString(),
              labelStyle: defaultLabelStyle(context),
              textStyle: defaultTextStyle(context),
            ),
            if (statusCode != null) const SizedBox(height: 10),
            if (statusCode != null)
              IconLabelText(
                icon: Icon(
                  _getErrorIconData(apiError?.errorType),
                  size: defaultIconSize,
                  color: apiError != null //
                      ? apiLogData.hasError
                          ? Colors.red
                          : Colors.blue
                      : Colors.blue,
                ),
                label: 'Response Status: ',
                text: statusCode.toString(),
                labelStyle: defaultLabelStyle(context),
                textStyle: defaultTextStyle(context),
              ),
            //
            if (statusMessage != null && statusMessage.isNotEmpty)
              const SizedBox(height: 10),
            if (statusMessage != null && statusMessage.isNotEmpty)
              IconLabelText(
                icon: const Icon(
                  Icons.text_snippet_outlined,
                  size: defaultIconSize,
                ),
                label: 'Response Status Message: ',
                text: statusMessage,
                labelStyle: defaultLabelStyle(context),
                textStyle: defaultTextStyle(context),
              ),
            //
            if (apiError != null) const SizedBox(height: 10),
            if (apiError != null)
              IconLabelText(
                icon: Icon(
                  _getErrorIconData(apiError.errorType),
                  color: Colors.red,
                  size: defaultIconSize,
                ),
                label: 'Error Type: ',
                text: apiError.errorType?.description ?? ' - ',
                labelStyle: defaultLabelStyle(context),
                textStyle: defaultTextStyle(context),
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
                  size: defaultIconSize,
                ),
                label: 'Error Message: ',
                text: apiError.errorMessage,
                labelStyle: defaultLabelStyle(context),
                textStyle: defaultTextStyle(context),
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
            if (apiLogData.responseLogData != null &&
                apiLogData.responseLogData!.responseHeaders.isNotEmpty)
              const SizedBox(height: 10),
            if (apiLogData.responseLogData != null &&
                apiLogData.responseLogData!.responseHeaders.isNotEmpty)
              IconLabelText(
                icon: const Icon(Icons.topic, size: defaultIconSize),
                label: 'Headers: ',
                text: '',
                labelStyle: defaultLabelStyle(context),
                textStyle: defaultTextStyle(context),
              ),
            if (apiLogData.responseLogData != null &&
                apiLogData.responseLogData!.responseHeaders.isNotEmpty)
              const SizedBox(height: 10),
            if (apiLogData.responseLogData != null &&
                apiLogData.responseLogData!.responseHeaders.isNotEmpty)
              _MapKeyValueView(
                map: apiLogData.responseLogData!.responseHeaders,
              ),
          ],
        ),
      ),
    );
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    _closeAllSnackBars(context);
    _showSnackBar(
      context,
      "Copied",
    );
  }

  void _errorDetector(BuildContext context, ApiError apiError) {
    FaJsonConverter? converter = apiError.usedConverter;
    if (converter == null) {
      print(">> No Converter");
      return;
    }
    Object realJsonOBJ =
        apiLogData.getRealJsonObjOrArray() ?? <String, dynamic>{};
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
