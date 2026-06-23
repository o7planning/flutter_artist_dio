/// Lightweight blueprint model simulating data entities inside isolation suites.
class SampleCurrencyData {
  final String id;
  final String symbol;
  final String name;

  SampleCurrencyData(
      {required this.id, required this.symbol, required this.name});

  factory SampleCurrencyData.fromJson(Map<String, dynamic> json) {
    return SampleCurrencyData(
      id: json['id'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}
