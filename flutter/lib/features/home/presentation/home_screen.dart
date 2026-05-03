import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/features/admin/presentation/admin_dashboard_screen.dart';

import '../../../core/auth/user_role.dart';
import 'pages/opd/opd_dashboard_screen.dart';
import 'pages/walidata/walidata_dashboard_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);

    switch (role) {
      case UserRole.opd:
        return const OpdDashboardScreen();
      case UserRole.walidata:
        return const WalidataDashboardScreen();
      case UserRole.admin:
        return const AdminDashboardScreen();
      case UserRole.unknown:
        return const Scaffold(
          body: Center(child: Text('Role tidak valid. Silakan login ulang.')),
        );
    }
  }
}
