import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../config/app_config.dart';
import '../../storage/token_storage.dart';
import '../../utils/startup_probe.dart';
import '../interceptors/auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.fullApiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  // Add Auth Interceptor
  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: ref.read(tokenStorageProvider),
      // Keep this provider auth-feature agnostic to avoid Riverpod cycles.
      // Auth feature can still react to 401s by handling them at the call site.
      onUnauthorized: () {},
    ),
  );

  // Add Talker Logger for debugging network requests
  if (!StartupProbeConfig.disableDioLogger) {
    dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          // Multipart/FormData request logging can synchronously inspect file
          // payload metadata on the UI isolate and trigger freezes during upload.
          printRequestData: false,
          // Disable response body logging - large JSON printed synchronously
          // on the main thread blocks the UI and causes ANR with big payloads.
          printResponseMessage: false,
        ),
      ),
    );
  } else {
    StartupProbe.mark('dio_logger_disabled');
  }

  return dio;
});
