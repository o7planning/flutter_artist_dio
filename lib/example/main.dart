import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// Factory mapper mapping direct JSON keys to object parameters.
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
    return MaterialApp(
      title: 'FlutterArtist Dio Example',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const Scaffold(
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
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://o7planning.github.io"));
  late final FlutterArtistDio _artistDio;
  String _apiResultText =
      "Press any fetch button to initiate pipeline telemetry.";
  bool _isLoading = false;

  final ScrollController _logScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final loggerInterceptor = FlutterArtistDioLoggerInterceptor();
    _dio.interceptors.add(loggerInterceptor);

    _artistDio = FlutterArtistDio(
      dio: _dio,
      pageMapping: const PageMapping(
        itemsKey: "items",
        paginationKey: "pagination",
        paginationDetailKeys: PaginationDetailKeys(
          currentPage: "currentPage",
          pageSize: "pageSize",
          totalItems: "totalItems",
          totalPages: "totalPages",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logScrollController.dispose();
    super.dispose();
  }

  /// Pipeline trigger targeting a single object map payload.
  Future<void> _fetchSingleCurrency() async {
    _updateLoadingState("Executing single object layout query...");

    final ApiResult<SampleCurrencyData> result = await _artistDio.jsonGet(
      "/static/demo/flutter_artist_dio_demo/json/USD.json",
      converter: SampleCurrencyData.fromJson.toDataConverter(),
    );

    _processResponse(
      result,
      onSuccess: (data) => "Network Single Result Succeeded!\n\n"
          "ID: ${data?.id}\n"
          "Name: ${data?.name}\n"
          "Symbol: ${data?.symbol}",
    );
  }

  /// Pipeline trigger targeting an automated dynamic paginated structural layout.
  Future<void> _fetchPaginatedCurrencies() async {
    _updateLoadingState("Executing paginated collection array query...");

    final ApiResult<PageData<SampleCurrencyData>> result =
        await _artistDio.jsonGetPage(
      "/static/demo/flutter_artist_dio_demo/json/currency-infos.json",
      converter: SampleCurrencyData.fromJson.toDataConverter(),
    );

    _processResponse(
      result,
      onSuccess: (pageData) {
        final buffer = StringBuffer("Network Paginated Layout Succeeded!\n\n");
        final meta = pageData?.paginationInfo;
        buffer.writeln("--- Pagination Metadata ---");
        buffer.writeln("Current Page : ${meta?.currentPage}");
        buffer.writeln("Page Size    : ${meta?.pageSize}");
        buffer.writeln("Total Items  : ${meta?.totalItems}");
        buffer.writeln("Total Pages  : ${meta?.totalPages}\n");
        buffer.writeln("--- Extracted Items Array ---");
        for (var item in pageData?.items ?? <SampleCurrencyData>[]) {
          buffer.writeln("[${item.id}] ${item.name} (${item.symbol})");
        }
        return buffer.toString();
      },
    );
  }

  /// Pipeline trigger targeting a flat array payload layout without metadata wraps.
  Future<void> _fetchFlatListCurrencies() async {
    _updateLoadingState("Executing flat collection array query...");

    final ApiResult<ListData<SampleCurrencyData>> result =
        await _artistDio.jsonGetList(
      "/static/demo/flutter_artist_dio_demo/json/currency-infos.json",
      itemConverter: SampleCurrencyData.fromJson.toDataConverter(),
    );

    _processResponse(
      result,
      onSuccess: (listData) {
        final buffer = StringBuffer("Network Flat List Layout Succeeded!\n\n");
        buffer.writeln("--- Extracted Flat Items Array ---");
        for (var item in listData?.items ?? <SampleCurrencyData>[]) {
          buffer.writeln("[${item.id}] ${item.name} (${item.symbol})");
        }
        return buffer.toString();
      },
    );
  }

  void _updateLoadingState(String message) {
    setState(() {
      _isLoading = true;
      _apiResultText = message;
    });
  }

  void _processResponse<T>(ApiResult<T> result,
      {required String Function(T? data) onSuccess}) {
    setState(() {
      _isLoading = false;
      if (result.isError()) {
        _apiResultText = "Error captured via ErrorInfoExtractor:\n\n"
            "Status Code: ${result.error?.statusCode}\n"
            "Message    : ${result.error?.errorMessage}";
      } else {
        _apiResultText = onSuccess(result.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const webRunCommand =
        'flutter run -d chrome --web-browser-flag "--disable-web-security"';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Workspace Identity Section
            const Center(
              child: Column(
                children: [
                  Icon(Icons.cloud_sync_rounded,
                      size: 54, color: Colors.deepPurple),
                  SizedBox(height: 12),
                  Text(
                    'FlutterArtistDio Framework Workspace',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Web CORS Utility Execution Command Panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.terminal_rounded,
                          size: 18, color: Colors.amber.shade900),
                      const SizedBox(width: 8),
                      Text(
                        'Web Debug Command (Bypass Local CORS)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Expanded(
                        child: SelectableText(
                          webRunCommand,
                          style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.copy_rounded, size: 16),
                        onPressed: () {
                          Clipboard.setData(
                              const ClipboardData(text: webRunCommand));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Command copied to clipboard!')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Selectable Telemetry Output Dashboard Panel
            const Text(
              'Pipeline Telemetry Logs Panel',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Scrollbar(
                        controller: _logScrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _logScrollController,
                          child: SelectableText(
                            _apiResultText,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: 'monospace',
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Interactive Execution Action Controllers
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _fetchSingleCurrency,
                  icon: const Icon(Icons.looks_one_rounded),
                  label: const Text('jsonGet()'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _fetchPaginatedCurrencies,
                  icon: const Icon(Icons.layers_outlined),
                  label: const Text('jsonGetPage()'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _fetchFlatListCurrencies,
                  icon: const Icon(Icons.list_alt_rounded),
                  label: const Text('jsonGetList()'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    DebugNetworkInspectorDialog.show(
                      context,
                      showJson: true,
                      showToken: true,
                    );
                  },
                  icon: const Icon(Icons.list_alt_rounded),
                  label: const Text('Inspector'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
