import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/controller/auth_provider.dart';

enum UserRole { opd, walidata, admin, unknown }

UserRole parseUserRole(String? raw) {
  switch (raw) {
    case 'admin':
      return UserRole.admin;
    case 'walidata':
      return UserRole.walidata;
    case 'opd':
      return UserRole.opd;
    default:
      return UserRole.unknown;
  }
}

final userRoleProvider = Provider<UserRole>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return parseUserRole(authState.user?.role);
});
