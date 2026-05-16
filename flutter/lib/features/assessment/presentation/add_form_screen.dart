import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/input_sanitizer.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';

import '../../../core/widgets/app_dropdown_field.dart';
import 'controller/assessment_list_controller.dart';

class AddFormScreen extends ConsumerStatefulWidget {
  const AddFormScreen({super.key, this.formulir});

  final AssessmentFormModel? formulir;

  @override
  ConsumerState<AddFormScreen> createState() => _AddFormScreenState();
}

class _AddFormScreenState extends ConsumerState<AddFormScreen> {
  static const String _templateBps2022Id = 'peraturan_bps_no_3_tahun_2022';
  static const String _templateBps2022Label = 'Peraturan BPS No. 3 Tahun 2022';

  final TextEditingController _formNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedTemplate = _templateBps2022Id;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _formNameController.addListener(_validateForm);
    if (widget.formulir != null) {
      _formNameController.text = widget.formulir!.title;
      _validateForm();
    }
  }

  @override
  void dispose() {
    _formNameController.removeListener(_validateForm);
    _formNameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final bool isValid = _formNameController.text.trim().length >= 5;
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await HapticFeedback.mediumImpact();
      final controller = ref.read(assessmentListControllerProvider.notifier);
      final name = InputSanitizer.trimPlainText(
        _formNameController.text,
        maxLength: 255,
      );
      if (widget.formulir != null) {
        await controller.updateActivity(widget.formulir!.id, name);
      } else {
        await controller.addActivity(
          name,
          useTemplate: _selectedTemplate == _templateBps2022Id,
        );
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppTheme.shellSurfaceSoft,
        surfaceTintColor: AppTheme.shellSurfaceSoft,
        title: Text(
          widget.formulir != null ? 'Edit Formulir' : 'Tambah Formulir',
          style: textTheme.titleMedium?.copyWith(
            color: AppTheme.sogan,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: AppSpacing.pAll24,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Nama Formulir',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.sogan,
                  ),
                ),
                AppSpacing.gapH8,
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: _formNameController,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        maxLength: 255,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama formulir tidak boleh kosong';
                          }
                          if (value.trim().length < 5) {
                            return 'Minimal 5 karakter';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama formulir',
                          filled: true,
                          fillColor: AppTheme.shellSurface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.borderRadius,
                            ),
                            borderSide: BorderSide(
                              color: AppTheme.sogan.withValues(alpha: 0.1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.borderRadius,
                            ),
                            borderSide: const BorderSide(
                              color: AppTheme.sogan,
                              width: 1.4,
                            ),
                          ),
                        ),
                        style: textTheme.bodyMedium,
                      ),
                      AppSpacing.gapH20,
                      if (widget.formulir == null) ...[
                        AppDropdownField<String>(
                          label: 'Gunakan template',
                          value: _selectedTemplate,
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: _templateBps2022Id,
                              child: Text(_templateBps2022Label),
                            ),
                          ],
                          onChanged: (String? value) {
                            if (value == null) {
                              return;
                            }
                            if (value != _selectedTemplate) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _selectedTemplate = value;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Template harus dipilih';
                            }
                            return null;
                          },
                        ),
                        AppSpacing.gapH8,
                        Text(
                          'Template ini akan dipakai otomatis saat formulir dibuat.',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppTheme.sogan.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                AppSpacing.gapH24,
                EthnoButton(
                  onPressed: _isFormValid ? _submit : null,
                  label: widget.formulir != null
                      ? 'Simpan Perubahan'
                      : 'Tambahkan',
                  isFullWidth: true,
                  style: _isFormValid
                      ? EthnoButtonStyle.primary
                      : EthnoButtonStyle.outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
