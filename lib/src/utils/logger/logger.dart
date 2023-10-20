import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as lg;

final _logger = lg.Logger();
typedef Level = lg.Level;
void console(
  dynamic data, {
  Level logLevel = Level.debug,
  dynamic error,
  StackTrace? stackTrace,
}) {
  _logger.log(
    logLevel,
    [data],
    error: error,
    stackTrace: stackTrace,
    time: DateTime.now(),
  );
}

void logInfo(dynamic key) {
  final pattern = '-' * 5;
  _logger.log(
    Level.info,
    pattern + key.toString() + pattern,
  );
}

void logFlutterError(FlutterErrorDetails error) {
  _logger.log(
    Level.fatal,
    'flutter error',
    error: error.exception,
    stackTrace: error.stack,
    time: DateTime.now(),
  );
}
