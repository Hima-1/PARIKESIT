import 'package:flutter/foundation.dart';

class AppConfig {
  // Default to adb reverse for Android devices connected over USB.
  // Override with --dart-define=API_BASE_URL=... for emulator, Wi-Fi, or production.
  static String get baseUrl {
    const defaultBaseUrl = 'http://127.0.0.1:8000';
    const configured = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: defaultBaseUrl,
    );

    const isTest = bool.fromEnvironment('FLUTTER_TEST');
    if (isTest && configured == defaultBaseUrl) {
      throw StateError(
        'API_BASE_URL MUST be provided when running tests. '
        'Example: flutter test --dart-define=API_BASE_URL=http://127.0.0.1:8000',
      );
    }

    if (!isTest && kDebugMode && _isAndroidLoopbackUrl(configured)) {
      debugPrint(
        '[AppConfig] API_BASE_URL is using Android loopback ($configured). '
        'This only works with adb reverse on a physical device. '
        'Use http://10.0.2.2:8000 for the Android emulator or '
        'http://<your-lan-ip>:8000 for a physical device over Wi-Fi/USB without adb reverse.',
      );
    }

    return configured;
  }

  static bool _isAndroidLoopbackUrl(String url) {
    final uri = Uri.tryParse(url);
    final host = uri?.host;
    return host == '127.0.0.1' || host == 'localhost';
  }

  static String get apiPrefix {
    return const String.fromEnvironment('API_PREFIX', defaultValue: '/api');
  }

  static String get fullApiUrl {
    final String base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final String prefix = apiPrefix.isEmpty
        ? ''
        : (apiPrefix.startsWith('/') ? apiPrefix : '/$apiPrefix');

    if (prefix.isEmpty) return base;
    if (base.endsWith(prefix)) return base;

    return '$base$prefix';
  }
}
