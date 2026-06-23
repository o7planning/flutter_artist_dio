part of '../../../flutter_artist_dio.dart';

ListData<ITEM> _convertToListData<ITEM>({
  required PageMapping pageMapping,
  required Converter<ITEM> converter,
  required Map<String, dynamic> rawJson,
}) {
  final List<ITEM> parsedItems = [];
  final iKey = pageMapping.itemsKey;

  if (rawJson.containsKey(iKey) && rawJson[iKey] is List) {
    final rawList = rawJson[iKey] as List;
    for (final rawItem in rawList) {
      rawItem as Map<String, dynamic>;
      final ITEM? item = converter(rawItem);
      if (item == null) {
        throw ApiError(
          errorType: ApiErrorType.conversion,
          errorMessage:
              "Item conversion returned null. Structural integrity violation for type: $ITEM.",
        );
      }
      parsedItems.add(item);
    }
  }

  return ListData<ITEM>(
    items: parsedItems,
  );
}
