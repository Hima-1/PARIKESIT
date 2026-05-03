import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/startup_probe.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(aOptions: AndroidOptions());
});

class TokenStorage {
  TokenStorage(this._storage);
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    if (StartupProbeConfig.skipSecureStorageRead) {
      StartupProbe.mark('TokenStorage.getToken.skipped');
      return null;
    }

    return StartupProbe.measureAsync(
      'TokenStorage.getToken',
      () => _storage.read(key: _tokenKey),
    );
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenStorage(storage);
});
