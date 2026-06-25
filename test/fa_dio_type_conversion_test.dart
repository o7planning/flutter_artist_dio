import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/flutter_artist_dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '_model.dart';

void main() {
  FlutterArtistDio.printOriginDioStackTrace = false;

  group('ApiResult Container Structural Macro Conversion Tests', () {
    test(
        'ApiResult.createPageDataResult() maps clean ListData objects over to complete PageData containers without slicing element logs',
        () async {
      final itemsList = [
        SampleCurrencyData(id: 'USD', symbol: '\$', name: 'US Dollar'),
        SampleCurrencyData(id: 'EUR', symbol: '€', name: 'Euro'),
      ];

      final ApiResult<ListData<SampleCurrencyData>> sourceListResult =
          ApiResult.success(
        statusCode: 200,
        statusMessage: 'OK',
        data: ListData(items: itemsList),
      );

      // Execute container transformation macro pipeline
      final ApiResult<PageData<SampleCurrencyData>> pageResult =
          ApiResult.createPageDataResultFromListDataResult(sourceListResult);

      expect(pageResult.isError(), false);
      expect(pageResult.statusCode, 200);
      expect(pageResult.data, isNotNull);
      expect(pageResult.data!.items.length,
          2); // Sửa lỗi cũ: đảm bảo không cắt ngắn phần tử
      expect(pageResult.data!.items[0].id, 'USD');
      expect(pageResult.data!.items[1].id, 'EUR');

      // Auto calculated layout configuration inspection
      final meta = pageResult.data!.paginationInfo;
      expect(meta?.currentPage, 1);
      expect(meta?.totalItems, 2);
      expect(meta?.pageSize, 2);
    });

    test(
        'Conversion utility macro cleanly flattens PageData models and ensures active ApiError descriptors pass downstream without structural data drops',
        () async {
      final inputError = ApiError(
        statusCode: 500,
        statusMessage: 'Internal Server Error',
        errorType: ApiErrorType.unknown,
        errorMessage: 'Database connection went down temporarily.',
      );

      final ApiResult<PageData<SampleCurrencyData>> failedPageResult =
          ApiResult.fromError(inputError);

      // Trigger flattening transformation sequence across error states
      final ApiResult<ListData<SampleCurrencyData>> listResult =
          ApiResult.createListDataResultFromPageDataResult(failedPageResult);

      expect(listResult.isError(), true);
      //  Should yield null data bound to container specs
      expect(listResult.data, isNull);
      expect(listResult.error, isNotNull);
      expect(listResult.error!.statusCode, 500);
      expect(listResult.error!.errorMessage,
          'Database connection went down temporarily.');
      expect(listResult.error!.errorType, ApiErrorType.unknown);
    });
  });
}
