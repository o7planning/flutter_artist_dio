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
    //  RETURN TO STANDARD: Keep the default strict validateStatus configurations
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    dioAdapter = DioAdapter(dio: dio);

    artistDio = FlutterArtistDio(
      dio: dio,
      pageMapping: const PageMapping(),
      errorInfoExtractor: const FlexibleErrorInfoExtractor(),
    );
  });

  group(
      'FlutterArtistDio - FlexibleErrorInfoExtractor & Defensive Robustness Tests',
      () {
    test(
        'FlexibleErrorInfoExtractor parses Error Type 1 (Root level message with primitive List<String> details)',
        () async {
      const path = '/api/v1/errors/type1-flat';
      final mockErrorPayload = {
        'status': 400,
        'errorMessage': 'Validation failed for asset request pipeline.',
        'errorDetails': [
          "Parameter 'currencyId' must be a valid 3-letter ISO code",
          "Field 'symbol' cannot contain numeric characters"
        ]
      };

      //  FIX: Use .throws() to realistically emulate a real server bad response exception
      dioAdapter.onGet(
        path,
        (server) => server.throws(
          400,
          DioException(
            requestOptions: RequestOptions(path: path),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: path),
              data: mockErrorPayload,
            ),
          ),
        ),
      );

      final result = await artistDio.jsonGet<Map>(path, converter: null);

      expect(result.isError(), true);
      expect(result.error?.statusCode, 400);
      expect(result.error?.errorMessage,
          'Validation failed for asset request pipeline.');
      expect(result.error?.errorDetails?.length, 2);
      expect(result.error?.errorDetails![0],
          "Parameter 'currencyId' must be a valid 3-letter ISO code");
    });

    test(
        'FlexibleErrorInfoExtractor parses Error Type 2 (Deep-nested envelope object with dynamic object detail arrays)',
        () async {
      const path = '/api/v1/errors/type2-nested';
      final mockErrorPayload = {
        'status': 422,
        'error': {
          'msg': 'Unprocessable structural entity encountered.',
          'code': 'ERR_VALIDATION_01'
        },
        'details': [
          {
            'field': 'symbol',
            'message': 'Currency token marker symbol is required.'
          },
          {
            'property': 'name',
            'description': 'Name length must be between 2 and 50 characters.'
          }
        ]
      };

      //  FIX: Emulate 422 Unprocessable Entity Exception via .throws()
      dioAdapter.onGet(
        path,
        (server) => server.throws(
          422,
          DioException(
            requestOptions: RequestOptions(path: path),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 422,
              requestOptions: RequestOptions(path: path),
              data: mockErrorPayload,
            ),
          ),
        ),
      );

      final result = await artistDio.jsonGet<Map>(path, converter: null);

      expect(result.isError(), true);
      expect(result.error?.statusCode, 422);
      expect(result.error?.errorMessage,
          'Unprocessable structural entity encountered.');
      expect(result.error?.errorDetails?.length, 2);
      expect(result.error?.errorDetails![0],
          'symbol: Currency token marker symbol is required.');
      expect(result.error?.errorDetails![1],
          'name: Name length must be between 2 and 50 characters.');
    });

    test(
        'FlexibleErrorInfoExtractor parses Error Type 3 (Map Summary validation block using _stringifyMapEntry pipeline loops)',
        () async {
      const path = '/api/v1/errors/type3-map-entry';
      final mockErrorPayload = {
        'status': 400,
        'title': 'One or more validation errors occurred.',
        'errors': {
          'currencyId': [
            'The currencyId field is required.',
            'The currencyId must be uppercase.'
          ],
          'symbol': ['The symbol must be exactly 1 character long.']
        }
      };

      //  FIX: Emulate 400 Validation Error Map Exception via .throws()
      dioAdapter.onGet(
        path,
        (server) => server.throws(
          400,
          DioException(
            requestOptions: RequestOptions(path: path),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: path),
              data: mockErrorPayload,
            ),
          ),
        ),
      );

      final result = await artistDio.jsonGet<Map>(path, converter: null);

      expect(result.isError(), true);
      expect(result.error?.errorMessage,
          'One or more validation errors occurred.');
      expect(result.error?.errorDetails?.length, 2);
      expect(
          result.error?.errorDetails,
          contains(
              'currencyId: The currencyId field is required., The currencyId must be uppercase.'));
      expect(result.error?.errorDetails,
          contains('symbol: The symbol must be exactly 1 character long.'));
    });

    test(
        'Defensively catches structural compliance crashes, forcing ApiErrorType.conversion failures if model converters hit a null entity output loop',
        () async {
      const path = '/api/v1/currencies/malformed-item';
      final mockPayload = {
        'items': [
          {
            'invalid_schema_keys':
                'causes converter factory to return null value'
          }
        ]
      };

      // This targets a successful 200 response but with corrupt body format data
      dioAdapter.onGet(path, (server) => server.reply(200, mockPayload));

      final result = await artistDio.jsonGetList<Map>(
        path,
        itemConverter: (rawJson) => null,
      );

      expect(result.isError(), true);
      expect(result.error?.errorType, ApiErrorType.conversion);
      expect(result.error?.errorMessage,
          contains('Item conversion returned null.'));
    });

    test(
        'FlexibleErrorInfoExtractor handles non-JSON raw HTML/Text error gracefully without crashing',
        () async {
      const path = '/api/v1/errors/html-crash';
      const rawHtmlResponse =
          "<html><body>502 Bad Gateway Proxy Server Error</body></html>";

      dioAdapter.onGet(
        path,
        (server) => server.throws(
          502,
          DioException(
            requestOptions: RequestOptions(path: path),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 502,
              requestOptions: RequestOptions(path: path),
              data: rawHtmlResponse, // Raw HTML string stringifier boundary
            ),
          ),
        ),
      );

      final result = await artistDio.jsonGet<Map>(path, converter: null);

      expect(result.isError(), true);
      expect(result.error?.statusCode, 502);
      // Tầng xử lý lỗi phải tự động gán chuỗi thô này vào làm errorMessage hoặc originErrorText
      expect(result.error?.errorMessage, contains('502 Bad Gateway'));
    });

    test(
        '__handleResponseAsDirectData intercepts empty plain string safely and routes to business errors instead of crashing',
        () async {
      const path = '/api/v1/success/empty-string-trap';

      // Server returns HTTP 200 but payload is completely empty string
      dioAdapter.onGet(path, (server) => server.reply(200, "   "));

      final result = await artistDio.jsonGet<SampleCurrencyData>(
        path,
        converter: SampleCurrencyData.fromJson,
      );

      // It should successfully catch the anomaly and report as conversion or null error rather than crashing the thread
      expect(result.data, isNull);
    });
  });
}
