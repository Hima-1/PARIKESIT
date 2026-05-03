import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/utils/startup_probe.dart';

void main() {
  group('StartupProbeConfig', () {
    test('defaults all experiment toggles to disabled', () {
      expect(StartupProbeConfig.enabled, isFalse);
      expect(StartupProbeConfig.bypassAuthInit, isFalse);
      expect(StartupProbeConfig.disableLoginCustomPaint, isFalse);
      expect(StartupProbeConfig.disableDioLogger, isFalse);
      expect(StartupProbeConfig.disableProviderObserver, isFalse);
      expect(StartupProbeConfig.skipSecureStorageRead, isFalse);
    });
  });

  group('StartupProbe', () {
    test('flags frames as janky when build or raster exceeds budget', () {
      expect(
        StartupProbe.isJankyFrame(
          buildDuration: const Duration(milliseconds: 17),
          rasterDuration: const Duration(milliseconds: 1),
        ),
        isTrue,
      );
      expect(
        StartupProbe.isJankyFrame(
          buildDuration: const Duration(milliseconds: 1),
          rasterDuration: const Duration(milliseconds: 17),
        ),
        isTrue,
      );
    });

    test('treats frames within budget as non-janky', () {
      expect(
        StartupProbe.isJankyFrame(
          buildDuration: const Duration(milliseconds: 16),
          rasterDuration: const Duration(milliseconds: 16),
        ),
        isFalse,
      );
    });
  });
}
