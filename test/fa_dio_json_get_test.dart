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

    artistDio = FlutterArtistDio(
      dio: dio,
      pageMapping: const PageMapping(
        itemsKey: 'items',
        paginationKey: 'pagination',
        paginationDetailKeys: PaginationDetailKeys(
          currentPage: 'currentPage',
          pageSize: 'pageSize',
          totalItems: 'totalItems',
          totalPages: 'totalPages',
        ),
      ),
    );
  });

  group('FlutterArtistDio - HTTP GET Semantic Layout Parsing Tests', () {
    test(
        'jsonGet() maps a flat object payload directly to a single model instance',
        () async {
      const path = '/api/v1/currencies/USD';
      final mockPayload = {
        'id': 'USD',
        'symbol': '\$',
        'name': 'US Dollar',
      };

      dioAdapter.onGet(path, (server) => server.reply(200, mockPayload));

      final result = await artistDio.jsonGet<SampleCurrencyData>(
        path,
        jsonConverter: SampleCurrencyData.fromJson ,
      );

      expect(result.isError(), false);
      expect(result.data, isNotNull);
      expect(result.data!.id, 'USD');
      expect(result.data!.symbol, '\$');
      expect(result.data!.name, 'US Dollar');
    });

    test(
        'jsonGetList() intercepts itemsKey and unpacks elements into a unified ListData wrapper',
        () async {
      const path = '/api/v1/currencies/list';
      final mockPayload = {
        'items': [
          {'id': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
          {'id': 'EUR', 'symbol': '€', 'name': 'Euro'},
        ]
      };

      dioAdapter.onGet(path, (server) => server.reply(200, mockPayload));

      final result = await artistDio.jsonGetList<SampleCurrencyData>(
        path,
        itemConverter:FaItemConverters.fromJsonConverter(  SampleCurrencyData.fromJson ),
      );

      expect(result.isError(), false);
      expect(result.data, isA<ListData<SampleCurrencyData>>());
      expect(result.data!.items.length, 2);
      expect(result.data!.items[0].id, 'USD');
      expect(result.data!.items[1].id, 'EUR');
    });

    test(
        'jsonGetPage() successfully evaluates PageMapping setups to extract PageData items and PaginationInfo blocks',
        () async {
      const path = '/api/v1/currencies/page';
      final mockPayload = {
        'pagination': {
          'currentPage': 1,
          'pageSize': 20,
          'totalItems': 2,
          'totalPages': 1,
        },
        'items': [
          {'id': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
          {'id': 'EUR', 'symbol': '€', 'name': 'Euro'},
        ]
      };

      dioAdapter.onGet(path, (server) => server.reply(200, mockPayload));

      final result = await artistDio.jsonGetPage<SampleCurrencyData>(
        path,
        itemConverter: FaItemConverters.fromJsonConverter( SampleCurrencyData.fromJson ),
      );

      expect(result.isError(), false);
      expect(result.data, isA<PageData<SampleCurrencyData>>());

      // Verify items extraction
      expect(result.data!.items.length, 2);
      expect(result.data!.items.first.id, 'USD');

      // Verify metadata tokens resolution
      final meta = result.data!.paginationInfo;
      expect(meta, isNotNull);
      expect(meta!.currentPage, 1);
      expect(meta.pageSize, 20);
      expect(meta.totalItems, 2);
      expect(meta.totalPages, 1);
    });

    test(
        'jsonGetPage() defaults metadata metrics safely when pagination envelope block is completely missing',
        () async {
      const path = '/api/v1/currencies/missing-meta-page';
      final mockPayloadWithNoMeta = {
        // Missing 'pagination' block key entirely on purpose
        'items': [
          {'id': 'VND', 'symbol': '₫', 'name': 'Vietnam Dong'}
        ]
      };

      dioAdapter.onGet(
          path, (server) => server.reply(200, mockPayloadWithNoMeta));

      final result = await artistDio.jsonGetPage<SampleCurrencyData>(
        path,
        itemConverter:FaItemConverters.fromJsonConverter(  SampleCurrencyData.fromJson ),
      );

      expect(result.isError(), false);
      expect(result.data!.items.length, 1);

      // Verification rules forcing non-nullable safe metadata fallback checks
      final meta = result.data!.paginationInfo;
      expect(meta, isNull);
    });
  });
}
