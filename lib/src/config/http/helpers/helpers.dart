import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:catfact/src/config/http/exceptions/custom_exceptions.dart';
import 'package:dio/dio.dart';

DioException getExceptionForBadResponse(
    int? statusCode, RequestOptions requestOptions) {
  return switch (statusCode) {
    400 || 422 => BadRequestException(requestOptions),
    401 || 403 => UnauthorizedException(requestOptions),
    404 => NotFoundException(requestOptions),
    409 => ConflictException(requestOptions),
    500 || 501 || 502 => InternalServerErrorException(requestOptions),
    _ => SomethingWentWrongException(requestOptions)
  };
}

DioException getUnknownException(Object? error, RequestOptions requestOptions) {
  return switch (error.runtimeType) {
    SocketException => switch ((error as SocketException).osError?.errorCode) {
        101 => NoInternetConnectionException(requestOptions),
        111 => ServerDownException(requestOptions),
        _ => SomethingWentWrongException(requestOptions)
      },
    _ => SomethingWentWrongException(requestOptions),
  };
}

void renderCurlRepresentation(RequestOptions requestOptions) {
  try {
    log(_cURLRepresentation(requestOptions));
  } catch (err) {
    log('unable to create a CURL representation of the requestOptions');
  }
}

String _cURLRepresentation(RequestOptions options) {
  List<String> components = ['curl -i'];
  if (options.method.toUpperCase() != 'GET') {
    components.add('-X ${options.method}');
  }

  options.headers.forEach((k, v) {
    if (k != 'Cookie' && k != 'content-length') {
      components.add('-H "$k: $v"');
    }
  });

  if (options.data != null) {
    if (options.data is FormData) {
      options.data = Map.fromEntries(options.data.fields);
    }

    final data = json.encode(options.data).replaceAll('"', '\\"');
    components.add('-d "$data"');
  }

  components.add('"${options.uri.toString()}"');

  return components.join(' \\\n\t');
}
