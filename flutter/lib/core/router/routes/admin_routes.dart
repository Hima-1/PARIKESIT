import 'package:go_router/go_router.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:parikesit/features/admin/presentation/controller/dokumentasi_detail_controller.dart';
import 'package:parikesit/features/admin/presentation/dokumentasi_detail_screen.dart';
import 'package:parikesit/features/admin/presentation/user_management_screen.dart';
import 'package:parikesit/features/pembinaan/presentation/dokumentasi_list_screen.dart';

List<RouteBase> getAdminRoutes() {
  return [
    GoRoute(
      path: RouteConstants.adminDashboard,
      builder: (context, state) => const AdminDashboardScreen(),
      routes: [
        GoRoute(
          path: 'users', // Sub-routes are relative
          builder: (context, state) => const UserManagementScreen(),
        ),
        GoRoute(
          path: 'dokumentasi',
          builder: (context, state) => const DokumentasiListScreen(),
          routes: [
            GoRoute(
              path: 'kegiatan/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return DokumentasiDetailScreen(
                  id: id,
                  type: DokumentasiDetailType.kegiatan,
                );
              },
            ),
            GoRoute(
              path: 'pembinaan/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return DokumentasiDetailScreen(
                  id: id,
                  type: DokumentasiDetailType.pembinaan,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
