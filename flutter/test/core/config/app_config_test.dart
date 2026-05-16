import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('requires API_BASE_URL from the Flutter environment', () {
      const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

      if (configuredBaseUrl.trim().isEmpty) {
        expect(() => AppConfig.baseUrl, throwsStateError);
        return;
      }

      final normalizedBaseUrl = configuredBaseUrl.trim().endsWith('/')
          ? configuredBaseUrl.trim().substring(
              0,
              configuredBaseUrl.trim().length - 1,
            )
          : configuredBaseUrl.trim();

      expect(AppConfig.baseUrl, configuredBaseUrl.trim());
      expect(AppConfig.fullApiUrl, '$normalizedBaseUrl/api');
    });
  });
}
