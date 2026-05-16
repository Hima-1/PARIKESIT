import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/tokens/radii.dart';
import 'package:parikesit/core/widgets/app_text_field.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/features/auth/data/auth_repository.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';

import '../../../core/utils/app_error_mapper.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/input_sanitizer.dart';
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
      final sanitizedAlamat = InputSanitizer.nullableTrimmed(
        _alamatController.text,
        maxLength: 1000,
      );
      final sanitizedPhone = InputSanitizer.nullableTrimmed(
        _nomorTeleponController.text,
        maxLength: 20,
      );
      final updatedUser = await ref
          .read(authRepositoryProvider)
          .updateProfile(
            name: InputSanitizer.trimPlainText(
              _nameController.text,
              maxLength: 255,
            ),
            email: InputSanitizer.normalizeEmail(_emailController.text),
            alamat: sanitizedAlamat,
            nomorTelepon: sanitizedPhone == null
                ? null
                : InputSanitizer.normalizePhone(_nomorTeleponController.text),
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
    final scheme = Theme.of(context).colorScheme;

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
                                color: scheme.error.withValues(alpha: 0.08),
                                borderRadius: AppRadii.rrMd,
                                border: Border.all(
                                  color: scheme.error.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.alertCircle,
                                    color: scheme.error,
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
                                            color: scheme.error,
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
                            prefixIcon: const Icon(LucideIcons.badge),
                            textCapitalization: TextCapitalization.words,
                            maxLength: 255,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapH16,
                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            prefixIcon: const Icon(LucideIcons.mail),
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 255,
                            validator: (value) {
                              final email = InputSanitizer.normalizeEmail(
                                value ?? '',
                              );
                              if (email.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(email)) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapH16,
                          AppTextField(
                            controller: _alamatController,
                            label: 'Alamat',
                            prefixIcon: const Icon(LucideIcons.mapPin),
                            maxLines: 3,
                            minLines: 1,
                            keyboardType: TextInputType.streetAddress,
                            maxLength: 1000,
                          ),
                          AppSpacing.gapH16,
                          AppTextField(
                            controller: _nomorTeleponController,
                            label: 'Nomor Telepon',
                            prefixIcon: const Icon(LucideIcons.phone),
                            keyboardType: TextInputType.phone,
                            maxLength: 20,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+()\-\s]'),
                              ),
                            ],
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
