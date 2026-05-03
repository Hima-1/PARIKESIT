import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/storage/token_storage.dart';
import 'package:parikesit/features/auth/data/auth_api_client.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';

void main() {
  test('logout deletes local token even when api logout fails', () async {
    final tokenStorage = _TrackingTokenStorage();
    final repository = AuthRepository(_FailingAuthApiClient(), tokenStorage);

    await repository.logout();

    expect(tokenStorage.deleteCount, 1);
  });
}

class _FailingAuthApiClient implements AuthApiClient {
  @override
  Future<User> getUser() {
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> login(Map<String, dynamic> credentials) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    throw Exception('logout failed');
  }

  @override
  Future<dynamic> updateProfile(Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}

class _TrackingTokenStorage extends TokenStorage {
  _TrackingTokenStorage() : super(const FlutterSecureStorage());

  int deleteCount = 0;

  @override
  Future<void> deleteToken() async {
    deleteCount += 1;
  }
}
