import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/providers/dio_provider.dart';

import '../../../core/network/laravel_response.dart';
import '../../../core/network/paginated_response.dart';
import '../domain/notification_model.dart';

class NotificationRepository {
  NotificationRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResponse<AppNotification>> fetchNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/notifications',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return parseLaravelPaginatedResponse(
      response.data ?? const <String, dynamic>{},
      AppNotification.fromJson,
      label: 'NotificationRepository.fetchNotifications',
    );
  }

  Future<AppNotification> markAsRead(String id) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/notifications/$id/read',
    );
    final payload = response.data?['data'] as Map<String, dynamic>? ?? const {};

    return AppNotification.fromJson(payload);
  }

  Future<void> markAllAsRead() async {
    await _dio.patch<void>('/notifications/read-all');
  }

  Future<void> deleteNotification(String id) async {
    await _dio.delete<void>('/notifications/$id');
  }

  Future<void> deleteReadNotifications() async {
    await _dio.delete<void>('/notifications/read');
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRepository(dio);
});
