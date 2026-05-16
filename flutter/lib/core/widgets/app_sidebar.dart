import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../auth/role_access.dart';
import '../auth/user_role.dart';
import '../router/route_constants.dart';
import '../theme/tokens/radii.dart';

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
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(right: BorderSide(color: scheme.outline)),
      ),
      child: SizedBox(
        width: 264,
        child: Column(
          children: [
            _buildLogo(context),
            Divider(color: scheme.outline, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildSectionHeader(context, 'HOME'),
                  _buildMenuItem(
                    context,
                    title: 'Beranda',
                    icon: LucideIcons.layoutDashboard,
                    route: RouteConstants.home,
                    currentRoute: location,
                  ),
                  if (showAdminUsers) ...[
                    _buildSectionHeader(context, 'USER'),
                    _buildMenuItem(
                      context,
                      title: 'Manajemen User',
                      icon: LucideIcons.users,
                      route: RouteConstants.adminUsers,
                      currentRoute: location,
                    ),
                  ],
                  _buildSectionHeader(context, 'PENILAIAN'),
                  if (showAssessmentKegiatan)
                    _buildMenuItem(
                      context,
                      title: 'Kegiatan Penilaian',
                      icon: LucideIcons.clipboardList,
                      route: RouteConstants.assessmentKegiatan,
                      currentRoute: location,
                    ),
                  if (showAssessmentMandiri)
                    _buildMenuItem(
                      context,
                      title: isOpd ? 'Formulir' : 'Penilaian Mandiri',
                      icon: LucideIcons.fileCheck2,
                      route: RouteConstants.assessmentMandiri,
                      currentRoute: location,
                    ),
                  if (showAssessmentSelesai)
                    _buildMenuItem(
                      context,
                      title: 'Penilaian',
                      icon: LucideIcons.checkCircle2,
                      route: RouteConstants.assessmentSelesai,
                      currentRoute: location,
                    ),
                  _buildSectionHeader(context, 'DOKUMENTASI'),
                  if (isAdmin && showPembinaan)
                    _buildMenuItem(
                      context,
                      title: 'Dokumentasi & Pembinaan',
                      icon: LucideIcons.folder,
                      route: RouteConstants.adminDokumentasi,
                      currentRoute: location,
                    ),
                  if (!isAdmin && showDokumentasiKegiatan)
                    _buildMenuItem(
                      context,
                      title: 'Kegiatan',
                      icon: LucideIcons.folder,
                      route: RouteConstants.dokumentasiKegiatan,
                      currentRoute: location,
                    ),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.secondary,
              borderRadius: AppRadii.rrSm,
            ),
            alignment: Alignment.center,
            child: Icon(
              LucideIcons.barChart3,
              color: scheme.onSecondary,
              size: 16,
            ),
          ),
          AppSpacing.gapW8,
          Expanded(
            child: Text(
              'PARIKESIT',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.onSurface.withValues(alpha: 0.58),
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    required String currentRoute,
  }) {
    final isSelected =
        currentRoute == route ||
        (route != '/' && currentRoute.startsWith(route));

    final scheme = Theme.of(context).colorScheme;
    final Color tone = isSelected
        ? scheme.secondary
        : scheme.onSurface.withValues(alpha: 0.72);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
      child: Material(
        color: isSelected
            ? scheme.secondary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: AppRadii.rrSm,
        child: InkWell(
          borderRadius: AppRadii.rrSm,
          onTap: () => context.go(route),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: tone, size: 18),
                AppSpacing.gapW12,
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? scheme.onSurface : tone,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: AppRadii.rrSm,
              border: Border.all(color: scheme.outline),
            ),
            alignment: Alignment.center,
            child: Icon(
              LucideIcons.headphones,
              color: scheme.secondary,
              size: 16,
            ),
          ),
          AppSpacing.gapW12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bantuan',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Kontak Support',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.58),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
