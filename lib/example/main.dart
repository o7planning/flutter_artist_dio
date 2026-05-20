import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/flutter_artist_dio.dart';

/// 1. Define a minimal explicit data model for the example ecosystem.
class SampleCurrencyData {
  final String id;
  final String symbol;
  final String name;

  SampleCurrencyData({
    required this.id,
    required this.symbol,
    required this.name,
  });

  /// Factory factory mapper mapping direct JSON keys to object parameters.
  factory SampleCurrencyData.fromJson(Map<String, dynamic> json) {
    return SampleCurrencyData(
      id: json['id'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FlutterArtist Dio Example',
      home: Scaffold(
        body: Center(
          child: CurrencyDemoWidget(),
        ),
      ),
    );
  }
}

class CurrencyDemoWidget extends StatefulWidget {
  const CurrencyDemoWidget({super.key});

  @override
  State<CurrencyDemoWidget> createState() => _CurrencyDemoWidgetState();
}

class _CurrencyDemoWidgetState extends State<CurrencyDemoWidget> {
  // Initialize standard Dio client with public mock endpoints
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://o7planning.github.io"));

  late final FlutterArtistDio _artistDio;
  String _apiResultText = "Press fetch button to initiate pipeline telemetry.";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Instantiate the primary wrapper layer cleanly without complex interceptors
    _artistDio = FlutterArtistDio(dio: _dio);
  }

  Future<void> _fetchCurrencyData() async {
    setState(() {
      _isLoading = true;
      _apiResultText = "Executing network layout query...";
    });

    // Execute the clean unified request pipeline directly
    final ApiResult<SampleCurrencyData> result = await _artistDio.jsonGet(
      "/demo/flutter_artist_dio_demo/json/USD.json",
      converter: SampleCurrencyData.fromJson,
    );

    setState(() {
      _isLoading = false;
    });

    // Handle results safely using the functional parameter design patterns
    if (result.isError()) {
      setState(() {
        _apiResultText = "Error captured via ErrorInfoExtractor:\n"
            "Message: ${result.error?.errorMessage}\n"
            "Status Code: ${result.error?.statusCode}";
      });
    } else {
      final data = result.data;
      setState(() {
        _apiResultText = "Network Result Succeeded!\n"
            "ID: ${data?.id}\n"
            "Name: ${data?.name}\n"
            "Symbol: ${data?.symbol}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_sync_rounded, size: 48, color: Colors.deepPurple),
          const SizedBox(height: 16),
          Text(
            'FlutterArtistDio Integration Check',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _apiResultText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _fetchCurrencyData,
            icon: const Icon(Icons.download_rounded),
            label: const Text('Execute jsonGet()'),
          ),
        ],
      ),
    );
  }
}