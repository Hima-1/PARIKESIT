import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../auth/role_access.dart';
import '../auth/user_role.dart';
import '../router/route_constants.dart';
import '../theme/app_theme.dart';

class AppBottomNav extends ConsumerWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final textTheme = Theme.of(context).textTheme;

    final List<_BottomNavItem> items = _getNavItems(role);

    if (items.length < 2) return const SizedBox.shrink();

    final int currentIndex = _calculateSelectedIndex(location, items);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          HapticFeedback.selectionClick();
          Future.microtask(() {
            if (!context.mounted) return;
            context.go(items[index].route);
          });
        },
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        enableFeedback: true,
        selectedItemColor: AppTheme.terracotta,
        unselectedItemColor: AppTheme.textMuted,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppTheme.terracotta,
          fontSize: 11,
        ),
        unselectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppTheme.textMuted,
          fontSize: 11,
        ),
        items: items.map((item) {
          return BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Icon(item.icon, size: 20),
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  List<_BottomNavItem> _getNavItems(UserRole role) {
    final List<_BottomNavItem> roleSpecificItems = switch (role) {
      UserRole.admin => [
        _BottomNavItem(
          label: 'BERANDA',
          icon: LucideIcons.layoutDashboard,
          route: RouteConstants.home,
        ),
        _BottomNavItem(
          label: 'USER',
          icon: LucideIcons.users,
          route: RouteConstants.adminUsers,
        ),
        _BottomNavItem(
          label: 'PENILAIAN',
          icon: LucideIcons.checkCircle2,
          route: RouteConstants.assessmentSelesai,
        ),
        _BottomNavItem(
          label: 'DOKUMENTASI',
          icon: LucideIcons.folder,
          route: RouteConstants.adminDokumentasi,
        ),
      ],
      UserRole.opd => [
        _BottomNavItem(
          label: 'BERANDA',
          icon: LucideIcons.layoutDashboard,
          route: RouteConstants.home,
        ),
        _BottomNavItem(
          label: 'FORMULIR',
          icon: LucideIcons.clipboardList,
          route: RouteConstants.assessmentMandiri,
        ),
        _BottomNavItem(
          label: 'PENILAIAN',
          icon: LucideIcons.checkCircle2,
          route: RouteConstants.assessmentSelesai,
        ),
        _BottomNavItem(
          label: 'KEGIATAN',
          icon: LucideIcons.folder,
          route: RouteConstants.dokumentasiKegiatan,
        ),
      ],
      UserRole.walidata => [
        _BottomNavItem(
          label: 'BERANDA',
          icon: LucideIcons.layoutDashboard,
          route: RouteConstants.home,
        ),
        _BottomNavItem(
          label: 'PENILAIAN',
          icon: LucideIcons.checkCircle2,
          route: RouteConstants.assessmentSelesai,
        ),
        _BottomNavItem(
          label: 'KEGIATAN',
          icon: LucideIcons.folder,
          route: RouteConstants.dokumentasiKegiatan,
        ),
      ],
      _ => [],
    };

    return roleSpecificItems
        .where((item) => RoleAccess.canAccessRoute(role, item.route))
        .toList(growable: false);
  }

  int _calculateSelectedIndex(String location, List<_BottomNavItem> items) {
    for (int i = 0; i < items.length; i++) {
      final route = items[i].route;
      if (location == route || (route != '/' && location.startsWith(route))) {
        return i;
      }
    }
    return 0;
  }
}

class _BottomNavItem {
  _BottomNavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
