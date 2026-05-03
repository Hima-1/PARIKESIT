import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/user.dart';
import '../../features/auth/presentation/controller/auth_provider.dart';

typedef AppUser = User;

final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
});
