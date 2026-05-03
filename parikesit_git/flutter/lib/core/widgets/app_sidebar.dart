import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../auth/role_access.dart';
import '../auth/user_role.dart';
import '../router/route_constants.dart';
import '../theme/app_theme.dart';

class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final role = ref.watch(userRoleProvider);

    final bool isAdmin = role == UserRole.admin;
    final bool isOpd = role == UserRole.opd;
    final bool isWalidata = role == UserRole.walidata;

    final bool showAssessmentKegiatan =
        !isOpd &&
        !isWalidata &&
        RoleAccess.canAccessRoute(role, RouteConstants.assessmentKegiatan);

    final bool showAssessmentMandiri = RoleAccess.canAccessRoute(
      role,
      RouteConstants.assessmentMandiri,
    );
    final bool showAssessmentSelesai = RoleAccess.canAccessRoute(
      role,
      RouteConstants.assessmentSelesai,
    );
    final bool showPembinaan = RoleAccess.canAccessRoute(
      role,
      RouteConstants.pembinaan,
    );
    final bool showDokumentasiKegiatan = RoleAccess.canAccessRoute(
      role,
      RouteConstants.dokumentasiKegiatan,
    );

    final bool showAdminUsers =
        !isOpd && RoleAccess.canAccessRoute(role, RouteConstants.adminUsers);

    return Container(
      width: 280,
      color: AppTheme.sogan,
      child: Column(
        children: [
          _buildLogo(context),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                _buildSectionHeader(context, 'HOME'),
                _buildMenuItem(
                  context,
                  title: 'Beranda',
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  route: RouteConstants.home,
                  currentRoute: location,
                ),

                if (showAdminUsers) ...[
                  AppSpacing.gapH16,
                  _buildSectionHeader(context, 'USER'),
                  if (showAdminUsers)
                    _buildMenuItem(
                      context,
                      title: 'Manajemen User',
                      icon: Icons.people_outline,
                      selectedIcon: Icons.people,
                      route: RouteConstants.adminUsers,
                      currentRoute: location,
                    ),
                ],
                AppSpacing.gapH16,
                _buildSectionHeader(context, 'PENILAIAN'),
                if (showAssessmentKegiatan)
                  _buildMenuItem(
                    context,
                    title: 'Kegiatan Penilaian',
                    icon: Icons.assignment_outlined,
                    selectedIcon: Icons.assignment,
                    route: RouteConstants.assessmentKegiatan,
                    currentRoute: location,
                  ),
                if (showAssessmentMandiri)
                  _buildMenuItem(
                    context,
                    title: isOpd ? 'Formulir' : 'Penilaian Mandiri',
                    icon: Icons.fact_check_outlined,
                    selectedIcon: Icons.fact_check,
                    route: RouteConstants.assessmentMandiri,
                    currentRoute: location,
                  ),
                if (showAssessmentSelesai)
                  _buildMenuItem(
                    context,
                    title: 'Penilaian',
                    icon: Icons.task_alt_outlined,
                    selectedIcon: Icons.task_alt,
                    route: RouteConstants.assessmentSelesai,
                    currentRoute: location,
                  ),
                AppSpacing.gapH16,
                _buildSectionHeader(context, 'DOKUMENTASI'),
                if (isAdmin && showPembinaan)
                  _buildMenuItem(
                    context,
                    title: 'Dokumentasi & Pembinaan',
                    icon: Icons.folder_outlined,
                    selectedIcon: Icons.folder,
                    route: RouteConstants.adminDokumentasi,
                    currentRoute: location,
                  ),
                if (!isAdmin && showDokumentasiKegiatan)
                  _buildMenuItem(
                    context,
                    title: 'Kegiatan',
                    icon: Icons.folder_outlined,
                    selectedIcon: Icons.folder,
                    route: RouteConstants.dokumentasiKegiatan,
                    currentRoute: location,
                  ),
              ],
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.query_stats, color: AppTheme.gold, size: 32),
          AppSpacing.gapW12,
          Text(
            'PARIKESIT',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white38,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required IconData selectedIcon,
    required String route,
    required String currentRoute,
  }) {
    final isSelected =
        currentRoute == route ||
        (route != '/' && currentRoute.startsWith(route));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.gold.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => context.go(route),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? AppTheme.gold : Colors.white70,
          size: 22,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppTheme.gold : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.black.withValues(alpha: 0.2),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.support_agent, color: Colors.white, size: 18),
          ),
          AppSpacing.gapW12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bantuan',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Kontak Support',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
