import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/core/widgets/app_bottom_nav.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';

void main() {
  testWidgets('admin dokumentasi bottom nav goes to admin dokumentasi route', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: RouteConstants.adminDashboard,
      routes: [
        GoRoute(
          path: RouteConstants.adminDashboard,
          builder: (context, state) => const Scaffold(
            body: Text('Admin Dashboard'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
        GoRoute(
          path: RouteConstants.adminDokumentasi,
          builder: (context, state) => const Scaffold(
            body: Text('Admin Dokumentasi'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
        GoRoute(
          path: RouteConstants.adminUsers,
          builder: (context, state) => const Scaffold(
            body: Text('Admin Users'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
        GoRoute(
          path: RouteConstants.assessmentSelesai,
          builder: (context, state) => const Scaffold(
            body: Text('Penilaian'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _FakeAdminAuthNotifier()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();
    await _tapBottomNavLabel(tester, 'DOKUMENTASI');

    expect(find.text('Admin Dokumentasi'), findsOneWidget);
  });

  testWidgets('OPD dokumentasi bottom nav goes to dokumentasi kegiatan route', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: RouteConstants.home,
      routes: [
        GoRoute(
          path: RouteConstants.home,
          builder: (context, state) => const Scaffold(
            body: Text('Home'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
        GoRoute(
          path: RouteConstants.assessmentMandiri,
          builder: (context, state) => const Scaffold(
            body: Text('Formulir'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
        GoRoute(
          path: RouteConstants.assessmentSelesai,
          builder: (context, state) => const Scaffold(
            body: Text('Penilaian'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
        GoRoute(
          path: RouteConstants.dokumentasiKegiatan,
          builder: (context, state) => const Scaffold(
            body: Text('Dokumentasi Kegiatan'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _FakeOpdAuthNotifier()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('FORMULIR'), findsOneWidget);
    await _tapBottomNavLabel(tester, 'KEGIATAN');

    expect(find.text('Dokumentasi Kegiatan'), findsWidgets);
  });

  testWidgets('walidata bottom nav only shows valid items', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: RouteConstants.home,
      routes: [
        GoRoute(
          path: RouteConstants.home,
          builder: (context, state) => const Scaffold(
            body: Text('Home'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
        GoRoute(
          path: RouteConstants.assessmentSelesai,
          builder: (context, state) => const Scaffold(
            body: Text('Penilaian'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
        GoRoute(
          path: RouteConstants.dokumentasiKegiatan,
          builder: (context, state) => const Scaffold(
            body: Text('Dokumentasi Kegiatan'),
            bottomNavigationBar: AppBottomNav(),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _FakeWalidataAuthNotifier()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('BERANDA'), findsOneWidget);
    expect(find.text('PENILAIAN'), findsOneWidget);
    expect(find.text('KEGIATAN'), findsOneWidget);
    expect(find.text('KOREKSI'), findsNothing);
  });
}

Future<void> _tapBottomNavLabel(WidgetTester tester, String label) async {
  final bottomNavFinder = find.byType(BottomNavigationBar);
  final labelFinder = find.descendant(
    of: bottomNavFinder,
    matching: find.text(label),
  );

  expect(labelFinder, findsOneWidget);

  await tester.tap(labelFinder);
  await tester.pumpAndSettle();
}

class _FakeAdminAuthNotifier extends AuthNotifier {
  _FakeAdminAuthNotifier() : super(_FakeAuthRepository());
}

class _FakeOpdAuthNotifier extends AuthNotifier {
  _FakeOpdAuthNotifier() : super(_FakeOpdAuthRepository());
}

class _FakeWalidataAuthNotifier extends AuthNotifier {
  _FakeWalidataAuthNotifier() : super(_FakeWalidataAuthRepository());
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository() : super(_FakeAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async => const User(
    id: 1,
    name: 'Admin',
    email: 'admin@example.com',
    role: 'admin',
  );
}

class _FakeOpdAuthRepository extends AuthRepository {
  _FakeOpdAuthRepository()
    : super(_FakeOpdAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async =>
      const User(id: 2, name: 'OPD', email: 'opd@example.com', role: 'opd');
}

class _FakeWalidataAuthRepository extends AuthRepository {
  _FakeWalidataAuthRepository()
    : super(_FakeWalidataAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async => const User(
    id: 3,
    name: 'Walidata',
    email: 'walidata@example.com',
    role: 'walidata',
  );
}

class _FakeAuthApiClient implements AuthApiClient {
  @override
  Future<User> getUser() async => const User(
    id: 1,
    name: 'Admin',
    email: 'admin@example.com',
    role: 'admin',
  );

  @override
  Future<LoginResponse> login(Map<String, dynamic> credentials) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<dynamic> updateProfile(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}

class _FakeOpdAuthApiClient implements AuthApiClient {
  @override
  Future<User> getUser() async =>
      const User(id: 2, name: 'OPD', email: 'opd@example.com', role: 'opd');

  @override
  Future<LoginResponse> login(Map<String, dynamic> credentials) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<dynamic> updateProfile(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}

class _FakeWalidataAuthApiClient implements AuthApiClient {
  @override
  Future<User> getUser() async => const User(
    id: 3,
    name: 'Walidata',
    email: 'walidata@example.com',
    role: 'walidata',
  );

  @override
  Future<LoginResponse> login(Map<String, dynamic> credentials) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<dynamic> updateProfile(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}

class _FakeTokenStorage extends TokenStorage {
  _FakeTokenStorage() : super(const FlutterSecureStorage());

  @override
  Future<String?> getToken() async => 'token';
}
