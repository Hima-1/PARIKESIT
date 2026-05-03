import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'logger.dart';

/// Custom Riverpod observer using [TalkerRiverpodObserver]
/// to track provider state changes.
base class AppProviderObserver extends TalkerRiverpodObserver {
  AppProviderObserver()
    : super(
        talker: AppLogger.talker,
        settings: const TalkerRiverpodLoggerSettings(
          printProviderAdded: true,
          printProviderUpdated: true,
          printProviderFailed: true,
          printProviderDisposed: false,
        ),
      );
}
