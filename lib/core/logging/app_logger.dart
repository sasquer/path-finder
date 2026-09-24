abstract interface class AppLogger {
  void debug(String message);

  void info(String message);

  void warning(String message, [Object? error]);

  void error(String message, [Object? error, StackTrace? stackTrace]);
}

class DefaultLogger implements AppLogger {
  const DefaultLogger();

  @override
  void debug(String message) {}

  @override
  void info(String message) {}

  @override
  void warning(String message, [Object? error]) {}

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {}
}
