part of '../flutter_artist_dio.dart';

const _timeStampKey = '_pdl_timeStamp_';

/// The sovereign network telemetry interceptor gatekeeper responsible for capturing,
/// measuring, and logging outbound and inbound HTTP traffic pipelines.
///
/// Inheriting from third-party [QueuedInterceptor], it hooks into the low-level
/// reactive network lifecycles (`onRequest`, `onResponse`, `onError`) safely.
/// It transparently injects precise transaction initialization timestamps and reconciles
/// round-trip performance latency metrics before pushing immutable data packets straight
/// down into the centralized [ApiLogger] ledger storage buffer.
class FlutterArtistDioLoggerInterceptor extends QueuedInterceptor {
  /// Instantiates the production-grade network diagnostic log evaluation interceptor engine.
  FlutterArtistDioLoggerInterceptor();

  /// Intercepts and audits all outgoing HTTP request transaction sequences immediately before dispatch ticks.
  ///
  /// This method stamps an absolute universal initialization timestamp inside the connection's `extra` mapping structure,
  /// initializes a clean identity-stamped [ApiLogData] container trace tracking record, and safely commits
  /// the packet down to the volatile buffer ledger database via [ApiLogger.instance._addApiLogData].
  ///
  /// * [options]: The active outbound connection parameter metadata blueprints.
  /// * [handler]: The interceptor execution chain control proxy driving upstream operations.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_timeStampKey] = DateTime.timestamp().millisecondsSinceEpoch;
    final apiLogData = _ApiLogHelper.createApiLogData(options);
    ApiLogger.instance._addApiLogData(apiLogData);
    handler.next(options);
  }

  /// Intercepts and captures aborted connection exceptions, TLS failures, or bad HTTP status response code transactions.
  ///
  /// This method instantly calculates total round-trip failure execution delays by subtracting the original
  /// outbound timestamp from the current system clock frame. It wraps the exception properties inside
  /// a structured [ErrorLogData] model, appends the blueprint profile onto the corresponding historical
  /// active transaction node, and propagates the failure safely back down the handler track loop.
  ///
  /// * [err]: The low-level transport exception details captured during the aborted transaction lifecycle.
  /// * [handler]: The interceptor execution chain control proxy driving failure propagation loops.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final triggerTime = err.requestOptions.extra[_timeStampKey];
    int responseTime = 0;
    if (triggerTime is int) {
      responseTime = DateTime.timestamp().millisecondsSinceEpoch - triggerTime;
    }
    final ApiLogData? apiLogData =
        _ApiLogHelper.getApiLogData(err.requestOptions);
    final errorInfo = ErrorLogData(err, responseTime);
    apiLogData?._setErrorInfo(errorInfo);
    handler.next(err);
  }

  /// Intercepts and parses successfully resolved inbound network response packet frames arriving from remote host engines.
  ///
  /// This method evaluates accurate total transaction duration boundaries, abstracts raw header data streams
  /// into a structured [ResponseLogData] container snapshot asset, binds the completed metrics back to the canonical
  /// parent [ApiLogData] record node, and releases the execution lock back to local application callers smoothly.
  ///
  /// * [response]: The successful inbound packet package containing server data maps and headers.
  /// * [handler]: The interceptor execution chain control proxy driving successful return values downstream.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final ApiLogData? apiLogData =
        _ApiLogHelper.getApiLogData(response.requestOptions);
    final triggerTime = response.requestOptions.extra[_timeStampKey];

    int responseTime = 0;
    if (triggerTime is int) {
      responseTime = DateTime.timestamp().millisecondsSinceEpoch - triggerTime;
    }
    //
    final responseInfo = ResponseLogData(
      response: response,
      responseTime: responseTime,
    );
    apiLogData?._setResponseInfo(responseInfo);
    handler.next(response);
  }
}
