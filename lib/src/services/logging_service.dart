
part of './index_service.dart';

class LoggingService {
  LoggingService._();
  final _apiDB = firestoreService.apiLogsDB;

  Future<void> logAPIError((Endpoints, DioException) apiError) async {
    final (endPoint, error) = apiError;
    _logDioException(error, endPoint);
  }

  Future<void> _logDioException(DioException error, Endpoints endPoint) async {
    final rootDocId = _filterEndpoint(endPoint);

    final rootDoc = _apiDB.doc(rootDocId);

    final request = error.requestOptions;
    final resposne = error.response;

    String errorCollectionId =
        (resposne?.statusCode ?? _getErrorCollection(error)).toString();

    final errorCollection = rootDoc.collection(errorCollectionId);

    final errorDocId = DateTime.now().toIso8601String();
    final errorDoc = errorCollection.doc(errorDocId);

    final body = {
      'method': request.method,
      'headers': request.headers,
      'queryParameters': request.queryParameters,
      'type': error.type.name,
      'statusCode': resposne?.statusCode,
      'response': resposne?.data,
      'error': error.error.toString(),
      'message': error.message,
      'trace': error.stackTrace.toString()
    };

    errorDoc.set(body);
  }

  String _filterEndpoint(Endpoints endPoint) {
    return endPoint.url.replaceAll('/', '-');
  }

  String _getErrorCollection(DioException exception) {
    if (exception is NoInternetConnectionException) {
      return 'no-internet';
    } else if (exception is ServerDownException) {
      return 'server-down';
    }

    return 'errors';
  }
}
