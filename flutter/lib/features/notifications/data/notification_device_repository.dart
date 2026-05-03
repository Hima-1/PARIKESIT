import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:parikesit/core/network/providers/dio_provider.dart';

class NotificationDeviceRepository {
  NotificationDeviceRepository(this._dio);

  final Dio _dio;

  Future<void> registerFcmToken(String token) async {
    String? appVersion;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (_) {
      appVersion = null;
    }

    await _dio.post<void>(
      '/me/devices/fcm-token',
      data: <String, dynamic>{
        'token': token,
        'platform': defaultTargetPlatform.name,
        'device_name': defaultTargetPlatform.name,
        'app_version': appVersion,
      },
    );
  }

  Future<void> deactivateFcmToken(String token) async {
    await _dio.delete<void>(
      '/me/devices/fcm-token',
      data: <String, dynamic>{'token': token},
    );
  }
}

final notificationDeviceRepositoryProvider =
    Provider<NotificationDeviceRepository>((ref) {
      final dio = ref.watch(dioProvider);
      return NotificationDeviceRepository(dio);
    });
