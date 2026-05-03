import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('uses localhost over adb reverse by default on Android devices', () {
      expect(AppConfig.baseUrl, 'http://127.0.0.1:8000');
      expect(AppConfig.fullApiUrl, 'http://127.0.0.1:8000/api');
    });
  });
}
