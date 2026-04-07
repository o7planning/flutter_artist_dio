part of '../../rest_debug_screen.dart';

void _showSnackBar(BuildContext context, String value) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
}

// TODO: Hide all.
void _closeAllSnackBars(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

IconData _getErrorIconData(ApiErrorType? apiErrorType) {
  if (apiErrorType == null) {
    return Icons.check_box_rounded;
  }
  switch (apiErrorType) {
    case ApiErrorType.connectionTimeout:
    case ApiErrorType.sendTimeout:
    case ApiErrorType.receiveTimeout:
    case ApiErrorType.badCertificate:
    case ApiErrorType.badResponse:
    case ApiErrorType.cancel:
    case ApiErrorType.connectionError:
      return Icons.warning;
    case ApiErrorType.unknown:
    case ApiErrorType.invalidJson:
    case ApiErrorType.notJson:
    case ApiErrorType.conversion:
      return Icons.warning_amber;
  }
}
