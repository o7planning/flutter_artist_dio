
# flutter_artist_dio

A production-grade, enterprise-ready HTTP networking wrapper built on top of the powerful `dio` package. Specially engineered for the **FlutterArtist Ecosystem**, it streamlines REST API consumption, automates multi-format backend error parsing, and introduces zero-boilerplate collection parsing using declarative structural configurations.

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

At its core, `flutter_artist_dio` acts as an intelligent structural wrapping layer over the raw `dio` HTTP client. It transforms brittle network streams into predictable, strongly typed `ApiResult<D>` responses, completely eliminating the need for boilerplate `try-catch` segments or redundant list wrapper generation classes at the data repository layer.

While it functions as a primary component within the **FlutterArtist ecosystem**, it is designed to be **100% modular** and can be deployed as a standalone networking library in any standard Flutter application.

---

## ️ Zero-Boilerplate Collection Architecture (`PageMapping`)

In traditional Flutter setups, handling dynamic paginated APIs requires generating explicit, redundant response wrapper classes (e.g., `CountryInfoPage`, `UserPage`) to satisfy `json_serializable` compile-time constraints.

`flutter_artist_dio` permanently solves this pain point by decoupling collection structures from model definitions. It introduces native automated JSON breakdown utilities directly inside the networking pipe, feeding items sequentially into single-entity converters.

###  Out-of-the-Box Default Layout Mapping

If your backend adheres to standard RESTful response layouts, you do not need to configure anything. By default, `PageMapping` targets the following structures:

#### 1. Single Model Structure (`jsonGet` / `jsonPost` / etc.)
```json
{
   "id": "USD",
   "symbol": "$",
   "name": "US Dollar",
   "description": "The USD (United States dollar) ...."
}

```

#### 2. Paginated Structure (`jsonGetPage` / `jsonPostPage` / etc.)

```json
{  
  "pagination": { 
     "currentPage": 1, 
     "pageSize": 20, 
     "totalItems": 29, 
     "totalPages": 2 
  }, 
   "items": [ 
      { "id": "USD", "symbol": "$", "name": "US Dollar" }, 
      { "id": "EUR", "symbol": "€", "name": "Euro" }, 
      { "id": "JPY", "symbol": "¥", "name": "Japanese Yen" } 
   ] 
}

```

#### 3. Flat List Structure (`jsonGetList` / `jsonPostList` / etc.)

This layout shares the same root array block config (`itemsKey`), skipping the metadata envelope when pulling raw non-paginated arrays:

```json
{  
   "items": [ 
      { "id": "USD", "symbol": "$", "name": "US Dollar" }, 
      { "id": "EUR", "symbol": "€", "name": "Euro" }
   ] 
}

```

---

### ⚙️ Customizing Dynamic Mappings

If your remote corporate services use alternative naming patterns (e.g., snake_case or customized keys like `data` and `meta`), simply provide a tailor-made `PageMapping` schema configuration during initialization:

```dart
final artistDio = FlutterArtistDio(
  dio: Dio(BaseOptions(baseUrl: "[https://api.example.com](https://api.example.com)")),
  pageMapping: PageMapping(
    itemsKey: "data",             // Overrides 'items' with your custom array payload key
    paginationKey: "meta",        // Overrides 'pagination' with your custom wrapper block key
    paginationDetailKeys: PaginationDetailKeys(
      currentPage: "current_page",
      pageSize: "page_size",
      totalItems: "total_elements",
      totalPages: "total_pages",
    ),
  ),
);

```

| Mapping Parameter | Default Value | Functional Role |
| --- | --- | --- |
| `itemsKey` | `"items"` | Target root array key holding raw collections across both List and Page pipelines. |
| `paginationKey` | `"pagination"` | Target block key wrapping pagination metrics. |
| `paginationDetailKeys.currentPage` | `"currentPage"` | Integer extraction pointer identifying current active page indexing. |
| `paginationDetailKeys.pageSize` | `"pageSize"` | Integer extraction pointer measuring allocated list elements per layout. |
| `paginationDetailKeys.totalItems` | `"totalItems"` | Total count constraint calculating backend asset weights globally. |
| `paginationDetailKeys.totalPages` | `"totalPages"` | Total dynamic calculated pages accessible via sequence limits. |

---

## 㛡️ Smart Error Extraction Pipeline (`ErrorInfoExtractor`)

One of the biggest pain points in enterprise networking is handling fractured error formats returned by different backend environments (e.g., Laravel validation arrays, .NET Core standard validation summaries, or custom corporate Java APIs).

`flutter_artist_dio` addresses this by introducing the **`ErrorInfoExtractor`** processing pipeline. By default, it deploys the **`FlexibleErrorInfoExtractor`**, which recursively scans and flattens nested structures to extract the exact root-cause message.

### 離 Fallback & Key Scanning Topology

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
    dio: Dio(BaseOptions(baseUrl: "[https://api.example.com](https://api.example.com)")),
    pageMapping: const PageMapping(),
    errorInfoExtractor: customExtractor,
);

```

---

## ️ Embedded Network Inspector Dialog Terminal

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

### Unified Response Container Strategy (`ApiResult`)

Every transaction yields an `ApiResult<D>` instance, splitting payloads cleanly between strongly typed models and structured error states.

```dart
// Fetching a dynamic paginated collection directly into PageData<T>
Future<void> fetchCurrencies(FlutterArtistDio artistDio) async {
  final ApiResult<PageData<SampleCurrencyData>> result = await artistDio.jsonGetPage(
    "/api/v1/currencies/search",
    converter: SampleCurrencyData.fromJson.toDataConverter(), // Explicit model converter mapping a SINGLE element
  );

  if (result.isError()) {
    print("Network Failure Captured: ${result.error?.errorMessage}");
  } else {
    final PageData<SampleCurrencyData> page = result.data!;
    print("Current Page Index: ${page.paginationInfo?.currentPage}");
    print("Extracted Elements Count: ${page.items.length}");
  }
}

```

### Advanced Translation Mechanics: Cross-Type Mappings

When consuming raw data providers that emit flat collections (`ListData`), but abstract layers or external state-machines expect paginated signatures (`PageData`), invoke declarative construction cast macros to convert wrappers safely without risking runtime conversion crashes:

```dart
@override 
Future<ApiResult<PageData<ContributorInfo>?>> performQuery({ 
  required Object? parentBlockCurrentItem, 
  required Pageable pageable, 
}) async { 
  ProjectInfo projectInfo = parentBlockCurrentItem as ProjectInfo; 
  
  // Provider returns flat collection data: ApiResult<ListData<ContributorInfo>>
  final result = await contributorProvider.queryAllByProjectId( 
    projectId: projectInfo.id, 
  ); 
  
  // Creates a standard PageData structural payload envelope directly out of flat results
  return ApiResult.createPageDataResult(result); 
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
  flutter_artist_core: ^latest
  flutter_artist_dio: ^latest
  flutter_left_right_container: ^latest

``` 