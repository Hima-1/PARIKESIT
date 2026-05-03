import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/providers/dio_provider.dart';
import 'package:parikesit/features/auth/domain/login_response.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  @POST('/login')
  Future<LoginResponse> login(@Body() Map<String, dynamic> credentials);

  @POST('/logout')
  Future<void> logout();

  @GET('/user')
  Future<User> getUser();

  @PATCH('/profile')
  Future<dynamic> updateProfile(@Body() Map<String, dynamic> data);
}

final authApiClientProvider = Provider<AuthApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApiClient(dio);
});
