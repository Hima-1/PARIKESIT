import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_sidebar.dart';
import 'package:parikesit/core/widgets/main_layout.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';

void main() {
  testWidgets(
    'MainLayout gives shell children a transparent scaffold background by default',
    (WidgetTester tester) async {
      Color? scaffoldBackgroundColor;
      Color? cardColor;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => MainLayout(
              child: Builder(
                builder: (context) {
                  scaffoldBackgroundColor = Theme.of(
                    context,
                  ).scaffoldBackgroundColor;
                  cardColor = Theme.of(context).cardTheme.color;
                  return const Scaffold(body: SizedBox.shrink());
                },
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authNotifierProvider.overrideWith(_FakeAuthNotifier.new)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(scaffoldBackgroundColor, Colors.transparent);
      expect(cardColor, AppTheme.surface);
    },
  );

  testWidgets('MainLayout uses mobile navigation when width is compact', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => MediaQuery(
            data: MediaQuery.of(context).copyWith(size: const Size(390, 844)),
            child: const MainLayout(child: SizedBox.shrink()),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(_AuthenticatedAuthNotifier.new),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppSidebar), findsNothing);
  });

  testWidgets('MainLayout uses sidebar navigation on larger width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => MediaQuery(
            data: MediaQuery.of(context).copyWith(size: const Size(1000, 844)),
            child: const MainLayout(child: SizedBox.shrink()),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(_AuthenticatedAuthNotifier.new),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppSidebar), findsOneWidget);
  });
}

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier() : super(_FakeAuthRepository());
}

class _AuthenticatedAuthNotifier extends AuthNotifier {
  _AuthenticatedAuthNotifier()
    : super(
        _FakeAuthRepository(),
        AuthState.authenticated(
          const User(
            id: 1,
            name: 'Admin',
            email: 'admin@example.com',
            role: 'admin',
          ),
        ),
      );
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository() : super(_FakeAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async => null;
}

class _FakeAuthApiClient implements AuthApiClient {
  @override
  Future<User> getUser() {
    throw UnimplementedError();
  }

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
  Future<String?> getToken() async => null;
}
