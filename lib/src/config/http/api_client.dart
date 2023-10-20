import 'package:catfact/src/core/enums/http/http_base_url.dart';
import 'package:catfact/src/core/enums/http/http_endpoints.dart';
import 'package:catfact/src/config/http/types/response.dart';
import 'package:catfact/src/services/index_service.dart';
import 'package:catfact/src/utils/logger/logger.dart';
import 'package:catfact/src/utils/utils.dart';
import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';

import 'exceptions/custom_exceptions.dart';
import 'helpers/helpers.dart';
import 'types/http_types.dart';

typedef ResponseModifier<T> = HttpResult<T> Function(
    Response<dynamic> rawResponse);

class ApiClient {
  ApiClient.init();

  final Dio _dio = Dio();

  Future<HttpResult<T>> get<T>(
    Endpoints endPoint, {
    required BaseUrl base,
    Map<String, dynamic>? headers,
    QueryParams queryParams,
    CancelToken? cancelToken,
    ResponseModifier<T>? modifier,
  }) async {
    queryParams = await _updateQueryParams(queryParams);
    return _requestHandler<T>(
      endPoint,
      base,
      queryParameters: queryParams,
      modifier: modifier,
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );
  }

  Future<HttpResult<T>> post<T>(
    Endpoints endPoint,
    dynamic body, {
    required BaseUrl base,
    ResponseModifier<T>? modifier,
    Map<String, dynamic>? headers,
    QueryParams queryParams,
    CancelToken? cancelToken,
  }) async {
    if (body is Map) {
      body = await _updateBody(Map.from(body));

      body.removeWhere(
          (key, value) => value == null || value.toString().isNullOrBlank);
    }

    return _requestHandler(
      endPoint,
      base,
      data: body,
      modifier: modifier,
      queryParameters: queryParams,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
    );
  }

  String _getUrl({required Endpoints endpoint, required BaseUrl base}) {
    return base.url + endpoint.url;
  }

  Future<HttpResult<T>> _requestHandler<T>(
    Endpoints endpoint,
    BaseUrl base, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ResponseModifier<T>? modifier,
  }) async {
    String path = _getUrl(endpoint: endpoint, base: base);
    options = _modifyOptions(options);

    console([
      path,
      options?.method,
      options?.headers,
      data,
    ], logLevel: Level.debug);

    try {
      final res = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      console([path, res.data], logLevel: Level.debug);
      final HttpResult<T> result =
          modifier?.call(res) ?? HttpResult.completed(res.data);

      return result;
    } on DioException catch (error) {
      return _handleDioError<T>(error, endPoint: endpoint);
    } catch (error, trace) {
      final dioError = DioException(
        requestOptions: (options ?? Options()).compose(
          _dio.options,
          path,
          data: data,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onReceiveProgress,
          queryParameters: queryParameters,
          sourceStackTrace: trace,
        ),
        error: error,
        stackTrace: trace,
        message: 'flutter-error',
      );
      return _handleDioError(dioError, endPoint: endpoint);
    }
  }

  Options? _modifyOptions(Options? options) {
    return options?.copyWith(
      sendTimeout: const Duration(seconds: 5),
      headers: _updateHeaders(options.headers),
    );
  }

  Map<String, Object?>? _updateHeaders(Map<String, Object?>? headers) {
    return Map.from({
      ...?headers,
      'Content-Type': "application/json",
    });
  }

  Future<QueryParams?> _updateQueryParams(QueryParams params) async {
    return Map.from({
      ...?params,
    });
  }

  Future<Map<String, dynamic>?> _updateBody(Map<String, dynamic>? body) async {
    return Map.from({
      ...?body,
    });
  }

  HttpResult<T> _handleDioError<T>(DioException err,
      {Endpoints endPoint = Endpoints.unknown}) {
    final reqOption = err.requestOptions;
    final statusCode = err.response?.statusCode;
    final internalError = err.error;

    DioException exception = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        DeadlineExceededException(reqOption),
      DioExceptionType.badResponse =>
        getExceptionForBadResponse(statusCode, reqOption),
      DioExceptionType.cancel => DioException.requestCancelled(
          requestOptions: reqOption, reason: 'new request was created'),
      DioExceptionType.connectionError =>
        NoInternetConnectionException(reqOption),
      DioExceptionType.unknown => getUnknownException(internalError, reqOption),
      DioExceptionType.badCertificate => BadCertificateException(reqOption),
    };

    exception = exception.copyWith(
      requestOptions: err.requestOptions,
      response: err.response,
      error: err.error,
      message: exception.toString(),
      stackTrace: err.stackTrace,
      type: err.type,
    );
    dynamic errorMessage = "";

    var responseData = exception.response?.data;
    if (responseData is Map) {
      errorMessage = responseData["message"] ?? responseData["error"];
    } else {
      errorMessage = exception.message ?? "";
    }

    Utils.showErrorToast(errorMessage);
    console([
      exception.error,
      exception.response,
      exception.requestOptions.data,
      exception.requestOptions.headers,
      exception.requestOptions.queryParameters
    ], logLevel: Level.fatal);
    renderCurlRepresentation(exception.requestOptions);
    loggingService.logAPIError((endPoint, exception));
    return HttpResult.error(errorMessage.toString());
  }
}
