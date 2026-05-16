import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/input_sanitizer.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'controller/assessment_list_controller.dart';
import 'widgets/dynamic_aspect_fields.dart';

class AddDomainScreen extends ConsumerStatefulWidget {
  const AddDomainScreen({super.key, required this.activityId});

  final String activityId;

  @override
  ConsumerState<AddDomainScreen> createState() => _AddDomainScreenState();
}

class _AddDomainScreenState extends ConsumerState<AddDomainScreen> {
  final TextEditingController _domainNameController = TextEditingController();
  final List<TextEditingController> _aspectControllers =
      <TextEditingController>[TextEditingController()];
  final ValueNotifier<int> _aspectVersion = ValueNotifier<int>(0);

  @override
  void dispose() {
    _domainNameController.dispose();
    _aspectVersion.dispose();
    for (var controller in _aspectControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAspect() {
    setState(() {
      _aspectControllers.add(TextEditingController());
      _aspectVersion.value++;
    });
  }

  void _removeAspect(int index) {
    if (_aspectControllers.length > 1) {
      setState(() {
        final controller = _aspectControllers.removeAt(index);
        controller.dispose();
        _aspectVersion.value++;
      });
    }
  }

  Future<void> _save() async {
    final String domainName = InputSanitizer.trimPlainText(
      _domainNameController.text,
      maxLength: 255,
    );
    final List<String> aspects = _aspectControllers
        .map(
          (TextEditingController controller) =>
              InputSanitizer.trimPlainText(controller.text, maxLength: 255),
        )
        .where((String value) => value.isNotEmpty)
        .toList();

    if (domainName.isEmpty || aspects.isEmpty) {
      return;
    }

    try {
      await ref
          .read(assessmentListControllerProvider.notifier)
          .addDomain(widget.activityId, domainName, aspects);

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Domain berhasil ditambahkan')),
      );
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan domain: $error'),
          backgroundColor: AppTheme.error,
        ),
      );
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
          'Tambah Domain',
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
                  'Nama Domain',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.sogan,
                  ),
                ),
                AppSpacing.gapH8,
                TextField(
                  controller: _domainNameController,
                  textInputAction: TextInputAction.next,
                  maxLength: 255,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama domain',
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
                AppSpacing.gapH24,
                Text(
                  'Tambah Aspek',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppTheme.sogan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.gapH24,
                ValueListenableBuilder<int>(
                  valueListenable: _aspectVersion,
                  builder: (context, value, child) {
                    return DynamicAspectFields(
                      controllers: _aspectControllers,
                      onAdd: _addAspect,
                      onRemove: _removeAspect,
                    );
                  },
                ),
                AppSpacing.gapH24,
                EthnoButton(
                  onPressed: _save,
                  label: 'Tambahkan',
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
