import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/network/laravel_response.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/network/providers/dio_provider.dart';
import 'package:parikesit/features/admin/domain/admin_password_reset_result.dart';

import '../../../core/utils/base_repository.dart';

enum UserSortField {
  createdAt('created_at', 'Terbaru'),
  name('name', 'Nama'),
  email('email', 'Email'),
  role('role', 'Peran');

  const UserSortField(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

enum SortDirection {
  asc('asc'),
  desc('desc');

  const SortDirection(this.apiValue);

  final String apiValue;
}

abstract class IAdminUserRepository {
  Future<PaginatedResponse<AppUser>> getUsers({
    int page = 1,
    String? search,
    UserSortField? sort,
    SortDirection? direction,
    int? perPage,
  });
  Future<AppUser> createUser(Map<String, dynamic> userData);
  Future<AppUser> updateUser(int id, Map<String, dynamic> userData);
  Future<AdminPasswordResetResult> resetPassword(int id);
  Future<void> deleteUser(int id);
  Future<AdminReminderTriggerResult> triggerOpdReminder(int id);
}

class AdminReminderTriggerResult {
  const AdminReminderTriggerResult({
    required this.sent,
    required this.skipped,
    required this.incompleteFormCount,
    required this.message,
  });

  factory AdminReminderTriggerResult.fromJson(Map<String, dynamic> json) {
    return AdminReminderTriggerResult(
      sent: int.tryParse('${json['sent'] ?? 0}') ?? 0,
      skipped: int.tryParse('${json['skipped'] ?? 0}') ?? 0,
      incompleteFormCount:
          int.tryParse('${json['incomplete_form_count'] ?? 0}') ?? 0,
      message: '${json['message'] ?? ''}',
    );
  }

  final int sent;
  final int skipped;
  final int incompleteFormCount;
  final String message;
}

class AdminUserRepositoryImpl extends BaseRepository
    implements IAdminUserRepository {
  AdminUserRepositoryImpl(this._dio);

  static const int _defaultUserManagementPerPage = 15;

  final Dio _dio;

  @override
  Future<PaginatedResponse<AppUser>> getUsers({
    int page = 1,
    String? search,
    UserSortField? sort,
    SortDirection? direction,
    int? perPage,
  }) async {
    return safeRequest(() async {
      final Map<String, dynamic> queryParameters = <String, dynamic>{
        'page': page,
      };
      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }
      queryParameters['sort'] = (sort ?? UserSortField.createdAt).apiValue;
      queryParameters['direction'] = (direction ?? SortDirection.desc).apiValue;
      queryParameters['per_page'] = perPage ?? _defaultUserManagementPerPage;

      final response = await _dio.get<dynamic>(
        '/users',
        queryParameters: queryParameters,
      );
      return parseLaravelPaginatedResponse(
        response.data,
        AppUser.fromJson,
        label: 'getUsers',
      );
    }, label: 'getUsers');
  }

  @override
  Future<AppUser> createUser(Map<String, dynamic> userData) async {
    return safeRequest(() async {
      final response = await _dio.post<dynamic>('/users', data: userData);
      return parseLaravelResourceObject(
        response.data,
        AppUser.fromJson,
        label: 'createUser',
      );
    }, label: 'createUser');
  }

  @override
  Future<AppUser> updateUser(int id, Map<String, dynamic> userData) async {
    return safeRequest(() async {
      final response = await _dio.patch<dynamic>('/users/$id', data: userData);
      return parseLaravelResourceObject(
        response.data,
        AppUser.fromJson,
        label: 'updateUser',
      );
    }, label: 'updateUser');
  }

  @override
  Future<AdminPasswordResetResult> resetPassword(int id) async {
    return safeRequest(() async {
      final response = await _dio.post<dynamic>('/users/$id/reset-password');
      if (response.data is! Map) {
        throw LaravelResponseFormatException(
          'resetPassword expected a JSON object but got ${response.data.runtimeType}',
        );
      }

      final root = (response.data as Map).cast<String, dynamic>();
      final data = root['data'];

      if (data is! Map) {
        throw LaravelResponseFormatException(
          'resetPassword expected `data` to be a JSON object but got ${data.runtimeType}',
        );
      }

      final temporaryPassword = '${data['temporary_password'] ?? ''}'.trim();
      if (temporaryPassword.isEmpty) {
        throw LaravelResponseFormatException(
          'resetPassword expected `data.temporary_password` to be a non-empty string.',
        );
      }

      return AdminPasswordResetResult(temporaryPassword: temporaryPassword);
    }, label: 'resetPassword');
  }

  @override
  Future<void> deleteUser(int id) async {
    return safeRequest(() async {
      await _dio.delete<dynamic>('/users/$id');
    }, label: 'deleteUser');
  }

  @override
  Future<AdminReminderTriggerResult> triggerOpdReminder(int id) async {
    return safeRequest(() async {
      final response = await _dio.post<dynamic>(
        '/users/$id/trigger-opd-reminder',
      );
      if (response.data is! Map) {
        throw const FormatException('triggerOpdReminder response invalid.');
      }

      final root = (response.data as Map).cast<String, dynamic>();
      final data = (root['data'] as Map?)?.cast<String, dynamic>() ?? const {};
      return AdminReminderTriggerResult.fromJson({
        ...data,
        'message': root['message'] ?? data['message'],
      });
    }, label: 'triggerOpdReminder');
  }
}

final adminUserRepositoryProvider = Provider<IAdminUserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AdminUserRepositoryImpl(dio);
});
