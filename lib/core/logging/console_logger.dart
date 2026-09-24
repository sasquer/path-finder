import 'package:flutter/foundation.dart';
import 'package:path_finder/core/logging/app_logger.dart';

class ConsoleLogger implements AppLogger {
  const ConsoleLogger(this._tag);

  final String _tag;

  @override
  void debug(String message) => _print('Debug', message);

  @override
  void info(String message) => _print('Info', message);

  @override
  void warning(String message, [Object? error]) => _print('Warning', message, error);

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _print('Error', message, error, stackTrace);

  void _print(String level, String message, [Object? error, StackTrace? stackTrace]) {
    if (kReleaseMode) return;

    final buffer = StringBuffer('${_timestamp()} $level/$_tag: $message');
    if (error != null) buffer.write('\n$error');
    if (stackTrace != null) buffer.write('\n$stackTrace');
    debugPrint(buffer.toString());
  }

  /// Local time as `HH:mm:ss.SSS`.
  static String _timestamp() {
    final now = DateTime.now();
    String pad(int value, [int width = 2]) => value.toString().padLeft(width, '0');
    return '${pad(now.hour)}:${pad(now.minute)}:${pad(now.second)}'
        '.${pad(now.millisecond, 3)}';
  }
}
