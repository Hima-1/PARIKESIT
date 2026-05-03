import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/features/auth/domain/user.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';

import '../../../core/router/route_constants.dart';
import '../../../core/utils/app_dialogs.dart';
import '../../../core/widgets/ethno_patterns.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: KawungBackground(
        opacity: 0.03,
        child: SingleChildScrollView(
          padding: AppSpacing.pPage,
          child: _buildBody(context, ref, authState.status, user),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AuthStatus status,
    User? user,
  ) {
    if (status == AuthStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (status != AuthStatus.authenticated || user == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _buildProfileHeader(context, user.name, user.email),
        AppSpacing.gapH24,
        EthnoCard(
          showBatikAccent: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                context,
                Icons.badge_outlined,
                'Nama Lengkap',
                user.name,
              ),
              const Divider(height: 32),
              _buildInfoRow(context, Icons.email_outlined, 'Email', user.email),
              const Divider(height: 32),
              _buildInfoRow(
                context,
                Icons.verified_user_outlined,
                'Peran',
                user.role.toUpperCase(),
              ),
            ],
          ),
        ),
        AppSpacing.gapH24,
        _buildActionList(context, ref),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String email) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.gold.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.gold, width: 2),
          ),
          child: const Icon(Icons.person, size: 60, color: AppTheme.sogan),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.gold, size: 24),
        AppSpacing.gapW16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.neutral,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.sogan,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionList(BuildContext context, WidgetRef ref) {
    return EthnoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildActionTile(
            context,
            Icons.lock_reset_outlined,
            'Ubah Password',
            () => context.push(RouteConstants.changePassword),
          ),
          const Divider(height: 1),
          _buildActionTile(
            context,
            Icons.person_outline,
            'Edit Profil',
            () => context.push(RouteConstants.editProfile),
          ),
          const Divider(height: 1),
          _buildActionTile(
            context,
            Icons.logout,
            'Logout',
            () => _showLogoutDialog(context, ref),
            color: AppTheme.sogaRed,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
    bool isLast = false,
  }) {
    final tileColor = color ?? AppTheme.sogan;

    return ListTile(
      leading: Icon(icon, color: tileColor, size: 22),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: tileColor,
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 20, color: tileColor),
      onTap: onTap,
      shape: isLast
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            )
          : null,
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Keluar Aplikasi',
      content: 'Apakah Anda yakin ingin keluar dari akun ini?',
      confirmLabel: 'Keluar',
      isDanger: true,
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (!context.mounted) return;
      context.go(RouteConstants.landing);
    }
  }
}
