import 'package:dio/dio.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/flutter_artist_dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '_model.dart';

void main() {
  FlutterArtistDio.printOriginDioStackTrace = false;

  late Dio dio;
  late DioAdapter dioAdapter;
  late FlutterArtistDio artistDio;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    dioAdapter = DioAdapter(dio: dio);
    artistDio = FlutterArtistDio(dio: dio, pageMapping: const PageMapping());
  });

  group('FlutterArtistDio - HTTP POST / PUT State Mutation Pipeline Tests', () {
    test(
        'jsonPost() attaches request body parameters accurately and catches mutations mapping back to singular objects',
        () async {
      const path = '/api/v1/currencies/create';
      final requestBody = {'id': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'};

      dioAdapter.onPost(
        path,
        (server) => server.reply(201, requestBody),
        data: requestBody,
      );

      final result = await artistDio.jsonPost<SampleCurrencyData>(
        path,
        data: requestBody,
        converter: SampleCurrencyData.fromJson.toDataConverter(),
      );

      expect(result.isError(), false);
      expect(result.data!.id, 'JPY');
      expect(result.data!.name, 'Japanese Yen');
    });

    test(
        'jsonPostPage() performs robust multi-format searches via POST methods and maps outputs to standard PageData arrays',
        () async {
      const path = '/api/v1/currencies/advanced-search';
      final searchFilter = {'searchText': 'Dollar'};

      final mockPaginatedPayload = {
        'pagination': {
          'currentPage': 1,
          'pageSize': 10,
          'totalItems': 1,
          'totalPages': 1
        },
        'items': [
          {'id': 'USD', 'symbol': '\$', 'name': 'US Dollar'}
        ]
      };

      dioAdapter.onPost(
        path,
        (server) => server.reply(200, mockPaginatedPayload),
        data: searchFilter,
      );

      final result = await artistDio.jsonPostPage<SampleCurrencyData>(
        path,
        data: searchFilter,
        converter: SampleCurrencyData.fromJson.toDataConverter(),
      );

      expect(result.isError(), false);
      expect(result.data!.items.length, 1);
      expect(result.data!.items.first.id, 'USD');
      expect(result.data!.paginationInfo?.totalItems, 1);
    });

    test(
        'jsonPutList() runs systemic updates across collection nodes and fetches data streams straight into ListData blocks',
        () async {
      const path = '/api/v1/currencies/bulk-update';
      final payloadData = [
        {'id': 'USD', 'symbol': '\$', 'name': 'US Dollar updated'}
      ];

      dioAdapter.onPut(
        path,
        (server) => server.reply(200, {'items': payloadData}),
      );

      final result = await artistDio.jsonPutList<SampleCurrencyData>(
        path,
        converter: SampleCurrencyData.fromJson.toDataConverter(),
      );

      expect(result.isError(), false);
      expect(result.data!.items.first.name, 'US Dollar updated');
    });
  });
}
