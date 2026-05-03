import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';

import '../../../core/utils/app_dialogs.dart';
import '../../../core/utils/app_snackbar.dart';
import 'controller/user_admin_controller.dart';
import 'widgets/user_form_dialog.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  const UserDetailScreen({super.key, required this.user});

  final AppUser user;

  @override
  ConsumerState<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  bool _isTriggeringReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengguna'),
        backgroundColor: AppTheme.sogan,
        foregroundColor: AppTheme.gold,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pPage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            AppSpacing.gapH24,
            _buildInfoCard(),
            AppSpacing.gapH32,
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final textTheme = Theme.of(context).textTheme;
    final normalizedRole = _normalizeRoleLabel(widget.user.role);
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.sogan.withValues(alpha: 0.1),
            child: Text(
              widget.user.name[0].toUpperCase(),
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.sogan,
              ),
            ),
          ),
          AppSpacing.gapH16,
          Text(
            widget.user.name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.sogan,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapH8,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getRoleColor(widget.user.role).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getRoleColor(widget.user.role).withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              normalizedRole.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                color: _getRoleColor(widget.user.role),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.email_outlined, 'Email', widget.user.email),
            const Divider(),
            _buildInfoRow(
              Icons.phone_outlined,
              'Nomor Telepon',
              widget.user.nomorTelepon ?? '-',
            ),
            const Divider(),
            _buildInfoRow(
              Icons.location_on_outlined,
              'Alamat',
              widget.user.alamat ?? '-',
            ),
            const Divider(),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              'Tanggal Dibuat',
              widget.user.createdAt != null
                  ? DateFormat(
                      'EEEE, d MMMM yyyy',
                      'id_ID',
                    ).format(widget.user.createdAt!)
                  : '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.sogan.withValues(alpha: 0.6)),
          AppSpacing.gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppTheme.sogan.withValues(alpha: 0.6),
                  ),
                ),
                AppSpacing.gapH4,
                Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.sogan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isOpdUser = widget.user.role == 'opd';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720 || isOpdUser;

        return Column(
          children: [
            if (isCompact) ...[
              EthnoButton(
                onPressed: () => Navigator.pop(context),
                icon: Icons.arrow_back,
                label: 'Kembali',
                style: EthnoButtonStyle.outlined,
                isFullWidth: true,
              ),
              AppSpacing.gapH16,
              EthnoButton(
                onPressed: () => _showUserForm(isReset: false),
                icon: Icons.edit_outlined,
                label: 'Edit',
                style: EthnoButtonStyle.primary,
                isFullWidth: true,
              ),
              AppSpacing.gapH16,
              EthnoButton(
                onPressed: () => _showUserForm(isReset: true),
                icon: Icons.lock_reset_outlined,
                label: 'Reset Password',
                style: EthnoButtonStyle.secondary,
                isFullWidth: true,
              ),
              if (isOpdUser) ...[
                AppSpacing.gapH16,
                EthnoButton(
                  onPressed: _isTriggeringReminder ? null : _triggerReminder,
                  icon: Icons.notifications_active_outlined,
                  label: _isTriggeringReminder
                      ? 'Mengirim Reminder...'
                      : 'Kirim Reminder',
                  style: EthnoButtonStyle.secondary,
                  isFullWidth: true,
                ),
              ],
              AppSpacing.gapH16,
              EthnoButton(
                onPressed: _confirmDelete,
                icon: Icons.delete_outline,
                label: 'Hapus',
                style: EthnoButtonStyle.danger,
                isFullWidth: true,
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: EthnoButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icons.arrow_back,
                      label: 'Kembali',
                      style: EthnoButtonStyle.outlined,
                      isFullWidth: true,
                    ),
                  ),
                  AppSpacing.gapW16,
                  Expanded(
                    child: EthnoButton(
                      onPressed: () => _showUserForm(isReset: false),
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      style: EthnoButtonStyle.primary,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH16,
              Row(
                children: [
                  Expanded(
                    child: EthnoButton(
                      onPressed: () => _showUserForm(isReset: true),
                      icon: Icons.lock_reset_outlined,
                      label: 'Reset Password',
                      style: EthnoButtonStyle.secondary,
                      isFullWidth: true,
                    ),
                  ),
                  AppSpacing.gapW16,
                  Expanded(
                    child: EthnoButton(
                      onPressed: _confirmDelete,
                      icon: Icons.delete_outline,
                      label: 'Hapus',
                      style: EthnoButtonStyle.danger,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _triggerReminder() async {
    setState(() => _isTriggeringReminder = true);

    try {
      final result = await ref
          .read(userAdminControllerProvider.notifier)
          .triggerOpdReminder(widget.user.id);
      if (!mounted) {
        return;
      }

      AppSnackbar.showSuccess(
        context,
        result.message.isEmpty ? 'Reminder berhasil diproses.' : result.message,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      AppSnackbar.showError(context, 'Gagal mengirim reminder untuk user ini.');
    } finally {
      if (mounted) {
        setState(() => _isTriggeringReminder = false);
      }
    }
  }

  void _showUserForm({required bool isReset}) {
    showDialog<void>(
      context: context,
      builder: (context) =>
          UserFormDialog(user: widget.user, isResetPassword: isReset),
    );
  }

  void _confirmDelete() async {
    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Hapus User',
      content: 'Apakah Anda yakin ingin menghapus user ${widget.user.name}?',
      confirmLabel: 'Hapus',
      isDanger: true,
    );

    if (confirmed == true) {
      await ref
          .read(userAdminControllerProvider.notifier)
          .deleteUser(widget.user.id);
      if (mounted) Navigator.pop(context); // Back to list
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return AppTheme.sogan;
      case 'walidata':
        return AppTheme.kunyit;
      case 'opd':
        return AppTheme.jatiGreen;
      default:
        return AppTheme.warning;
    }
  }

  String _normalizeRoleLabel(String role) {
    switch (role) {
      case 'admin':
      case 'walidata':
      case 'opd':
        return role;
      default:
        return 'role tidak valid';
    }
  }
}
