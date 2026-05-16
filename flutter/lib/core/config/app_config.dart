import 'package:flutter/foundation.dart';

class AppConfig {
  static String get baseUrl {
    const configured = String.fromEnvironment('API_BASE_URL');
    final trimmed = configured.trim();

    if (trimmed.isEmpty) {
      throw StateError(
        'API_BASE_URL is not configured. Copy .env.example to .env and run '
        'Flutter with --dart-define-from-file=.env.',
      );
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw StateError(
        'API_BASE_URL must be an absolute URL, for example '
        'https://api.example.com.',
      );
    }

    if (kDebugMode && _isAndroidLoopbackUrl(trimmed)) {
      debugPrint(
        '[AppConfig] API_BASE_URL is using Android loopback ($trimmed). '
        'Make sure this host is reachable from the selected device.',
      );
    }

    return trimmed;
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
