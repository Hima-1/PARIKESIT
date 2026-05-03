import 'package:talker_flutter/talker_flutter.dart';

/// Centralized logger for the application using [Talker].
///
/// Provides a consistent way to log messages, errors, and exceptions
/// across the entire codebase.
class AppLogger {
  static final Talker _talker = TalkerFlutter.init(
    settings: TalkerSettings(maxHistoryItems: 100),
    logger: TalkerLogger(settings: TalkerLoggerSettings(enableColors: true)),
  );

  /// Access the global [Talker] instance.
  static Talker get talker => _talker;

  /// Log an information message.
  static void info(String message) => _talker.info(message);

  /// Log a debug message.
  static void debug(String message) => _talker.debug(message);

  /// Log a warning message.
  static void warning(String message) => _talker.warning(message);

  /// Log an error message with optional exception and stacktrace.
  static void error(
    String message, [
    dynamic exception,
    StackTrace? stackTrace,
  ]) {
    _talker.error(message, exception, stackTrace);
  }

  /// Log a critical message.
  static void critical(
    String message, [
    dynamic exception,
    StackTrace? stackTrace,
  ]) {
    _talker.critical(message, exception, stackTrace);
  }
}
