part of '../../rest_debug_screen.dart';

void _showSnackBar(BuildContext context, String value) {
  ScaffoldMessenger.of(context)
      .showSnackBar(new SnackBar(content: new Text(value)));
}

// TODO: Hide all.
void _closeAllSnackBars(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

IconData _getErrorIconData(ApiError apiError) {
  ApiErrorType? apiErrorType = apiError.errorType;
  if (apiErrorType == null) {
    return Icons.warning_amber;
  }
  switch (apiErrorType) {
    case ApiErrorType.connectionTimeout:
    case ApiErrorType.sendTimeout:
    case ApiErrorType.receiveTimeout:
    case ApiErrorType.badCertificate:
    case ApiErrorType.badResponse:
    case ApiErrorType.cancel:
    case ApiErrorType.connectionError:
      return Icons.error;
    case ApiErrorType.unknown:
    case ApiErrorType.invalidJson:
    case ApiErrorType.notJson:
    case ApiErrorType.conversion:
      return Icons.warning;
  }
}
