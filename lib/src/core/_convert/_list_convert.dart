part of '../../../flutter_artist_dio.dart';

ListData<ITEM> _convertToListData<ITEM>({
  required PageMapping pageMapping,
  required FaDataConverter<ITEM> converter,
  required dynamic data,
}) {
  if (data is! Map<String, dynamic>) {
    throw ApiError(
      errorType: ApiErrorType.invalidJson,
      errorMessage: "Invalid JSON payload structure for ListData mapping.",
    );
  }

  final List<ITEM> parsedItems = [];
  final iKey = pageMapping.itemsKey;

  if (data.containsKey(iKey) && data[iKey] is List) {
    final rawList = data[iKey] as List;
    for (final rawItem in rawList) {
      try {
        final ITEM? item = converter(rawItem);
        if (item == null) {
          throw ApiError(
            errorType: ApiErrorType.conversion,
            errorMessage:
                "Item conversion returned null. Structural integrity violation for type: $ITEM.",
          );
        }
        parsedItems.add(item);
      } catch (e) {
        // Intercept any serialization mapping failure and pipe safely into the ecosystem error
        throw ApiError(
          errorType: ApiErrorType.conversion,
          errorMessage: "Item conversion error inside ListData pipeline: $e",
        );
      }
    }
  }

  return ListData<ITEM>(
    items: parsedItems,
  );
}
