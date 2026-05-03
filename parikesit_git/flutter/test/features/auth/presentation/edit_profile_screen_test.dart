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
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/auth/presentation/edit_profile_screen.dart';
import 'package:parikesit/features/auth/presentation/profile_screen.dart';

void main() {
  testWidgets('shows mapped error message when edit profile update fails', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => const EditProfileScreen(),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _AuthenticatedAuthNotifier()),
          authRepositoryProvider.overrideWithValue(_ErrorAuthRepository()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Edit Profil'));
    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('SIMPAN'));
    await tester.tap(find.text('SIMPAN'));
    await tester.pumpAndSettle();

    expect(find.text('Email sudah digunakan'), findsOneWidget);
    expect(find.text('Profil berhasil diperbarui'), findsNothing);
  });
}

class _AuthenticatedAuthNotifier extends AuthNotifier {
  _AuthenticatedAuthNotifier()
    : super(_ErrorAuthRepository(), AuthState.authenticated(_user));
}

class _ErrorAuthRepository extends AuthRepository {
  _ErrorAuthRepository() : super(_FakeAuthApiClient(), _FakeTokenStorage());

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
        'email': ['Email sudah digunakan'],
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
