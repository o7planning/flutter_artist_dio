part of '../../../flutter_artist_dio.dart';

PageData<ITEM> _convertToPageData<ITEM>({
  required PageMapping pageMapping,
  required Converter<ITEM> converter,
  required Map<String, dynamic> rawJson,
}) {
  PaginationInfo? paginationInfo;
  final pKey = pageMapping.paginationKey;

  if (rawJson.containsKey(pKey) && rawJson[pKey] is Map<String, dynamic>) {
    final paginationJson = rawJson[pKey] as Map<String, dynamic>;
    final dKeys = pageMapping.paginationDetailKeys;
    try {
      paginationInfo = PaginationInfo(
        currentPage: (paginationJson[dKeys.currentPage] as num?)?.toInt() ?? 0,
        pageSize: (paginationJson[dKeys.pageSize] as num?)?.toInt() ?? 0,
        totalItems: (paginationJson[dKeys.totalItems] as num?)?.toInt() ?? 0,
        totalPages: (paginationJson[dKeys.totalPages] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      throw ApiError(
        errorType: ApiErrorType.conversion,
        errorMessage: "Pagination conversion error: $e",
      );
    }
  }

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
  return PageData<ITEM>(
    paginationInfo: paginationInfo,
    items: parsedItems,
  );
}
