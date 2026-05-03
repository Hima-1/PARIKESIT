import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/admin/domain/admin_password_reset_result.dart';

import '../../data/admin_user_repository.dart';
import '../../domain/admin_user_query.dart';

class UserAdminController extends AsyncNotifier<PaginatedResponse<AppUser>> {
  AdminUserQuery _query = const AdminUserQuery();

  AdminUserQuery get query => _query;

  @override
  Future<PaginatedResponse<AppUser>> build() async {
    return _loadUsers();
  }

  Future<void> fetchUsers({int page = 1, String? search}) async {
    _query = _query.copyWith(
      search: (search ?? _query.search).trim(),
      page: page,
    );
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _loadUsers();
    });
  }

  Future<void> setSearch(String search) async {
    _query = _query.copyWith(search: search.trim(), page: 1);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadUsers);
  }

  Future<void> setSort(UserSortField sort) async {
    _query = _query.copyWith(sort: sort, page: 1);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadUsers);
  }

  Future<void> toggleSortDirection() async {
    _query = _query.copyWith(
      direction: _query.direction == SortDirection.asc
          ? SortDirection.desc
          : SortDirection.asc,
      page: 1,
    );
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadUsers);
  }

  Future<void> nextPage() async {
    final current = state.asData?.value;
    if (current != null && !current.hasNextPage) {
      return;
    }

    _query = _query.copyWith(page: _query.page + 1);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadUsers);
  }

  Future<void> previousPage() async {
    if (_query.page <= 1) {
      return;
    }

    _query = _query.copyWith(page: _query.page - 1);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loadUsers);
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    final previousState = state;
    try {
      await ref.read(adminUserRepositoryProvider).createUser(userData);
      _query = _query.copyWith(page: 1);
      state = await AsyncValue.guard(_loadUsers);
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> userData) async {
    final previousState = state;
    try {
      await ref.read(adminUserRepositoryProvider).updateUser(id, userData);
      state = await AsyncValue.guard(_loadUsers);
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  Future<AdminPasswordResetResult> resetPassword(int id) async {
    final previousState = state;
    try {
      final result = await ref
          .read(adminUserRepositoryProvider)
          .resetPassword(id);
      state = await AsyncValue.guard(_loadUsers);
      return result;
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    final current = state.asData?.value;
    final previousState = state;
    try {
      await ref.read(adminUserRepositoryProvider).deleteUser(id);
      if ((current?.items.length ?? 0) <= 1 && _query.page > 1) {
        _query = _query.copyWith(page: _query.page - 1);
      }
      state = await AsyncValue.guard(_loadUsers);
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  Future<AdminReminderTriggerResult> triggerOpdReminder(int id) {
    return ref.read(adminUserRepositoryProvider).triggerOpdReminder(id);
  }

  Future<void> refreshUsers() =>
      fetchUsers(page: _query.page, search: _query.search);

  Future<PaginatedResponse<AppUser>> _loadUsers() {
    return ref
        .read(adminUserRepositoryProvider)
        .getUsers(
          page: _query.page,
          search: _query.search,
          sort: _query.sort,
          direction: _query.direction,
          perPage: _query.perPage,
        );
  }
}

final userAdminControllerProvider =
    AsyncNotifierProvider<UserAdminController, PaginatedResponse<AppUser>>(() {
      return UserAdminController();
    });
