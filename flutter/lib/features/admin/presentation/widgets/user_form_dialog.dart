import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/utils/app_error_mapper.dart';
import 'package:parikesit/core/utils/app_snackbar.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/features/admin/domain/admin_password_reset_result.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controller/user_admin_controller.dart';

class UserFormDialog extends ConsumerStatefulWidget {
  const UserFormDialog({
    super.key,
    this.user,
    this.isResetPassword = false,
    this.useBottomSheetStyle = false,
  });

  final AppUser? user;
  final bool isResetPassword;
  final bool useBottomSheetStyle;

  @override
  ConsumerState<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends ConsumerState<UserFormDialog> {
  static const List<UserRole> _assignableRoles = <UserRole>[
    UserRole.admin,
    UserRole.walidata,
    UserRole.opd,
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late UserRole _selectedRole;
  bool _isSubmitting = false;

  String? _validateRequiredText(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _dialogTitle,
                    style: _textTheme?.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppTheme.sogan,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.sogan.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      LucideIcons.x,
                      color: AppTheme.sogan,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH12,
            Text(
              widget.isResetPassword
                  ? 'Konfirmasi pengaturan ulang kata sandi untuk akun ini.'
                  : 'Pastikan data yang dimasukkan sudah benar dan sesuai.',
              style: _textTheme?.bodySmall?.copyWith(
                color: AppTheme.neutral,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.gapH24,
            if (widget.isResetPassword) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.warningContainerDecoration,
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.alertTriangle,
                      color: AppTheme.warning,
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: Text(
                        'Password untuk ${widget.user?.name} akan diatur ulang ke standar sistem aplikasi.',
                        style: _textTheme?.bodySmall?.copyWith(
                          color: AppTheme.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              AppTextField(
                key: const Key('admin-user-form-name'),
                controller: _nameController,
                label: 'Nama Lengkap',
                prefixIcon: const Icon(LucideIcons.userCheck),
                validator: (v) => _validateRequiredText(v, 'Nama wajib diisi'),
              ),
              AppSpacing.gapH16,
              AppTextField(
                key: const Key('admin-user-form-email'),
                controller: _emailController,
                label: 'Email Instansi / Pribadi',
                prefixIcon: const Icon(LucideIcons.atSign),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final trimmed = v?.trim() ?? '';
                  if (trimmed.isEmpty || !trimmed.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              if (!_isEditing) ...[
                AppSpacing.gapH16,
                AppTextField(
                  key: const Key('admin-user-form-password'),
                  controller: _passwordController,
                  label: 'Kata Sandi',
                  prefixIcon: const Icon(LucideIcons.key),
                  obscureText: true,
                  validator: (v) {
                    if ((v?.trim().length ?? 0) < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  },
                ),
              ],
              AppSpacing.gapH16,
              AppDropdownField<UserRole>(
                key: const Key('admin-user-form-role'),
                label: 'Peran / Hak Akses',
                prefixIcon: const Icon(LucideIcons.shield),
                value: _selectedRole,
                items: _assignableRoles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedRole = value);
                },
              ),
              AppSpacing.gapH16,
              AppTextField(
                key: const Key('admin-user-form-phone'),
                controller: _phoneController,
                label: 'Nomor WhatsApp Aktif',
                prefixIcon: const Icon(LucideIcons.phone),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    _validateRequiredText(v, 'Nomor telepon wajib diisi'),
              ),
              AppSpacing.gapH16,
              AppTextField(
                key: const Key('admin-user-form-address'),
                controller: _addressController,
                label: 'Alamat / Kantor',
                prefixIcon: const Icon(LucideIcons.map),
                maxLines: 2,
                validator: (v) =>
                    _validateRequiredText(v, 'Alamat wajib diisi'),
              ),
            ],
            AppSpacing.gapH32,
            Row(
              children: [
                Expanded(
                  child: EthnoButton(
                    onPressed: () => Navigator.pop(context),
                    label: 'BATAL',
                    style: EthnoButtonStyle.text,
                    size: EthnoButtonSize.small,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: EthnoButton(
                    key: const Key('admin-user-form-submit'),
                    onPressed: _isSubmitting ? null : _submit,
                    label: widget.isResetPassword
                        ? 'RESET'
                        : (_isEditing ? 'SIMPAN' : 'TAMBAH'),
                    size: EthnoButtonSize.small,
                    isLoading: _isSubmitting,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextTheme? _textTheme;

  bool get _isEditing => widget.user != null;

  String get _dialogTitle => widget.isResetPassword
      ? 'RESET PASSWORD'
      : (_isEditing ? 'UBAH DATA USER' : 'TAMBAH USER BARU');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name);
    _emailController = TextEditingController(text: widget.user?.email);
    _passwordController = TextEditingController();
    _phoneController = TextEditingController(text: widget.user?.nomorTelepon);
    _addressController = TextEditingController(text: widget.user?.alamat);
    _selectedRole = _assignableRoles.firstWhere(
      (role) => role.name == (widget.user?.role ?? 'opd'),
      orElse: () => UserRole.opd,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    final formContent = _buildScrollableContent();

    if (widget.useBottomSheetStyle && !_isEditing && !widget.isResetPassword) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
          border: Border(top: BorderSide(color: AppTheme.borderColor)),
        ),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: formContent,
        ),
      );
    }

    return Dialog(
      backgroundColor: AppTheme.shellSurface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 720,
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 720),
        child: formContent,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(userAdminControllerProvider.notifier);

      if (widget.isResetPassword) {
        if (widget.user != null) {
          final result = await notifier.resetPassword(widget.user!.id);
          if (!mounted) {
            return;
          }
          final messenger = ScaffoldMessenger.maybeOf(context);
          final navigator = Navigator.of(context);
          final parentContext = navigator.context;
          navigator.pop();

          if (!parentContext.mounted) {
            return;
          }

          await _showResetPasswordResultDialog(
            parentContext,
            userName: widget.user!.name,
            result: result,
            messenger: messenger,
          );
          return;
        }
      } else {
        final userData = <String, dynamic>{
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': _selectedRole.name,
          'nomor_telepon': _phoneController.text.trim(),
          'alamat': _addressController.text.trim(),
        };

        if (widget.user == null) {
          userData['password'] = _passwordController.text.trim();
          await notifier.createUser(userData);
          if (!mounted) {
            return;
          }
          AppSnackbar.showSuccess(context, 'User berhasil ditambahkan.');
        } else {
          await notifier.updateUser(widget.user!.id, userData);
          if (!mounted) {
            return;
          }
          AppSnackbar.showSuccess(context, 'Data user berhasil diperbarui.');
        }
      }

      if (!mounted) {
        return;
      }
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppSnackbar.showError(
        context,
        AppErrorMapper.toMessage(
          error,
          fallbackMessage: widget.isResetPassword
              ? 'Gagal mereset password user.'
              : (_isEditing
                    ? 'Gagal memperbarui data user.'
                    : 'Gagal menambahkan user.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _showResetPasswordResultDialog(
    BuildContext parentContext, {
    required String userName,
    required AdminPasswordResetResult result,
    required ScaffoldMessengerState? messenger,
  }) {
    return showDialog<void>(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ResetPasswordResultDialog(
          userName: userName,
          temporaryPassword: result.temporaryPassword,
          onCopy: () async {
            await Clipboard.setData(
              ClipboardData(text: result.temporaryPassword),
            );
            if (messenger == null) {
              return;
            }
            AppSnackbar.showSuccessWithMessenger(
              messenger,
              'Password sementara berhasil disalin.',
            );
          },
        );
      },
    );
  }
}

class _ResetPasswordResultDialog extends StatelessWidget {
  const _ResetPasswordResultDialog({
    required this.userName,
    required this.temporaryPassword,
    required this.onCopy,
  });

  final String userName;
  final String temporaryPassword;
  final Future<void> Function() onCopy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: AppTheme.shellSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius * 1.5),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      title: Text(
        'PASSWORD SEMENTARA',
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: AppTheme.sogan,
          letterSpacing: 1,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password sementara untuk $userName berhasil dibuat.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.gapH16,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.warningContainerDecoration,
            child: Text(
              'Password ini hanya ditampilkan sekali. Salin atau simpan sekarang.',
              style: textTheme.bodySmall?.copyWith(
                color: AppTheme.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          AppSpacing.gapH16,
          Text(
            'Password sementara',
            style: textTheme.labelLarge?.copyWith(
              color: AppTheme.sogan.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.gapH8,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.merang,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.12)),
            ),
            child: SelectableText(
              temporaryPassword,
              key: const Key('admin-user-reset-password-value'),
              style: textTheme.titleMedium?.copyWith(
                color: AppTheme.sogan,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
      actions: [
        EthnoButton(
          onPressed: () => Navigator.of(context).pop(),
          label: 'TUTUP',
          style: EthnoButtonStyle.text,
          size: EthnoButtonSize.small,
        ),
        EthnoButton(
          key: const Key('admin-user-reset-password-copy'),
          onPressed: () {
            onCopy();
          },
          label: 'COPY',
          icon: LucideIcons.copy,
          style: EthnoButtonStyle.primary,
          size: EthnoButtonSize.small,
        ),
      ],
    );
  }
}
