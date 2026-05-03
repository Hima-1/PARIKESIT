import 'dart:developer' as developer;

import 'package:flutter/scheduler.dart';

class StartupProbeConfig {
  const StartupProbeConfig._();

  static const bool enabled = bool.fromEnvironment(
    'LOGIN_STARTUP_PROBE',
    defaultValue: false,
  );
  static const bool bypassAuthInit = bool.fromEnvironment(
    'LOGIN_PROBE_BYPASS_AUTH_INIT',
    defaultValue: false,
  );
  static const bool disableLoginCustomPaint = bool.fromEnvironment(
    'LOGIN_PROBE_DISABLE_CUSTOM_PAINT',
    defaultValue: false,
  );
  static const bool disableDioLogger = bool.fromEnvironment(
    'LOGIN_PROBE_DISABLE_DIO_LOGGER',
    defaultValue: false,
  );
  static const bool disableProviderObserver = bool.fromEnvironment(
    'LOGIN_PROBE_DISABLE_PROVIDER_OBSERVER',
    defaultValue: false,
  );
  static const bool skipSecureStorageRead = bool.fromEnvironment(
    'LOGIN_PROBE_SKIP_SECURE_STORAGE_READ',
    defaultValue: false,
  );
}

class StartupProbe {
  StartupProbe._();

  static const Duration _frameBudget = Duration(milliseconds: 16);
  static final Stopwatch _appStopwatch = Stopwatch()..start();
  static bool _frameTrackingInstalled = false;
  static bool _loginFirstFrameMarked = false;

  static bool isJankyFrame({
    required Duration buildDuration,
    required Duration rasterDuration,
    Duration budget = _frameBudget,
  }) {
    return buildDuration > budget || rasterDuration > budget;
  }

  static Future<T> measureAsync<T>(
    String label,
    Future<T> Function() operation,
  ) async {
    if (!StartupProbeConfig.enabled) {
      return operation();
    }

    final stopwatch = Stopwatch()..start();
    mark('$label:start');
    try {
      return await operation();
    } finally {
      stopwatch.stop();
      mark('$label:end', <String, Object?>{
        'elapsed_ms': stopwatch.elapsedMilliseconds,
      });
    }
  }

  static void installFrameTimingsProbe() {
    if (!StartupProbeConfig.enabled || _frameTrackingInstalled) {
      return;
    }

    _frameTrackingInstalled = true;
    SchedulerBinding.instance.addTimingsCallback((timings) {
      for (final timing in timings) {
        mark('frame_timing', <String, Object?>{
          'build_ms': timing.buildDuration.inMilliseconds,
          'raster_ms': timing.rasterDuration.inMilliseconds,
          'vsync_overhead_ms': timing.vsyncOverhead.inMilliseconds,
          'janky': isJankyFrame(
            buildDuration: timing.buildDuration,
            rasterDuration: timing.rasterDuration,
          ),
        });
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      mark('first_frame_posted');
    });
  }

  static void markLoginFirstFrame() {
    if (!StartupProbeConfig.enabled || _loginFirstFrameMarked) {
      return;
    }

    _loginFirstFrameMarked = true;
    mark('login_first_frame_visible');
  }

  static void mark(String label, [Map<String, Object?> arguments = const {}]) {
    if (!StartupProbeConfig.enabled) {
      return;
    }

    final payload = <String, Object?>{
      't_ms': _appStopwatch.elapsedMilliseconds,
      ...arguments,
    };
    developer.Timeline.instantSync(label, arguments: payload);
    developer.log(
      '[startup_probe] $label ${payload.toString()}',
      name: 'startup_probe',
    );
  }
}
