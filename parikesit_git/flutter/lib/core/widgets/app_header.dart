import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../../features/auth/domain/user.dart';
import '../../features/auth/presentation/controller/auth_provider.dart';
import '../../features/notifications/presentation/notification_controller.dart';
import '../router/route_constants.dart';
import '../theme/app_theme.dart';
import 'notification_badge.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final location = GoRouterState.of(context).matchedLocation;

    final title = _getTitle(location);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.sogan,
        boxShadow: [
          BoxShadow(
            color: AppTheme.sogan.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: AppTheme.gold,
          ),
        ),
        actions: [
          if (_shouldShowNotificationAction(user)) ...[
            _buildNotificationAction(context, unreadCount),
            AppSpacing.gapW8,
          ],
          _buildUserAvatar(context, user),
          AppSpacing.gapW16,
        ],
      ),
    );
  }

  bool _shouldShowNotificationAction(User? user) => user?.role == 'opd';

  Widget _buildNotificationAction(BuildContext context, int unreadCount) {
    return NotificationBadge(
      count: unreadCount,
      child: IconButton(
        icon: const Icon(Icons.notifications_outlined, color: AppTheme.gold),
        onPressed: () {
          Future.microtask(() {
            if (!context.mounted) return;
            context.push(RouteConstants.notifications);
          });
        },
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context, User? user) {
    if (user == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Future.microtask(() {
          if (!context.mounted) return;
          context.push(RouteConstants.profile);
        });
      },
      child: CircleAvatar(
        radius: 16,
        backgroundColor: AppTheme.gold,
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: AppTheme.sogan,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getTitle(String location) {
    if (location == RouteConstants.home) {
      return 'PARIKESIT';
    }
    if (location.startsWith(RouteConstants.assessmentKegiatan)) {
      return 'KEGIATAN';
    }
    if (location.startsWith(RouteConstants.assessmentMandiri)) {
      return 'FORMULIR';
    }
    if (location.startsWith(RouteConstants.assessmentSelesai)) {
      return 'PENILAIAN';
    }
    if (location.startsWith(RouteConstants.adminDokumentasi)) {
      return 'DOKUMENTASI';
    }
    if (location.startsWith(RouteConstants.dokumentasiKegiatan)) {
      return 'DOKUMENTASI';
    }
    if (location.startsWith(RouteConstants.pembinaan)) {
      return 'PEMBINAAN';
    }
    if (location.startsWith(RouteConstants.notifications)) {
      return 'NOTIFIKASI';
    }
    if (location.startsWith(RouteConstants.profile)) {
      return 'PROFIL';
    }
    return 'PARIKESIT';
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
