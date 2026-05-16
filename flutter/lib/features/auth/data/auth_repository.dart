import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/core/utils/input_sanitizer.dart';
import 'package:parikesit/core/utils/startup_probe.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_exceptions.dart';
import 'package:parikesit/features/auth/domain/user.dart';

class AuthRepository {
  AuthRepository(this._apiClient, this._tokenStorage);
  final AuthApiClient _apiClient;
  final TokenStorage _tokenStorage;

  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.login({
        'email': InputSanitizer.normalizeEmail(email),
        'password': password,
      });

      await _tokenStorage.saveToken(response.token);
      return response.user;
    } catch (error) {
      throw mapLoginException(error);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } catch (e) {
      // Ignore errors on logout (e.g. if token is already invalid)
    } finally {
      await _tokenStorage.deleteToken();
    }
  }

  Future<User?> getUser() async {
    return StartupProbe.measureAsync('AuthRepository.getUser', () async {
      final token = await _tokenStorage.getToken();
      if (token == null) {
        StartupProbe.mark('AuthRepository.getUser.no_token');
        return null;
      }

      try {
        return await StartupProbe.measureAsync(
          'AuthApiClient.getUser',
          _apiClient.getUser,
        );
      } catch (e) {
        StartupProbe.mark('AuthRepository.getUser.error', <String, Object?>{
          'error': e.runtimeType.toString(),
        });
        // If fetching the user fails, the token might be invalid/expired.
        // The AuthInterceptor will handle 401s globally, but we catch it here just in case
        // we need to return null for the initial load.
        return null;
      }
    });
  }

  Future<User> updateProfile({
    required String name,
    required String email,
    String? alamat,
    String? nomorTelepon,
    String? currentPassword,
    String? password,
    String? passwordConfirmation,
  }) async {
    final payload = <String, dynamic>{
      'name': InputSanitizer.trimPlainText(name, maxLength: 255),
      'email': InputSanitizer.normalizeEmail(email),
    };
    if (alamat != null) {
      payload['alamat'] = InputSanitizer.trimPlainText(alamat, maxLength: 1000);
    }
    if (nomorTelepon != null) {
      payload['nomor_telepon'] = InputSanitizer.normalizePhone(nomorTelepon);
    }
    if (currentPassword != null &&
        password != null &&
        passwordConfirmation != null) {
      payload['current_password'] = currentPassword;
      payload['password'] = password;
      payload['password_confirmation'] = passwordConfirmation;
    }

    final response = await _apiClient.updateProfile(payload);
    final data = response['data'] as Map<String, dynamic>;
    return User.fromJson(data);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(authApiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRepository(apiClient, tokenStorage);
});
