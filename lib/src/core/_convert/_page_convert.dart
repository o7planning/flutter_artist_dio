part of '../../../flutter_artist_dio.dart';

PageData<ITEM> _convertToPageData<ITEM>({
  required PageMapping pageMapping,
  required FaDataConverter<ITEM> converter,
  required dynamic data,
}) {
  if (data is! Map<String, dynamic>) {
    throw ApiError(
        errorType: ApiErrorType.invalidJson,
        errorMessage: "Invalid JSON payload structure for PageData mapping.");
  }

  PaginationInfo? paginationInfo;
  final pKey = pageMapping.paginationKey;

  if (data.containsKey(pKey) && data[pKey] is Map<String, dynamic>) {
    final paginationJson = data[pKey] as Map<String, dynamic>;
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
        throw ApiError(
          errorType: ApiErrorType.conversion,
          errorMessage: "Item conversion error inside PageData pipeline: $e",
        );
      }
    }
  }

  return PageData<ITEM>(
    paginationInfo: paginationInfo,
    items: parsedItems,
  );
}
