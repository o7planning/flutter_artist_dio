import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FaJsonConverters - Nullable Envelope Extraction Suite', () {
    final Map<String, dynamic> mockRootPayload = {
      'statusMessage': 'Ecosystem Operational',
      'statusCode': 200,
      'ratioMetrics': 0.85,
      'flagState': 1,
      'completedTimestamp': '2026-06-25T14:30:00Z',
      'emptyField': null,
    };

    test(
        'toStringConverter pulls valid root keys or processes optional fallbacks seamlessly',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<String?> optionalConverter =
          FaJsonConverters.toStringConverter(jsonKey: 'emptyField');
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<String?> strictConverter =
          FaJsonConverters.toStringConverter(
              jsonKey: 'emptyField', isOptional: false);
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<String?> validConverter =
          FaJsonConverters.toStringConverter(jsonKey: 'statusMessage');

      expect(validConverter(mockRootPayload), 'Ecosystem Operational');
      expect(optionalConverter(mockRootPayload),
          isNull); // isOptional = true default fallback execution

      expect(
        () => strictConverter(mockRootPayload),
        throwsA(isA<ApiError>()
            .having((e) => e.errorType, 'errorType', ApiErrorType.conversion)),
      );
    });

    test(
        'toIntConverter parses numeric metrics and handles optional parameters accurately',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<int?> validConverter =
          FaJsonConverters.toIntConverter(jsonKey: 'statusCode');
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<int?> optionalConverter =
          FaJsonConverters.toIntConverter(jsonKey: 'emptyField');

      expect(validConverter(mockRootPayload), 200);
      expect(optionalConverter(mockRootPayload), isNull);
    });

    test('toDoubleConverter transforms flat float attributes cleanly', () {
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<double?> validConverter =
          FaJsonConverters.toDoubleConverter(jsonKey: 'ratioMetrics');
      expect(validConverter(mockRootPayload), 0.85);
    });

    test('toBoolConverter decodes custom root object flags smoothly', () {
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<bool?> validConverter =
          FaJsonConverters.toBoolConverter(jsonKey: 'flagState');
      expect(validConverter(mockRootPayload), true);
    });

    test(
        'toDateTimeConverter and toDateConverter extract root timeline anchors or gracefully return null',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<DateTime?> validDateTime =
          FaJsonConverters.toDateTimeConverter(jsonKey: 'completedTimestamp');
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<DateTime?> optionalDate =
          FaJsonConverters.toDateConverter(jsonKey: 'emptyField');

      final expectedDateTime = DateTime.parse('2026-06-25T14:30:00Z');
      expect(validDateTime(mockRootPayload), expectedDateTime);
      expect(optionalDate(mockRootPayload), isNull);
    });

    test(
        'fromJsonConverter passes standard serialization models through dynamic verification shields',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaJsonConverter<String> mockModelMapper =
          (map) => map['statusMessage'] as String;

      // ignore: prefer_function_declarations_over_variables
      final FaItemConverter<String?> integratedConverter =
          FaItemConverters.fromJsonConverter(mockModelMapper);

      expect(integratedConverter(mockRootPayload), 'Ecosystem Operational');
      expect(
          integratedConverter(null), isNull); // Safe optional boundary fallback

      expect(
        () => integratedConverter('MalformedStringPayload'),
        throwsA(isA<ApiError>()
            .having((e) => e.errorType, 'errorType', ApiErrorType.invalidJson)),
      );
    });
  });
}
