import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/admin/data/admin_user_repository.dart';
import 'package:parikesit/features/admin/domain/admin_password_reset_result.dart';
import 'package:parikesit/features/admin/presentation/widgets/user_form_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create form requires complete data for all roles', (
    tester,
  ) async {
    _setSurfaceSize(tester);
    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('admin-user-form-submit')));
    await tester.tap(find.byKey(const Key('admin-user-form-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Nama wajib diisi'), findsOneWidget);
    expect(find.text('Email tidak valid'), findsOneWidget);
    expect(find.text('Password minimal 8 karakter'), findsOneWidget);
    expect(find.text('Nomor telepon wajib diisi'), findsOneWidget);
    expect(find.text('Alamat wajib diisi'), findsOneWidget);
    expect(repository.createdUsers, isEmpty);
  });

  testWidgets('create form trims non-password payload before submit', (
    tester,
  ) async {
    _setSurfaceSize(tester);
    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('admin-user-form-name')),
      '  Admin Baru  ',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-email')),
      '  adminbaru@example.com  ',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-password')),
      '  password123  ',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-phone')),
      '  08123456789  ',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-address')),
      '  Kantor Pusat  ',
    );

    await tester.ensureVisible(find.byKey(const Key('admin-user-form-submit')));
    await tester.tap(find.byKey(const Key('admin-user-form-submit')));
    await tester.pumpAndSettle();

    expect(repository.createdUsers, hasLength(1));
    expect(repository.createdUsers.single, {
      'name': 'Admin Baru',
      'email': 'adminbaru@example.com',
      'password': '  password123  ',
      'role': 'opd',
      'nomor_telepon': '08123456789',
      'alamat': 'Kantor Pusat',
    });
  });

  testWidgets('edit form requires complete data for non-opd roles too', (
    tester,
  ) async {
    _setSurfaceSize(tester);
    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(
      _buildApp(
        repository,
        user: const AppUser(
          id: 7,
          name: 'Walidata',
          email: 'wali@example.com',
          role: 'walidata',
          nomorTelepon: '0811111111',
          alamat: 'Alamat lama',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('admin-user-form-phone')),
      '   ',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-address')),
      '   ',
    );

    await tester.ensureVisible(find.byKey(const Key('admin-user-form-submit')));
    await tester.tap(find.byKey(const Key('admin-user-form-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Nomor telepon wajib diisi'), findsOneWidget);
    expect(find.text('Alamat wajib diisi'), findsOneWidget);
    expect(repository.updatedUsers, isEmpty);
  });

  testWidgets('create form shows success snackbar after submit', (
    tester,
  ) async {
    _setSurfaceSize(tester);
    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('admin-user-form-name')),
      'Admin Baru',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-email')),
      'adminbaru@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-password')),
      'password123',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-phone')),
      '08123456789',
    );
    await tester.enterText(
      find.byKey(const Key('admin-user-form-address')),
      'Kantor Pusat',
    );

    await tester.ensureVisible(find.byKey(const Key('admin-user-form-submit')));
    await tester.tap(find.byKey(const Key('admin-user-form-submit')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('User berhasil ditambahkan.'), findsOneWidget);
  });

  testWidgets('role dropdown only shows assignable roles', (tester) async {
    _setSurfaceSize(tester);
    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(_buildApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('admin-user-form-role')));
    await tester.pumpAndSettle();

    expect(find.text('ADMIN'), findsOneWidget);
    expect(find.text('WALIDATA'), findsOneWidget);
    expect(find.text('OPD'), findsWidgets);
    expect(find.text(UserRole.unknown.name.toUpperCase()), findsNothing);
  });

  testWidgets('edit form falls back to opd when stored role is invalid', (
    tester,
  ) async {
    _setSurfaceSize(tester);
    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(
      _buildApp(
        repository,
        user: const AppUser(
          id: 9,
          name: 'Role Invalid',
          email: 'invalid@example.com',
          role: 'unknown',
          nomorTelepon: '08123456789',
          alamat: 'Alamat',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('UNKNOWN'), findsNothing);
    expect(find.text('OPD'), findsOneWidget);

    await tester.tap(find.byKey(const Key('admin-user-form-role')));
    await tester.pumpAndSettle();

    expect(find.text('ADMIN'), findsOneWidget);
    expect(find.text('WALIDATA'), findsOneWidget);
    expect(find.text('OPD'), findsWidgets);
    expect(find.text('UNKNOWN'), findsNothing);
  });

  testWidgets(
    'create form keeps dialog open and shows error snackbar on failure',
    (tester) async {
      _setSurfaceSize(tester);
      final repository = _FakeAdminUserRepository(createShouldFail: true);
      await tester.pumpWidget(_buildApp(repository));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('admin-user-form-name')),
        'Admin Gagal',
      );
      await tester.enterText(
        find.byKey(const Key('admin-user-form-email')),
        'gagal@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('admin-user-form-password')),
        'password123',
      );
      await tester.enterText(
        find.byKey(const Key('admin-user-form-phone')),
        '08123456789',
      );
      await tester.enterText(
        find.byKey(const Key('admin-user-form-address')),
        'Kantor Pusat',
      );

      await tester.ensureVisible(
        find.byKey(const Key('admin-user-form-submit')),
      );
      await tester.tap(find.byKey(const Key('admin-user-form-submit')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Gagal menambahkan user.'), findsOneWidget);
      expect(find.byType(UserFormDialog), findsOneWidget);
    },
  );

  testWidgets('reset password shows temporary password result dialog', (
    tester,
  ) async {
    _setSurfaceSize(tester);
    final repository = _FakeAdminUserRepository();
    await tester.pumpWidget(
      _buildApp(
        repository,
        user: const AppUser(
          id: 7,
          name: 'Walidata',
          email: 'wali@example.com',
          role: 'walidata',
        ),
        isResetPassword: true,
        presentAsDialog: true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('admin-user-form-submit')));
    await tester.pumpAndSettle();

    expect(repository.resetPasswordIds, [7]);
    expect(find.text('PASSWORD SEMENTARA'), findsOneWidget);
    expect(find.text('TempPass#123456'), findsOneWidget);
    expect(
      find.byKey(const Key('admin-user-reset-password-value')),
      findsOneWidget,
    );
    expect(find.byType(UserFormDialog), findsNothing);
  });

  testWidgets('reset password copy button copies password and shows snackbar', (
    tester,
  ) async {
    _setSurfaceSize(tester);
    final repository = _FakeAdminUserRepository();
    String? copiedText;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copiedText = (call.arguments as Map)['text'] as String?;
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    await tester.pumpWidget(
      _buildApp(
        repository,
        user: const AppUser(
          id: 8,
          name: 'Admin',
          email: 'admin@example.com',
          role: 'admin',
        ),
        isResetPassword: true,
        presentAsDialog: true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('admin-user-form-submit')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('admin-user-reset-password-copy')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(copiedText, 'TempPass#123456');
    expect(find.text('Password sementara berhasil disalin.'), findsOneWidget);
  });

  testWidgets(
    'reset password failure keeps dialog open and shows error snackbar',
    (tester) async {
      _setSurfaceSize(tester);
      final repository = _FakeAdminUserRepository(resetShouldFail: true);
      await tester.pumpWidget(
        _buildApp(
          repository,
          user: const AppUser(
            id: 11,
            name: 'OPD',
            email: 'opd@example.com',
            role: 'opd',
          ),
          isResetPassword: true,
          presentAsDialog: true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('admin-user-form-submit')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Gagal mereset password user.'), findsOneWidget);
      expect(find.byType(UserFormDialog), findsOneWidget);
      expect(find.text('PASSWORD SEMENTARA'), findsNothing);
    },
  );
}

void _setSurfaceSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _buildApp(
  _FakeAdminUserRepository repository, {
  AppUser? user,
  bool isResetPassword = false,
  bool presentAsDialog = false,
}) {
  final dialog = UserFormDialog(user: user, isResetPassword: isResetPassword);

  return ProviderScope(
    overrides: [adminUserRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: presentAsDialog
          ? _DialogTestHost(dialog: dialog)
          : Scaffold(body: dialog),
    ),
  );
}

class _DialogTestHost extends StatefulWidget {
  const _DialogTestHost({required this.dialog});

  final Widget dialog;

  @override
  State<_DialogTestHost> createState() => _DialogTestHostState();
}

class _DialogTestHostState extends State<_DialogTestHost> {
  bool _opened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_opened) {
      return;
    }
    _opened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      showDialog<void>(context: context, builder: (_) => widget.dialog);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}

class _FakeAdminUserRepository implements AdminUserRepository {
  _FakeAdminUserRepository({
    this.createShouldFail = false,
    this.resetShouldFail = false,
  });

  final List<Map<String, dynamic>> createdUsers = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> updatedUsers = <Map<String, dynamic>>[];
  final List<int> resetPasswordIds = <int>[];
  final bool createShouldFail;
  final bool resetShouldFail;
  final AdminPasswordResetResult resetPasswordResult =
      const AdminPasswordResetResult(temporaryPassword: 'TempPass#123456');

  @override
  Future<AppUser> createUser(Map<String, dynamic> userData) async {
    if (createShouldFail) {
      throw Exception('create failed');
    }
    createdUsers.add(Map<String, dynamic>.from(userData));
    return AppUser(
      id: 1,
      name: userData['name'] as String,
      email: userData['email'] as String,
      role: userData['role'] as String,
      nomorTelepon: userData['nomor_telepon'] as String?,
      alamat: userData['alamat'] as String?,
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
    if (resetShouldFail) {
      throw Exception('reset failed');
    }
    return resetPasswordResult;
  }

  @override
  Future<void> deleteUser(int id) async {}

  @override
  Future<AdminReminderTriggerResult> triggerOpdReminder(int id) async {
    return const AdminReminderTriggerResult(
      sent: 0,
      skipped: 0,
      incompleteFormCount: 0,
      message: 'noop',
    );
  }
}
