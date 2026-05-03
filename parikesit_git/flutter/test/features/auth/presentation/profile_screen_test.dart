import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/auth/presentation/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets(
      'shows logout tile instead of tentang aplikasi for authenticated user',
      (tester) async {
        await tester.pumpWidget(_buildApp(_AuthenticatedAuthNotifier()));
        await tester.pumpAndSettle();

        expect(find.text('Logout'), findsOneWidget);
        expect(find.text('Tentang Aplikasi'), findsNothing);
        expect(find.byIcon(Icons.logout), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsNothing);
        expect(find.text('Profil Pengguna'), findsOneWidget);
      },
    );

    testWidgets(
      'does not show missing user message while auth state is loading',
      (tester) async {
        await tester.pumpWidget(_buildApp(_LoadingAuthNotifier()));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Data pengguna tidak ditemukan.'), findsNothing);
      },
    );

    testWidgets(
      'does not show missing user message while unauthenticated redirect is pending',
      (tester) async {
        await tester.pumpWidget(_buildApp(_UnauthenticatedAuthNotifier()));
        await tester.pump();

        expect(find.text('Data pengguna tidak ditemukan.'), findsNothing);
        expect(find.byType(SizedBox), findsWidgets);
      },
    );

    testWidgets(
      'logout does not keep profile screen in loading state while repository logout is pending',
      (tester) async {
        final repository = _LogoutPendingAuthRepository();
        await tester.pumpWidget(
          _buildApp(_LogoutPendingAuthNotifier(repository)),
        );
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('Logout'));
        await tester.tap(find.text('Logout'));
        await tester.pumpAndSettle();

        expect(find.text('Keluar Aplikasi'), findsOneWidget);
        await tester.tap(find.text('Keluar').last);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Logout'), findsNothing);

        repository.completeLogout();
        await tester.pumpAndSettle();
      },
    );
  });
}

Widget _buildApp(AuthNotifier notifier) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const ProfileScreen()),
    ],
  );

  return ProviderScope(
    overrides: [authNotifierProvider.overrideWith(() => notifier)],
    child: MaterialApp.router(routerConfig: router),
  );
}

class _AuthenticatedAuthNotifier extends AuthNotifier {
  _AuthenticatedAuthNotifier()
    : super(_AuthenticatedAuthRepository(), AuthState.authenticated(_user));

  static const User _user = User(
    id: 1,
    name: 'Admin',
    email: 'admin@gmail.com',
    role: 'admin',
  );
}

class _LoadingAuthNotifier extends AuthNotifier {
  _LoadingAuthNotifier() : super(_LoadingAuthRepository(), AuthState.loading());
}

class _UnauthenticatedAuthNotifier extends AuthNotifier {
  _UnauthenticatedAuthNotifier()
    : super(_UnauthenticatedAuthRepository(), AuthState.unauthenticated());
}

class _LogoutPendingAuthNotifier extends AuthNotifier {
  _LogoutPendingAuthNotifier(AuthRepository repository)
    : super(repository, AuthState.authenticated(_user));

  static const User _user = User(
    id: 1,
    name: 'Admin',
    email: 'admin@gmail.com',
    role: 'admin',
  );
}

class _AuthenticatedAuthRepository extends AuthRepository {
  _AuthenticatedAuthRepository()
    : super(_FakeAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async => _AuthenticatedAuthNotifier._user;
}

class _LoadingAuthRepository extends AuthRepository {
  _LoadingAuthRepository() : super(_FakeAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() => Completer<User?>().future;
}

class _UnauthenticatedAuthRepository extends AuthRepository {
  _UnauthenticatedAuthRepository()
    : super(_FakeAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async => null;
}

class _LogoutPendingAuthRepository extends AuthRepository {
  _LogoutPendingAuthRepository()
    : super(_FakeAuthApiClient(), _FakeTokenStorage());

  final Completer<void> _logoutCompleter = Completer<void>();

  @override
  Future<User?> getUser() => Completer<User?>().future;

  @override
  Future<void> logout() async {
    await _logoutCompleter.future;
  }

  void completeLogout() {
    if (!_logoutCompleter.isCompleted) {
      _logoutCompleter.complete();
    }
  }
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
