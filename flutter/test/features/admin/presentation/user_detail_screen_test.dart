import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/admin/data/admin_user_repository.dart';
import 'package:parikesit/features/admin/domain/admin_password_reset_result.dart';
import 'package:parikesit/features/admin/presentation/user_detail_screen.dart';

void main() {
  testWidgets('shows reminder button only for opd user', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _buildApp(
        user: const AppUser(
          id: 1,
          name: 'OPD User',
          email: 'opd@example.com',
          role: 'opd',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kirim Reminder'), findsOneWidget);

    await tester.pumpWidget(
      _buildApp(
        user: const AppUser(
          id: 2,
          name: 'Admin User',
          email: 'admin@example.com',
          role: 'admin',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kirim Reminder'), findsNothing);
  });

  testWidgets('trigger reminder uses admin repository action', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(
      _buildApp(
        user: const AppUser(
          id: 1,
          name: 'OPD User',
          email: 'opd@example.com',
          role: 'opd',
        ),
        repository: repository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Kirim Reminder'));
    await tester.tap(find.text('Kirim Reminder'));
    await tester.pumpAndSettle();

    expect(repository.triggeredUserIds, [1]);
    expect(find.text('Reminder manual diproses.'), findsOneWidget);
  });

  testWidgets('reset password flow shows temporary password dialog', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(
      _buildApp(
        user: const AppUser(
          id: 2,
          name: 'Admin User',
          email: 'admin@example.com',
          role: 'admin',
        ),
        repository: repository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Reset Password'));
    await tester.tap(find.text('Reset Password'));
    await tester.pumpAndSettle();

    expect(find.text('RESET PASSWORD'), findsOneWidget);

    await tester.tap(find.byKey(const Key('admin-user-form-submit')));
    await tester.pumpAndSettle();

    expect(repository.resetPasswordIds, [2]);
    expect(find.text('PASSWORD SEMENTARA'), findsOneWidget);
    expect(find.text('TempPass#123456'), findsOneWidget);
  });
}

Widget _buildApp({required AppUser user, AdminUserRepository? repository}) {
  return ProviderScope(
    overrides: [
      adminUserRepositoryProvider.overrideWithValue(
        repository ?? _FakeAdminUserRepository(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: UserDetailScreen(user: user),
    ),
  );
}

class _FakeAdminUserRepository implements AdminUserRepository {
  final List<int> triggeredUserIds = <int>[];
  final List<int> resetPasswordIds = <int>[];

  @override
  Future<AppUser> createUser(Map<String, dynamic> userData) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(int id) async {}

  @override
  Future<PaginatedResponse<AppUser>> getUsers({
    int page = 1,
    String? search,
    UserSortField? sort,
    SortDirection? direction,
    int? perPage,
  }) async {
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
  Future<AdminPasswordResetResult> resetPassword(int id) async {
    resetPasswordIds.add(id);
    return const AdminPasswordResetResult(temporaryPassword: 'TempPass#123456');
  }

  @override
  Future<AdminReminderTriggerResult> triggerOpdReminder(int id) async {
    triggeredUserIds.add(id);
    return const AdminReminderTriggerResult(
      sent: 1,
      skipped: 0,
      incompleteFormCount: 2,
      message: 'Reminder manual diproses.',
    );
  }

  @override
  Future<AppUser> updateUser(int id, Map<String, dynamic> userData) async {
    throw UnimplementedError();
  }
}
