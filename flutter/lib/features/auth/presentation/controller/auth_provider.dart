import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/utils/startup_probe.dart';
import 'package:parikesit/features/auth/data/auth_exceptions.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({required this.status, this.user, this.errorMessage});

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  factory AuthState.unauthenticated({String? error}) =>
      AuthState(status: AuthStatus.unauthenticated, errorMessage: error);
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  AuthNotifier([this._repositoryOverride, this._seedState]);

  final AuthRepository? _repositoryOverride;
  final AuthState? _seedState;

  AuthRepository get _repository =>
      _repositoryOverride ?? ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    StartupProbe.mark('AuthNotifier.constructed');

    final seededState = _seedState;
    if (seededState != null) {
      return seededState;
    }

    if (StartupProbeConfig.bypassAuthInit) {
      StartupProbe.mark('AuthNotifier.init_bypassed');
      return AuthState.unauthenticated();
    }

    unawaited(_init());
    return AuthState.initial();
  }

  Future<void> _init() async {
    await StartupProbe.measureAsync('AuthNotifier._init', () async {
      state = AuthState.loading();
      try {
        final user = await _repository.getUser();
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = AuthState.unauthenticated();
        }
      } catch (e) {
        state = AuthState.unauthenticated(
          error: 'Gagal memeriksa sesi. Silakan masuk kembali.',
        );
      } finally {
        StartupProbe.mark('AuthNotifier._init.state', <String, Object?>{
          'status': state.status.name,
        });
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      final user = await _repository.login(email, password);
      state = AuthState.authenticated(user);
    } on InvalidCredentialsException catch (error) {
      state = AuthState.unauthenticated(error: error.message);
    } on LoginRequestException catch (error) {
      state = AuthState.unauthenticated(error: error.message);
    } catch (_) {
      state = AuthState.unauthenticated(
        error: 'Terjadi gangguan jaringan. Coba lagi.',
      );
    }
  }

  Future<void> logout() async {
    state = AuthState.unauthenticated();
    unawaited(_repository.logout());
  }

  void forceLogout() {
    state = AuthState.unauthenticated();
  }

  void updateUser(User user) {
    if (state.status == AuthStatus.authenticated) {
      state = AuthState.authenticated(user);
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
