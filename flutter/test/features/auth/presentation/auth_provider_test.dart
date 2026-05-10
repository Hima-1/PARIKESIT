import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parikesit/features/auth/data/auth_exceptions.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('AuthNotifier', () {
    test(
      'returns invalid credentials message when repository rejects login',
      () async {
        final repository = MockAuthRepository();
        when(
          () => repository.login('admin@gmail.com', 'salah'),
        ).thenThrow(InvalidCredentialsException());

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(repository),
            authNotifierProvider.overrideWith(
              () => AuthNotifier(repository, AuthState.unauthenticated()),
            ),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(authNotifierProvider.notifier)
            .login('admin@gmail.com', 'salah');

        final state = container.read(authNotifierProvider);
        expect(state.status, AuthStatus.unauthenticated);
        expect(state.errorMessage, 'Email atau password salah');
      },
    );

    test(
      'returns generic network message for login request exception',
      () async {
        final repository = MockAuthRepository();
        when(
          () => repository.login('admin@gmail.com', 'salah'),
        ).thenThrow(LoginRequestException());

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(repository),
            authNotifierProvider.overrideWith(
              () => AuthNotifier(repository, AuthState.unauthenticated()),
            ),
          ],
        );
        addTearDown(container.dispose);

        await container
            .read(authNotifierProvider.notifier)
            .login('admin@gmail.com', 'salah');

        final state = container.read(authNotifierProvider);
        expect(state.status, AuthStatus.unauthenticated);
        expect(state.errorMessage, 'Terjadi gangguan jaringan. Coba lagi.');
      },
    );

    test(
      'switches to unauthenticated immediately while repository logout continues',
      () async {
        final repository = MockAuthRepository();
        final completer = Completer<void>();
        when(repository.logout).thenAnswer((_) => completer.future);

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(repository),
            authNotifierProvider.overrideWith(
              () => AuthNotifier(repository, AuthState.authenticated(_user)),
            ),
          ],
        );
        addTearDown(container.dispose);

        final logoutFuture = container
            .read(authNotifierProvider.notifier)
            .logout();

        expect(
          container.read(authNotifierProvider).status,
          AuthStatus.unauthenticated,
        );
        verify(repository.logout).called(1);

        await expectLater(logoutFuture, completes);

        completer.complete();
        await Future<void>.delayed(Duration.zero);
      },
    );

    test('loads authenticated user during notifier initialization', () async {
      final repository = MockAuthRepository();
      final completer = Completer<User?>();
      when(repository.getUser).thenAnswer((_) => completer.future);

      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      expect(container.read(authNotifierProvider).status, AuthStatus.initial);

      completer.complete(_user);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, _user);
    });
  });
}

const _user = User(
  id: 1,
  name: 'Admin',
  email: 'admin@gmail.com',
  role: 'admin',
);
