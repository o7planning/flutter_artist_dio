import 'package:dio/dio.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/flutter_artist_dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  FlutterArtistDio.printOriginDioStackTrace = false;

  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    // 1. Clear previous buffered historical memory segments before each evaluation loop
    ApiLogger.instance.clearLogs();

    dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    dioAdapter = DioAdapter(dio: dio);

    //  REPLICATING THE api_client.dart PRODUCTION LAYOUT RULE:
    // Inject the telemetry recorder interceptor onto the absolute first rank of the execution pipe.
    final loggerInterceptor = FlutterArtistDioLoggerInterceptor();
    dio.interceptors.add(loggerInterceptor);
  });

  group('FlutterArtistDioLoggerInterceptor - Automated Telemetry Ledger Tests',
      () {
    test(
        'Successful network transactions must accurately populate dynamic metrics inside the ApiLogger buffer pool',
        () async {
      const path = '/api/v1/telemetry/success-endpoint';
      final mockResponseData = {
        'status': 'active',
        'scope': 'framework_testing'
      };

      // Setup network routing mapping rules
      dioAdapter.onGet(
        path,
        (server) => server.reply(200, mockResponseData),
        queryParameters: {'v': '1.0.0'},
      );

      // Verify initial buffer footprint state is clean
      expect(ApiLogger.instance.requestCount, 0);

      // Execute standard network pipeline via standard Dio mixins
      await dio.get(path, queryParameters: {'v': '1.0.0'});

      // Assertions verifying data packets successfully bypassed filter boundaries
      expect(ApiLogger.instance.requestCount, 1);

      final ApiLogData? loggedNode = ApiLogger.instance.getLastApiLogData();
      expect(loggedNode, isNotNull);
      expect(loggedNode!.hasError, false);
      expect(loggedNode.requestLogData.method, 'GET');
      expect(loggedNode.requestLogData.uri.toString(),
          'https://api.example.com/api/v1/telemetry/success-endpoint?v=1.0.0');

      // Verify response body evaluation mechanics match target payload structures
      expect(loggedNode.responseLogData, isNotNull);
      expect(loggedNode.responseLogData!.statusCode, 200);

      final Map<String, dynamic>? cachedJson =
          loggedNode.getRealJsonObjOrArray() as Map<String, dynamic>?;
      expect(cachedJson, isNotNull);
      expect(cachedJson!['status'], 'active');
      expect(cachedJson['scope'], 'framework_testing');
    });

    test(
        'Aborted network transactions must securely isolate transport failures and populate ErrorLogData properties inside the ledger',
        () async {
      const path = '/api/v1/telemetry/failure-endpoint';
      final mockErrorData = {
        'errorMessage': 'Resource lookup token un-allocated'
      };

      //  FIX: Instead of .throws(), use .reply() with a 404 error status code.
      // This allows Dio to naturally construct the DioException while preserving
      // the original RequestOptions chain containing our internal telemetry tracking keys.
      dioAdapter.onPost(
        path,
        (server) => server.reply(404, mockErrorData),
      );

      // Execute network action wrapping to capture expected exceptions safely
      try {
        await dio.post(path);
      } catch (_) {
        // Suppress expected exceptions to flow code down into assertion blocks cleanly
      }

      // Assertions verifying failure tracking pipelines populated tracking states
      expect(ApiLogger.instance.requestCount, 1);

      final ApiLogData? loggedNode = ApiLogger.instance.getLastApiLogData();
      expect(loggedNode, isNotNull);
      expect(loggedNode!.hasError, true); // Will now be TRUE successfully!
      expect(loggedNode.requestLogData.method, 'POST');

      // Verify error metadata blocks match captured low-level exception metrics
      expect(loggedNode.errorLogData, isNotNull);
      expect(loggedNode.errorLogData!.statusCode, 404);
      expect(loggedNode.errorLogData!.apiErrorType, ApiErrorType.badResponse);

      final Map<String, dynamic>? parsedErrorJson =
          loggedNode.getRealJsonObjOrArray() as Map<String, dynamic>?;
      expect(parsedErrorJson, isNotNull);
      expect(parsedErrorJson!['errorMessage'],
          'Resource lookup token un-allocated');
    });

    test(
        'ApiLogger buffer memory pool must strictly enforce maximum capacity ceilings and prune oldest packet history logs',
        () async {
      const path = '/api/v1/telemetry/flood-test';

      dioAdapter.onGet(
        path,
        (server) => server.reply(200, {'status': 'flood_ok'}),
      );

      // Flood the engine by triggering 52 sequential connection sequences
      for (int i = 0; i < 52; i++) {
        await dio.get(path);
      }

      // Assertions verifying that the buffer ceiling permanently caps log sizes
      expect(ApiLogger.instance.requestCount,
          ApiLogger.instance.maxLogEntryCount); // Phải bằng đúng 50
    });
  });
}
