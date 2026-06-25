# Changelog

All notable changes to the `flutter_artist_dio` library will be documented in this file.


---

## [2.0.0]

### Added

* jsonPostFetchList
* jsonPostList
* jsonPostPage
* ....

## [1.0.0] - 2026-06-23

###  Added
* **Zero-Boilerplate Collection Architecture:** Introduced decoupled JSON structural parsing directly inside the networking pipe, eliminating the need to write redundant response wrapper classes (e.g., `CountryInfoPage`, `UserPage`) for `json_serializable`.
* **Declarative `PageMapping` Configurations:** Added a flexible configuration layout (`PageMapping` and `PaginationDetailKeys`) to map alternative backend JSON structures (e.g., snake_case, or key variations like `data` and `meta`) seamlessly during client initialization.
* **Granular Return Subtypes (`ListData` & `PageData`):** Split collection outputs into two distinct, independent models to guarantee strict type-safety and robust IDE compiler error prevention:
    * `ListData<ITEM>`: For flat collections and non-paginated array payloads.
    * `PageData<ITEM>`: For structured pagination components carrying dedicated `PaginationInfo` metadata.
* **New HTTP Method Target Variants:** Added semantic wrappers to handle strict layout extractions cleanly across multiple request lifecycles:
    * `jsonGetList<ITEM>()` & `jsonGetPage<ITEM>()`
    * `jsonPostList<ITEM>()` & `jsonPostPage<ITEM>()`
    * `jsonPutList<ITEM>()` & `jsonPutPage<ITEM>()`
* **Static Wrapper Casting Utilities:** Embedded functional static helper macros inside `ApiResult` to handle safe data container conversions between flat structures and metadata envelopes smoothly:
    * `ApiResult.createPageDataResult(listResult)`
    * `ApiResult.createListDataResult(pageResult)`

### ️ Changed
* **Centralized Data Parsing:** Shifted raw item and pagination token resolution blocks out of inline network code and isolated them into dedicated `_convertToPageData` and `_convertToListData` helper routines to optimize client maintenance profiles.
* **Strict Item Conversion Constraints:** Enforced a strict non-nullable safety check within the array parsing routine. If a model `converter` yields a `null` item during payload processing, the engine immediately throws an `ApiErrorType.conversion` to protect data runtime integrity.

### ⚠️ Deprecated
* **Response Data Mode Configurations:** Officially marked `ResponseDataMode` as `@Deprecated`. The framework is migrating permanently away from legacy wrapped data envelopment strategies toward explicit RESTful payload processing.

###  Fixed
* **List to Page Structural Slicing Defect:** Fixed an algorithmic data truncation issue inside `ListData.toPageData()` where calculating slice indexes using an incorrect default size cut off elements from flat array caches. It now safely adapts to total element counts.
* **Telemetry Workspace Inspector Synchronization:** Patched an orchestration bug within the example suite ensuring the underlying `FlutterArtistDioLoggerInterceptor` is registered as the absolute first entry in the Dio engine pipe, restoring telemetry stream visualizations in the `DebugNetworkInspectorDialog`.
* **Web UI Layout Positioning Exception:** Resolved a critical Flutter Web/Desktop scroll bind crash (`The Scrollbar's ScrollController has no ScrollPosition attached`) inside log preview panels by explicitly synchronizing a shared `ScrollController` across the `Scrollbar` and its nested viewport components.

## 0.9.5

* Update Dependencies.

## 0.9.4

* Update Dependencies.

## 0.9.3

* Update Dependencies and Docs.

## 0.9.2

* Update Dependencies.

## 0.9.1

* Update Documents & DEMO.


## 0.9.0

* Initial release.
