import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';
  static const String _userKey = 'user_data';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  Future<String?> getRole() async {
    return _storage.read(key: _roleKey);
  }

  Future<void> deleteRole() async {
    await _storage.delete(key: _roleKey);
  }

  Future<void> saveUser(String userJson) async {
    await _storage.write(key: _userKey, value: userJson);
  }

  Future<String?> getUser() async {
    return _storage.read(key: _userKey);
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }
}

final Provider<SecureStorageService> secureStorageProvider =
    Provider<SecureStorageService>((Ref ref) {
      return const SecureStorageService(FlutterSecureStorage());
    });
