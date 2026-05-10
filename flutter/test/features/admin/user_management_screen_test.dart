import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/admin/data/admin_user_repository.dart';
import 'package:parikesit/features/admin/domain/admin_password_reset_result.dart';
import 'package:parikesit/features/admin/presentation/controller/user_admin_controller.dart';
import 'package:parikesit/features/admin/presentation/user_management_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders user management controls and pagination footer', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(412, 915));
    final repository = _FakeAdminUserRepository(
      users: [
        _user(
          id: 1,
          name: 'Admin One',
          email: 'admin1@example.com',
          role: 'admin',
        ),
        _user(
          id: 2,
          name: 'Walidata One',
          email: 'walidata1@example.com',
          role: 'walidata',
        ),
      ],
    );

    await tester.pumpWidget(_buildApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Manajemen User'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
    expect(find.byType(BackButton), findsNothing);
    expect(find.byKey(const Key('admin-user-add')), findsOneWidget);
    expect(find.byKey(const Key('admin-user-sort-field')), findsOneWidget);
    expect(
      find.byKey(const Key('admin-user-toggle-sort-direction')),
      findsOneWidget,
    );
    expect(find.byType(PaginatedDataTable), findsNothing);
    expect(find.text('Halaman 1 dari 2'), findsOneWidget);
  });

  testWidgets('debounces realtime search and restores full list when cleared', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(412, 915));
    final repository = _FakeAdminUserRepository(
      users: [
        _user(
          id: 1,
          name: 'Admin One',
          email: 'admin1@example.com',
          role: 'admin',
        ),
        _user(id: 2, name: 'Budi', email: 'budi@example.com', role: 'opd'),
      ],
    );

    await tester.pumpWidget(_buildApp(repository: repository));
    await tester.pumpAndSettle();

    expect(repository.calls.single.search, '');

    await tester.enterText(find.byKey(const Key('admin-user-search')), 'budi');
    await tester.pump(const Duration(milliseconds: 200));

    expect(repository.calls, hasLength(1));

    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump();

    expect(repository.calls.last.search, 'budi');
    expect(repository.calls.last.page, 1);

    await tester.enterText(find.byKey(const Key('admin-user-search')), '');
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();

    expect(repository.calls.last.search, '');
  });

  testWidgets('updates sort and paginates through footer actions', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(412, 915));
    final repository = _FakeAdminUserRepository(
      users: [
        _user(id: 1, name: 'Charlie', email: 'c@example.com', role: 'admin'),
        _user(id: 2, name: 'Alpha', email: 'a@example.com', role: 'opd'),
      ],
      lastPage: 3,
    );

    await tester.pumpWidget(_buildApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('admin-user-sort-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nama').last);
    await tester.pumpAndSettle();

    expect(repository.calls.last.sort, UserSortField.name);
    expect(repository.calls.last.page, 1);

    await tester.tap(find.byKey(const Key('admin-user-toggle-sort-direction')));
    await tester.pumpAndSettle();

    expect(repository.calls.last.direction, SortDirection.asc);

    await tester.tap(find.byTooltip('Halaman berikutnya'));
    await tester.pumpAndSettle();

    expect(repository.calls.last.page, 2);
    expect(find.text('Halaman 2 dari 3'), findsOneWidget);
  });

  testWidgets('shows empty search state when no users match query', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(412, 915));
    final repository = _FakeAdminUserRepository(
      users: [
        _user(
          id: 1,
          name: 'Admin One',
          email: 'admin1@example.com',
          role: 'admin',
        ),
      ],
    );

    await tester.pumpWidget(_buildApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('admin-user-search')), 'xyz');
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();

    expect(find.text('Tidak ada user yang cocok.'), findsOneWidget);
    expect(
      find.text('Coba ubah kata kunci pencarian untuk menemukan pengguna.'),
      findsOneWidget,
    );
  });

  testWidgets('shows friendly empty state when user list is empty', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(412, 915));
    final repository = _FakeAdminUserRepository(users: const []);

    await tester.pumpWidget(_buildApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada pengguna.'), findsOneWidget);
    expect(
      find.text('Tambahkan akun baru untuk Admin, Walidata, atau OPD.'),
      findsOneWidget,
    );
  });

  testWidgets('sanitizes invalid role labels in user cards', (tester) async {
    _setSurfaceSize(tester, const Size(412, 915));
    final repository = _FakeAdminUserRepository(
      users: [
        _user(
          id: 3,
          name: 'Role Invalid',
          email: 'invalid@example.com',
          role: 'unknown',
        ),
      ],
    );

    await tester.pumpWidget(_buildApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('UNKNOWN'), findsNothing);
    expect(find.text('ROLE TIDAK VALID'), findsOneWidget);
  });

  testWidgets('shows retryable error state when fetch fails', (tester) async {
    _setSurfaceSize(tester, const Size(412, 915));
    final container = ProviderContainer(
      overrides: [
        userAdminControllerProvider.overrideWith(ErrorUserAdminController.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const UserManagementScreen(),
        ),
      ),
    );

    await tester.pump();
    await container.read(userAdminControllerProvider.notifier).fetchUsers();
    await tester.pump();

    expect(find.text('Gagal memuat data pengguna.'), findsOneWidget);
    expect(find.text('Coba Lagi'), findsOneWidget);
  });

  testWidgets('shows loading placeholders while waiting for data', (
    tester,
  ) async {
    _setSurfaceSize(tester, const Size(412, 915));
    final completer = Completer<PaginatedResponse<AppUser>>();
    final repository = _FakeAdminUserRepository(completer: completer);

    await tester.pumpWidget(_buildApp(repository: repository));
    await tester.pump();

    expect(find.byKey(const Key('admin-user-loading')), findsOneWidget);
    expect(find.byKey(const Key('admin-user-loading-card-0')), findsOneWidget);

    completer.complete(
      PaginatedResponse<AppUser>(
        data: [
          _user(
            id: 1,
            name: 'Admin One',
            email: 'admin1@example.com',
            role: 'admin',
          ),
        ],
        meta: const PaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: 15,
          total: 1,
          path: 'http://localhost/api/users',
        ),
        links: const PaginationLinks(first: '', last: ''),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Admin One'), findsOneWidget);
  });
}

Widget _buildApp({required _FakeAdminUserRepository repository}) {
  return ProviderScope(
    overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: const UserManagementScreen(),
    ),
  );
}

void _setSurfaceSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
}

AppUser _user({
  required int id,
  required String name,
  required String email,
  required String role,
}) {
  return AppUser(id: id, name: name, email: email, role: role);
}

class _FakeAdminUserRepository implements AdminUserRepository {
  _FakeAdminUserRepository({
    this.users = const [],
    this.completer,
    this.lastPage = 2,
  });

  final List<AppUser> users;
  final Completer<PaginatedResponse<AppUser>>? completer;
  final int lastPage;
  final List<_UserCall> calls = [];

  @override
  Future<PaginatedResponse<AppUser>> getUsers({
    int page = 1,
    String? search,
    UserSortField? sort,
    SortDirection? direction,
    int? perPage,
  }) async {
    final normalizedSearch = (search ?? '').trim();
    calls.add(
      _UserCall(
        page: page,
        search: normalizedSearch,
        sort: sort ?? UserSortField.createdAt,
        direction: direction ?? SortDirection.desc,
      ),
    );

    if (completer != null) {
      return completer!.future;
    }
    final filtered = normalizedSearch.isEmpty
        ? users
        : users.where((user) {
            final query = normalizedSearch.toLowerCase();
            return user.name.toLowerCase().contains(query) ||
                user.email.toLowerCase().contains(query);
          }).toList();

    final sorted = [...filtered];
    switch (sort ?? UserSortField.createdAt) {
      case UserSortField.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case UserSortField.email:
        sorted.sort((a, b) => a.email.compareTo(b.email));
      case UserSortField.role:
        sorted.sort((a, b) => a.role.compareTo(b.role));
      case UserSortField.createdAt:
        sorted.sort((a, b) => a.id.compareTo(b.id));
    }

    if ((direction ?? SortDirection.desc) == SortDirection.desc) {
      sorted.setAll(0, sorted.reversed);
    }

    return PaginatedResponse<AppUser>(
      data: sorted,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: lastPage,
        perPage: perPage ?? 15,
        total: sorted.length,
        path: 'http://localhost/api/users',
      ),
      links: PaginationLinks(
        first: 'http://localhost/api/users?page=1',
        last: 'http://localhost/api/users?page=$lastPage',
        prev: page > 1 ? 'http://localhost/api/users?page=${page - 1}' : null,
        next: page < lastPage
            ? 'http://localhost/api/users?page=${page + 1}'
            : null,
      ),
    );
  }

  @override
  Future<AppUser> createUser(Map<String, dynamic> userData) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(int id) {
    throw UnimplementedError();
  }

  @override
  Future<AdminPasswordResetResult> resetPassword(int id) {
    throw UnimplementedError();
  }

  @override
  Future<AdminReminderTriggerResult> triggerOpdReminder(int id) async {
    return const AdminReminderTriggerResult(
      sent: 1,
      skipped: 0,
      incompleteFormCount: 1,
      message: 'Reminder diproses.',
    );
  }

  @override
  Future<AppUser> updateUser(int id, Map<String, dynamic> userData) {
    throw UnimplementedError();
  }
}

class ErrorUserAdminController extends UserAdminController {
  @override
  Future<PaginatedResponse<AppUser>> build() async {
    return const PaginatedResponse<AppUser>(
      data: <AppUser>[],
      meta: PaginationMeta(
        currentPage: 1,
        lastPage: 1,
        perPage: 15,
        total: 0,
        path: 'http://localhost/api/users',
      ),
      links: PaginationLinks(first: '', last: ''),
    );
  }

  @override
  Future<void> fetchUsers({int page = 1, String? search}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<PaginatedResponse<AppUser>>(() async {
      throw Exception('boom');
    });
  }
}

class _UserCall {
  const _UserCall({
    required this.page,
    required this.search,
    required this.sort,
    required this.direction,
  });

  final int page;
  final String search;
  final UserSortField sort;
  final SortDirection direction;
}
