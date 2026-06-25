import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FaDataConverters - Strict Primitives Element Isolation Suite', () {
    test(
        'toStringConverter maps valid raw items directly onto strict strings and rejects null boundaries',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaDataConverter<String> converter =
          FaDataConverters.toStringConverter;

      expect(converter('FlutterArtist'), 'FlutterArtist');
      expect(converter(100.85), '100.85');
      expect(converter(true), 'true');

      // Systemic verification enforcing strict non-nullable behavior
      expect(
        () => converter(null),
        throwsA(isA<ApiError>()
            .having((e) => e.errorType, 'errorType', ApiErrorType.conversion)),
      );
    });

    test(
        'toIntConverter parses numeric bounds and handles truncation logic accurately',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaDataConverter<int> converter = FaDataConverters.toIntConverter;

      expect(converter(500), 500);
      expect(converter(45.67), 45); // Truncation decimal boundary verification
      expect(converter('2026'), 2026);
      expect(converter('100.85'), 100);

      expect(
        () => converter(null),
        throwsA(isA<ApiError>()
            .having((e) => e.errorType, 'errorType', ApiErrorType.conversion)),
      );
      expect(
        () => converter('MalformedText'),
        throwsA(isA<ApiError>()
            .having((e) => e.errorType, 'errorType', ApiErrorType.conversion)),
      );
    });

    test(
        'toDoubleConverter resolves real float matrix metrics or numeric plain strings safely',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaDataConverter<double> converter =
          FaDataConverters.toDoubleConverter;

      expect(converter(3.14159), 3.14159);
      expect(converter(200), 200.0);
      expect(converter('0.85'), 0.85);

      expect(
        () => converter(null),
        throwsA(isA<ApiError>()
            .having((e) => e.errorType, 'errorType', ApiErrorType.conversion)),
      );
    });

    test('toBoolConverter decodes versatile representation flags correctly',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaDataConverter<bool> converter = FaDataConverters.toBoolConverter;

      expect(converter(true), true);
      expect(converter(false), false);
      expect(converter(1), true);
      expect(converter(0), false);
      expect(converter('true'), true);
      expect(converter('FALSE'), false);
      expect(converter('1'), true);

      expect(
        () => converter(null),
        throwsA(isA<ApiError>()
            .having((e) => e.errorType, 'errorType', ApiErrorType.conversion)),
      );
    });

    test(
        'toDateTimeConverter and toDateConverter resolve absolute timelines or patterns accurately',
        () {
      // ignore: prefer_function_declarations_over_variables
      final FaDataConverter<DateTime> dateTimeConverter =
          FaDataConverters.toDateTimeConverter();
      // ignore: prefer_function_declarations_over_variables
      final FaDataConverter<DateTime> dateOnlyConverter =
          FaDataConverters.toDateConverter(pattern: 'yyyy-MM-dd');

      // Epoch Milliseconds validation pipeline
      final expectedTime = DateTime.fromMillisecondsSinceEpoch(1782397800000);
      expect(dateTimeConverter(1782397800000), expectedTime);

      // Custom pattern formatting layout check via intl package signatures
      final customPattern =
          FaDataConverters.toDateTimeConverter(pattern: 'dd/MM/yyyy HH:mm:ss');
      expect(customPattern('25/06/2026 14:30:00'),
          DateTime(2026, 6, 25, 14, 30, 0));

      // Date normalization test forcing time components down to midnight boundary
      final dateSample = dateOnlyConverter('2026-06-25');
      expect(dateSample!.hour, 0);
      expect(dateSample.minute, 0);

      expect(
        () => dateTimeConverter(null),
        throwsA(isA<ApiError>()
            .having((e) => e.errorType, 'errorType', ApiErrorType.conversion)),
      );
    });
  });
}
