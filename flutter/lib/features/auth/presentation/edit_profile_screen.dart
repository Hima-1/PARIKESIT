import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _alamatController;
  late final TextEditingController _nomorTeleponController;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _alamatController = TextEditingController(text: user?.alamat ?? '');
    _nomorTeleponController = TextEditingController(
      text: user?.nomorTelepon ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _nomorTeleponController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final updatedUser = await ref
          .read(authRepositoryProvider)
          .updateProfile(
            name: _nameController.text,
            email: _emailController.text,
            alamat: _alamatController.text.isEmpty
                ? null
                : _alamatController.text,
            nomorTelepon: _nomorTeleponController.text.isEmpty
                ? null
                : _nomorTeleponController.text,
          );

      // Also update via notifier so AuthState reflects new user data
      ref.read(authNotifierProvider.notifier).updateUser(updatedUser);

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Profil berhasil diperbarui');
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
      appBar: AppBar(title: const Text('Edit Profil')),
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
                                    Icons.error_outline,
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
                            controller: _nameController,
                            label: 'Nama Lengkap',
                            prefixIcon: const Icon(Icons.badge_outlined),
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapH16,
                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapH16,
                          AppTextField(
                            controller: _alamatController,
                            label: 'Alamat',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            maxLines: 3,
                            minLines: 1,
                            keyboardType: TextInputType.streetAddress,
                          ),
                          AppSpacing.gapH16,
                          AppTextField(
                            controller: _nomorTeleponController,
                            label: 'Nomor Telepon',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            keyboardType: TextInputType.phone,
                          ),
                          AppSpacing.gapH24,
                          EthnoButton(
                            onPressed: _isLoading ? () {} : _saveProfile,
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
