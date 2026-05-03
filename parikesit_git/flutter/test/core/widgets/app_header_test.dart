import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/core/widgets/app_header.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/notifications/presentation/notification_controller.dart';

void main() {
  testWidgets('AppHeader shows notification icon for opd only', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(authNotifier: _FakeOpdAuthNotifier()),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    expect(find.text('O'), findsOneWidget);
  });

  testWidgets('AppHeader hides notification icon for walidata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(authNotifier: _FakeWalidataAuthNotifier()),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.notifications_outlined), findsNothing);
    expect(find.text('W'), findsOneWidget);
  });

  testWidgets('AppHeader hides notification icon for admin', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(authNotifier: _FakeAdminAuthNotifier()),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.notifications_outlined), findsNothing);
    expect(find.text('A'), findsOneWidget);
  });
}

Widget _buildTestApp({required AuthNotifier authNotifier}) {
  final router = GoRouter(
    initialLocation: RouteConstants.home,
    routes: [
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) =>
            const Scaffold(appBar: AppHeader(), body: SizedBox.shrink()),
      ),
      GoRoute(
        path: RouteConstants.notifications,
        builder: (context, state) =>
            const Scaffold(body: Text('Notifications')),
      ),
      GoRoute(
        path: RouteConstants.profile,
        builder: (context, state) => const Scaffold(body: Text('Profile')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authNotifierProvider.overrideWith(() => authNotifier),
      unreadNotificationCountProvider.overrideWith((ref) => 3),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

class _FakeAdminAuthNotifier extends AuthNotifier {
  _FakeAdminAuthNotifier() : super(_FakeAdminAuthRepository());
}

class _FakeOpdAuthNotifier extends AuthNotifier {
  _FakeOpdAuthNotifier() : super(_FakeOpdAuthRepository());
}

class _FakeWalidataAuthNotifier extends AuthNotifier {
  _FakeWalidataAuthNotifier() : super(_FakeWalidataAuthRepository());
}

class _FakeAdminAuthRepository extends AuthRepository {
  _FakeAdminAuthRepository()
    : super(_FakeAdminAuthApiClient(), _FakeTokenStorage());

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

class _FakeAdminAuthApiClient implements AuthApiClient {
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
