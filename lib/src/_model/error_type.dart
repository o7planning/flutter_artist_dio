part of '../../flutter_artist_dio.dart';

@Deprecated("Thay boi ApiErrorType.")
enum ErrorType {
  none,
  noResponse,
  apiError,
  parseError,
}

class ConvertError {
  dynamic error;
  StackTrace stackTrace;

  ConvertError({required this.error, required this.stackTrace});
}
