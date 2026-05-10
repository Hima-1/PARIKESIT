import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
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

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppTheme.cream,
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: AppTheme.textStrong,
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
        icon: const Icon(
          LucideIcons.bell,
          size: 20,
          color: AppTheme.textStrong,
        ),
        tooltip: unreadCount > 0
            ? 'Notifikasi ($unreadCount belum dibaca)'
            : 'Notifikasi',
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
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppTheme.terracotta.withValues(alpha: 0.10),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.terracotta.withValues(alpha: 0.25),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: AppTheme.terracotta,
            fontSize: 13,
            fontWeight: FontWeight.w700,
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
