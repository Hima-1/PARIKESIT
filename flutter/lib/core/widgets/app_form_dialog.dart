import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/app_spacing.dart';
import '../theme/tokens/radii.dart';
import 'ethno_button.dart';

/// Standard layout for modal forms: title + close button, scrollable body,
/// and a footer with secondary (cancel) + primary (submit) actions.
///
/// Screens should compose form fields into [body]; this widget owns the
/// chrome, scrolling behavior, and the busy state on the primary action.
class AppFormDialog extends StatelessWidget {
  const AppFormDialog({
    super.key,
    required this.title,
    required this.body,
    required this.onSubmit,
    this.onCancel,
    this.submitLabel = 'Simpan',
    this.cancelLabel = 'Batal',
    this.isSubmitting = false,
    this.maxWidth = 560,
  });

  final String title;
  final Widget body;
  final VoidCallback onSubmit;
  final VoidCallback? onCancel;
  final String submitLabel;
  final String cancelLabel;
  final bool isSubmitting;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(16, 24, 16, 24 + viewInsets.bottom),
      shape: RoundedRectangleBorder(borderRadius: AppRadii.rrMd),
      backgroundColor: scheme.surface,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: textTheme.titleLarge)),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    tooltip: 'Tutup',
                    onPressed: isSubmitting
                        ? null
                        : (onCancel ?? () => Navigator.of(context).pop()),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: AppSpacing.pAll20,
                child: body,
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  EthnoButton(
                    onPressed: isSubmitting
                        ? null
                        : (onCancel ?? () => Navigator.of(context).pop()),
                    label: cancelLabel,
                    style: EthnoButtonStyle.text,
                    size: EthnoButtonSize.small,
                  ),
                  AppSpacing.gapW8,
                  EthnoButton(
                    onPressed: isSubmitting ? null : onSubmit,
                    label: submitLabel,
                    style: EthnoButtonStyle.primary,
                    size: EthnoButtonSize.small,
                    isLoading: isSubmitting,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
