import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/admin/data/admin_user_repository.dart';
import 'package:parikesit/features/admin/domain/admin_password_reset_result.dart';
import 'package:parikesit/features/admin/presentation/controller/user_admin_controller.dart';

void main() {
  test('changing search resets page to first page and keeps query', () async {
    final repository = _FakeAdminUserRepository();
    final container = ProviderContainer(
      overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(userAdminControllerProvider.future);
    final notifier = container.read(userAdminControllerProvider.notifier);

    await notifier.nextPage();
    await notifier.setSearch('kominfo');

    final page = await container.read(userAdminControllerProvider.future);

    expect(page.meta.currentPage, 1);
    expect(repository.calls.last.search, 'kominfo');
    expect(repository.calls.last.page, 1);
  });

  test('changing sort refetches and nextPage stops at last page', () async {
    final repository = _FakeAdminUserRepository();
    final container = ProviderContainer(
      overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(userAdminControllerProvider.future);
    final notifier = container.read(userAdminControllerProvider.notifier);

    await notifier.setSort(UserSortField.name);
    await notifier.toggleSortDirection();
    await notifier.nextPage();
    await notifier.nextPage();
    await notifier.nextPage();

    expect(repository.calls[1].sort, UserSortField.name);
    expect(repository.calls[2].direction, SortDirection.asc);
    expect(repository.calls.last.page, 3);
  });

  test('trigger reminder forwards request to repository', () async {
    final repository = _FakeAdminUserRepository();
    final container = ProviderContainer(
      overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(userAdminControllerProvider.future);
    final notifier = container.read(userAdminControllerProvider.notifier);

    final result = await notifier.triggerOpdReminder(42);

    expect(repository.triggerReminderIds, [42]);
    expect(result.sent, 1);
    expect(result.incompleteFormCount, 1);
  });

  test('createUser saves data and reloads first page without error', () async {
    final repository = _FakeAdminUserRepository();
    final container = ProviderContainer(
      overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(userAdminControllerProvider.future);
    final notifier = container.read(userAdminControllerProvider.notifier);

    await notifier.nextPage();
    await notifier.createUser({
      'name': 'Admin Baru',
      'email': 'baru@example.com',
      'password': 'password123',
      'role': 'admin',
      'nomor_telepon': '08123',
      'alamat': 'Klaten',
    });

    final state = container.read(userAdminControllerProvider);

    expect(repository.createdUsers, hasLength(1));
    expect(repository.calls.last.page, 1);
    expect(state.hasError, isFalse);
    expect(state.requireValue.meta.currentPage, 1);
  });

  test('updateUser reloads list and keeps state as data', () async {
    final repository = _FakeAdminUserRepository();
    final container = ProviderContainer(
      overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(userAdminControllerProvider.future);
    final notifier = container.read(userAdminControllerProvider.notifier);

    await notifier.nextPage();
    await notifier.updateUser(7, {
      'name': 'Nama Baru',
      'email': 'baru@example.com',
      'role': 'walidata',
      'nomor_telepon': '08123',
      'alamat': 'Alamat Baru',
    });

    final state = container.read(userAdminControllerProvider);

    expect(repository.updatedUsers, hasLength(1));
    expect(repository.calls.last.page, 2);
    expect(state.hasError, isFalse);
    expect(state.requireValue.meta.currentPage, 2);
  });

  test('createUser failure keeps previous list state', () async {
    final repository = _FakeAdminUserRepository()..createShouldFail = true;
    final container = ProviderContainer(
      overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final initial = await container.read(userAdminControllerProvider.future);
    final notifier = container.read(userAdminControllerProvider.notifier);

    await expectLater(
      notifier.createUser({
        'name': 'Admin Baru',
        'email': 'baru@example.com',
        'password': 'password123',
        'role': 'admin',
        'nomor_telepon': '08123',
        'alamat': 'Klaten',
      }),
      throwsException,
    );

    final state = container.read(userAdminControllerProvider);

    expect(state.hasError, isFalse);
    expect(state.requireValue, initial);
  });

  test('resetPassword returns result and reloads the current page', () async {
    final repository = _FakeAdminUserRepository();
    final container = ProviderContainer(
      overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(userAdminControllerProvider.future);
    final notifier = container.read(userAdminControllerProvider.notifier);

    await notifier.nextPage();
    final result = await notifier.resetPassword(17);
    final state = container.read(userAdminControllerProvider);

    expect(repository.resetPasswordIds, [17]);
    expect(result.temporaryPassword, 'TempPass#123456');
    expect(repository.calls.last.page, 2);
    expect(state.hasError, isFalse);
    expect(state.requireValue.meta.currentPage, 2);
  });
}

class _FakeAdminUserRepository implements IAdminUserRepository {
  final List<_UserCall> calls = <_UserCall>[];
  final List<int> triggerReminderIds = <int>[];
  final List<int> resetPasswordIds = <int>[];
  final List<Map<String, dynamic>> createdUsers = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> updatedUsers = <Map<String, dynamic>>[];
  bool createShouldFail = false;

  @override
  Future<PaginatedResponse<AppUser>> getUsers({
    int page = 1,
    String? search,
    UserSortField? sort,
    SortDirection? direction,
    int? perPage,
  }) async {
    calls.add(
      _UserCall(
        page: page,
        search: search ?? '',
        sort: sort ?? UserSortField.createdAt,
        direction: direction ?? SortDirection.desc,
        perPage: perPage ?? 15,
      ),
    );

    return PaginatedResponse<AppUser>(
      data: <AppUser>[
        AppUser(
          id: page,
          name: search?.isEmpty ?? true ? 'User $page' : 'Hasil $search',
          email: 'user$page@example.com',
          role: 'admin',
        ),
      ],
      meta: PaginationMeta(
        currentPage: page,
        lastPage: 3,
        perPage: perPage ?? 15,
        total: 40,
        path: 'http://localhost/api/users',
      ),
      links: PaginationLinks(
        first: 'http://localhost/api/users?page=1',
        last: 'http://localhost/api/users?page=3',
        prev: page > 1 ? 'http://localhost/api/users?page=${page - 1}' : null,
        next: page < 3 ? 'http://localhost/api/users?page=${page + 1}' : null,
      ),
    );
  }

  @override
  Future<AppUser> createUser(Map<String, dynamic> userData) async {
    if (createShouldFail) {
      throw Exception('create failed');
    }
    createdUsers.add(Map<String, dynamic>.from(userData));
    return AppUser(
      id: 99,
      name: userData['name'] as String,
      email: userData['email'] as String,
      role: userData['role'] as String,
      nomorTelepon: userData['nomor_telepon'] as String?,
      alamat: userData['alamat'] as String?,
    );
  }

  @override
  Future<void> deleteUser(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<AdminPasswordResetResult> resetPassword(int id) async {
    resetPasswordIds.add(id);
    return const AdminPasswordResetResult(temporaryPassword: 'TempPass#123456');
  }

  @override
  Future<AdminReminderTriggerResult> triggerOpdReminder(int id) async {
    triggerReminderIds.add(id);
    return const AdminReminderTriggerResult(
      sent: 1,
      skipped: 0,
      incompleteFormCount: 1,
      message: 'Reminder diproses.',
    );
  }

  @override
  Future<AppUser> updateUser(int id, Map<String, dynamic> userData) async {
    updatedUsers.add({'id': id, ...Map<String, dynamic>.from(userData)});
    return AppUser(
      id: id,
      name: userData['name'] as String,
      email: userData['email'] as String,
      role: userData['role'] as String,
      nomorTelepon: userData['nomor_telepon'] as String?,
      alamat: userData['alamat'] as String?,
    );
  }
}

class _UserCall {
  const _UserCall({
    required this.page,
    required this.search,
    required this.sort,
    required this.direction,
    required this.perPage,
  });

  final int page;
  final String search;
  final UserSortField sort;
  final SortDirection direction;
  final int perPage;
}
