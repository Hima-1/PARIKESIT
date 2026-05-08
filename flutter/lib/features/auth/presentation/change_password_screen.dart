import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_text_field.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';

import '../../../core/utils/app_error_mapper.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/ethno_patterns.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = ref.read(authNotifierProvider).user;
      if (user == null) throw Exception('User not found');

      await ref
          .read(authRepositoryProvider)
          .updateProfile(
            name: user.name,
            email: user.email,
            currentPassword: _oldPasswordController.text,
            password: _newPasswordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          );

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Password berhasil diubah');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AppErrorMapper.toMessage(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Password')),
      body: KawungBackground(
        opacity: 0.03,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: AppSpacing.pPage,
          child: Form(
            key: _formKey,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  children: [
                    EthnoCard(
                      showBatikAccent: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.sogaRed.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.borderRadius,
                                ),
                                border: Border.all(
                                  color: AppTheme.sogaRed.withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    LucideIcons.alertCircle,
                                    color: AppTheme.sogaRed,
                                    size: 20,
                                  ),
                                  AppSpacing.gapW8,
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: AppTheme.sogaRed,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.gapH16,
                          ],
                          AppTextField(
                            controller: _oldPasswordController,
                            label: 'Password Saat Ini',
                            prefixIcon: const Icon(LucideIcons.lock),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password saat ini tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapH16,
                          AppTextField(
                            controller: _newPasswordController,
                            label: 'Password Baru',
                            prefixIcon: const Icon(LucideIcons.keyRound),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password baru tidak boleh kosong';
                              }
                              if (value.length < 8) {
                                return 'Password minimal 8 karakter';
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapH16,
                          AppTextField(
                            controller: _confirmPasswordController,
                            label: 'Konfirmasi Password Baru',
                            prefixIcon: const Icon(LucideIcons.checkCircle2),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password tidak boleh kosong';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapH24,
                          EthnoButton(
                            onPressed: _isLoading ? () {} : _changePassword,
                            label: 'SIMPAN',
                            isLoading: _isLoading,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
