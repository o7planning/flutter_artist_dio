
# flutter_artist_dio

A production-grade, enterprise-ready HTTP networking wrapper built on top of the powerful `dio` package. Specially engineered for the **FlutterArtist Ecosystem**, it streamlines REST API consumption, automates multi-format backend error parsing, and provides deep runtime telemetry inspection hooks.

[LIVE DEMO](https://o7planning.github.io/demo/flutter/flutter_artist_dio_demo/)

[Download Demo Source Code](https://github.com/o7planning/flutter_artist_dio_demo) 

![Demo](https://o7planning.github.io/static/demo/flutter_artist_dio_demo/images/demo.gif) 

![Debug Network Inspector](https://o7planning.github.io/static/demo/flutter_artist_dio_demo/images/network-inspector.gif)

##  Live Visual Previews

Discover the real-time layout inspector and centralized response telemetry tracker in action:

Automated telemetry grid tracing active remote multi-platform microservices: 

Debug Network Inspector: 

![Debug Network Inspector](https://o7planning.github.io/static/demo/flutter_artist_dio_demo/images/network-inspector.gif)

##  Architectural Overview: What is `flutter_artist_dio`?

At its core, `flutter_artist_dio` acts as an intelligent structural wrapping layer over the raw `dio` HTTP client. It transforms brittle network streams into predictable, strictly typed `ApiResult<D>` responses, completely eliminating the need for boilerplate `try-catch` segments at the data repository layer.

While it functions as a primary component within the **FlutterArtist ecosystem**, it is designed to be **100% modular** and can be deployed as a standalone networking library in any standard Flutter application.

###  Comprehensive Telemetry Logging Payload

Every single incoming and outgoing execution pipeline monitored by `flutter_artist_dio` records and processes deep architectural parameters:

* **Endpoint Topology:** Full absolute resource target URLs and queries.
* **HTTP Method Vectors:** Transparent classification (`GET`, `POST`, `PUT`, `DELETE`, etc.).
* **Request Manifest:** Detailed monitoring of Request-Headers and parameter maps.
* **Security Context:** Instant verification of active `Authorization` tokens or Bearer envelope headers.
* **Response Telemetry:** Precise measurement of response round-trip time (Response Time), HTTP Status, and contextual protocol metrics.
* **Data Content Storage:** Full, clean structural verification of the payload Response-Body.

---

## ️ Smart Error Extraction Pipeline (`ErrorInfoExtractor`)

One of the biggest pain points in enterprise networking is handling fractured error formats returned by different backend environments (e.g., Laravel validation arrays, .NET Core standard validation summaries, or custom corporate Java APIs).

`flutter_artist_dio` addresses this by introducing the **`ErrorInfoExtractor`** processing pipeline. By default, it deploys the **`FlexibleErrorInfoExtractor`**, which recursively scans and flattens nested structures to extract the exact root-cause message.

### 溺 Fallback & Key Scanning Topology

The extractor performs automated multi-level fallback inspections using predefined dictionary matrices:

* **Message Property Keys:** Automatically scans root and sub-levels for `message`, `errorMessage`, `error`, `msg`, or `title`.
* **Detail Tracking Keys:** Automatically parses nested diagnostic metrics inside `details`, `errorDetails`, `errors`, or `detail`.

### ️ Customizing Your Error Parser

You can inject your own stringifiers or expand the target key map during engine initialization to match any legacy API architecture seamlessly:

```dart
// Instantiate a custom extraction layout matching specialized schemas
const customExtractor = FlexibleErrorInfoExtractor(
    messageKeys: ["custom_api_message", "error_description"],
    detailKeys: ["validation_failures", "reasons"],
);

final customArtistDio = FlutterArtistDio(
    dio: Dio(BaseOptions(baseUrl: "[suspicious link removed]")),
    errorInfoExtractor: customExtractor,
);
```

---

## ️ Embedded Network Inspector Dialog Terminal

`flutter_artist_dio` features an out-of-the-box UI diagnostic cockpit: **`DebugNetworkInspectorDialog`**. This component grants your development team a built-in terminal overlay to analyze request timelines, look up authorization signatures, and verify beautiful raw JSON conversions directly inside the running application layer.

To trigger the workspace monitor, simply call the static presenter anywhere in your debug gesture hooks:

```dart
void _triggerNetworkMonitor(BuildContext context) {
    DebugNetworkInspectorDialog.show(
        context,
        showJson: true,
        showToken: true,
    );
}
```

---

##  Complete Usage & Implementation Recipes

For complete production setups, please look into the official complementary directory files within the `example/` bundle. Below are the two primary patterns for consuming network responses.

### Pattern 1: Safe Functional Check (Recommended)

This approach handles response variations as functional parameters without raising lifecycle exceptions.

```dart
Future loadCurrencyAsset() async {
  final currencyRestProvider = CurrencyRestProvider();

  // Clean execution pipeline yielding a unified result envelope
  ApiResult result = await currencyRestProvider.find(
      currencyId: "VND",
  );

  if (result.isError()) {
      // Automatically populated via the ErrorInfoExtractor engine
      print("Error Message: ${result.error?.errorMessage}");
      print("Error Details: ${result.error?.errorDetails}");
  } else {
      CurrencyData? data = result.data;
      print("Currency Data successfully fetched: $data");
  }
}
```

### Pattern 2: Guardrail Interception (`throwIfError`)

Ideal for transactional logic where failure must interrupt the execution pipeline immediately.

```dart
Future executeStrictAssetValidation() async {
  final currencyRestProvider = CurrencyRestProvider();

  ApiResult result = await currencyRestProvider.find(
  currencyId: "VND",
  );

  // Instantly raises an ApiError exception if the transaction status failed,
  // allowing an external global error handler or bloc observer to capture it.
  result.throwIfError();

  // Execution continues safely if result succeeded
  CurrencyData? data = result.data;
  print("Validated Currency Data payload: $data");
}
```

---

## ️ Installation & Dependency Specs

Include the following parameters inside your project `pubspec.yaml` manifest:

```yaml
dependencies: 
  dio: ^5.9.0
  fresh_dio: ^0.6.0
  json_serializable: ^6.12.0
  json_annotation: ^4.10.0
  flutter_artist_core: ^0.9.1
  flutter_artist_dio: ^0.9.0
  flutter_left_right_container: ^0.9.0
```
 