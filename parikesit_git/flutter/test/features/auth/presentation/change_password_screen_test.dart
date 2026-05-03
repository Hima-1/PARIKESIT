import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/network/laravel_exceptions.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/change_password_screen.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/auth/presentation/profile_screen.dart';

void main() {
  group('ChangePasswordScreen', () {
    testWidgets('shows validation messages for empty or invalid fields', (
      tester,
    ) async {
      final router = _buildRouter();

      await tester.pumpWidget(
        _buildApp(
          router,
          repository: _SuccessAuthRepository(),
          notifier: _AuthenticatedAuthNotifier(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ubah Password'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('SIMPAN'));
      await tester.pump();

      expect(find.text('Password saat ini tidak boleh kosong'), findsOneWidget);
      expect(find.text('Password baru tidak boleh kosong'), findsOneWidget);
      expect(
        find.text('Konfirmasi password tidak boleh kosong'),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'password');
      await tester.enterText(find.byType(TextFormField).at(1), 'short');
      await tester.enterText(find.byType(TextFormField).at(2), 'short');
      await tester.tap(find.text('SIMPAN'));
      await tester.pump();

      expect(find.text('Password minimal 8 karakter'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(1), 'new-password');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'different-password',
      );
      await tester.tap(find.text('SIMPAN'));
      await tester.pump();

      expect(find.text('Password tidak cocok'), findsOneWidget);
    });

    testWidgets('submits password change payload and returns to profile', (
      tester,
    ) async {
      final repository = _SuccessAuthRepository();
      final router = _buildRouter();

      await tester.pumpWidget(
        _buildApp(
          router,
          repository: repository,
          notifier: _AuthenticatedAuthNotifier(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ubah Password'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        _user.passwordHint,
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'new-password');
      await tester.enterText(find.byType(TextFormField).at(2), 'new-password');
      await tester.tap(find.text('SIMPAN'));
      await tester.pumpAndSettle();

      expect(repository.lastPayload, isNotNull);
      expect(repository.lastPayload, containsPair('name', _user.name));
      expect(repository.lastPayload, containsPair('email', _user.email));
      expect(
        repository.lastPayload,
        containsPair('current_password', _user.passwordHint),
      );
      expect(repository.lastPayload, containsPair('password', 'new-password'));
      expect(
        repository.lastPayload,
        containsPair('password_confirmation', 'new-password'),
      );
      expect(find.text('Password berhasil diubah'), findsOneWidget);
      expect(find.text('Profil Pengguna'), findsOneWidget);
    });

    testWidgets(
      'shows mapped validation error when repository rejects update',
      (tester) async {
        final repository = _ValidationErrorAuthRepository();
        final router = _buildRouter();

        await tester.pumpWidget(
          _buildApp(
            router,
            repository: repository,
            notifier: _AuthenticatedAuthNotifier(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Ubah Password'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).at(0),
          _user.passwordHint,
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'new-password',
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'new-password',
        );
        await tester.tap(find.text('SIMPAN'));
        await tester.pumpAndSettle();

        expect(find.text('Password saat ini salah'), findsOneWidget);
      },
    );
  });
}

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: '/profile',
    routes: [
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'change-password',
            builder: (context, state) => const ChangePasswordScreen(),
          ),
        ],
      ),
    ],
  );
}

Widget _buildApp(
  GoRouter router, {
  required AuthRepository repository,
  required AuthNotifier notifier,
}) {
  return ProviderScope(
    overrides: [
      authNotifierProvider.overrideWith(() => notifier),
      authRepositoryProvider.overrideWithValue(repository),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

class _AuthenticatedAuthNotifier extends AuthNotifier {
  _AuthenticatedAuthNotifier()
    : super(_SuccessAuthRepository(), AuthState.authenticated(_user));
}

class _SuccessAuthRepository extends AuthRepository {
  _SuccessAuthRepository() : super(_FakeAuthApiClient(), _FakeTokenStorage());

  Map<String, dynamic>? lastPayload;

  @override
  Future<User?> getUser() async => _user;

  @override
  Future<User> updateProfile({
    required String name,
    required String email,
    String? alamat,
    String? nomorTelepon,
    String? currentPassword,
    String? password,
    String? passwordConfirmation,
  }) async {
    lastPayload = <String, dynamic>{
      'name': name,
      'email': email,
      'alamat': ?alamat,
      'nomor_telepon': ?nomorTelepon,
      'current_password': ?currentPassword,
      'password': ?password,
      'password_confirmation': ?passwordConfirmation,
    };

    return _user;
  }
}

class _ValidationErrorAuthRepository extends AuthRepository {
  _ValidationErrorAuthRepository()
    : super(_FakeAuthApiClient(), _FakeTokenStorage());

  @override
  Future<User?> getUser() async => _user;

  @override
  Future<User> updateProfile({
    required String name,
    required String email,
    String? alamat,
    String? nomorTelepon,
    String? currentPassword,
    String? password,
    String? passwordConfirmation,
  }) async {
    throw LaravelValidationException(
      message: 'The given data was invalid.',
      errors: {
        'current_password': ['Password saat ini salah'],
      },
    );
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

const _user = User(
  id: 1,
  name: 'Admin',
  email: 'admin@gmail.com',
  role: 'admin',
);

extension on User {
  String get passwordHint => 'password';
}
