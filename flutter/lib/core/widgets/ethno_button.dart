import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/tokens/colors.dart';
import '../theme/tokens/radii.dart';

enum EthnoButtonStyle { primary, secondary, success, outlined, text, danger }

enum EthnoButtonSize { small, medium }

class EthnoButton extends StatelessWidget {
  const EthnoButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.style = EthnoButtonStyle.primary,
    this.size = EthnoButtonSize.medium,
    this.isFullWidth = false,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final EthnoButtonStyle style;
  final EthnoButtonSize size;
  final bool isFullWidth;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final variant = _resolveVariant(scheme);
    final dims = _resolveDims(context);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: dims.fontSize + 3,
            height: dims.fontSize + 3,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(variant.foreground),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: dims.fontSize + 5),
            AppSpacing.gapW8,
          ],
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: dims.fontSize,
            ),
          ),
        ],
      ],
    );

    if (isFullWidth) {
      content = SizedBox(width: double.infinity, child: content);
    }

    final shape = RoundedRectangleBorder(borderRadius: AppRadii.rrMd);
    final effectiveOnPressed = isLoading ? null : onPressed;

    switch (style) {
      case EthnoButtonStyle.outlined:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: variant.foreground,
            side: BorderSide(color: variant.foreground),
            padding: dims.padding,
            shape: shape,
          ),
          child: content,
        );
      case EthnoButtonStyle.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: variant.foreground,
            padding: dims.padding,
            shape: shape,
          ),
          child: content,
        );
      case EthnoButtonStyle.primary:
      case EthnoButtonStyle.secondary:
      case EthnoButtonStyle.success:
      case EthnoButtonStyle.danger:
        return FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: variant.background,
            foregroundColor: variant.foreground,
            padding: dims.padding,
            shape: shape,
          ),
          child: content,
        );
    }
  }

  _Variant _resolveVariant(ColorScheme scheme) {
    switch (style) {
      case EthnoButtonStyle.primary:
        return _Variant(
          background: scheme.primary,
          foreground: scheme.onPrimary,
        );
      case EthnoButtonStyle.secondary:
        return _Variant(
          background: scheme.secondary,
          foreground: scheme.onSecondary,
        );
      case EthnoButtonStyle.success:
        return const _Variant(
          background: AppColors.success,
          foreground: AppColors.white,
        );
      case EthnoButtonStyle.danger:
        return _Variant(background: scheme.error, foreground: scheme.onError);
      case EthnoButtonStyle.outlined:
      case EthnoButtonStyle.text:
        return _Variant(
          background: Colors.transparent,
          foreground: scheme.secondary,
        );
    }
  }

  _Dims _resolveDims(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    switch (size) {
      case EthnoButtonSize.small:
        return _Dims(
          padding: AppSpacing.pH16V8,
          fontSize: textTheme.labelLarge?.fontSize ?? 13,
        );
      case EthnoButtonSize.medium:
        return _Dims(
          padding: AppSpacing.pV16.add(AppSpacing.pH24),
          fontSize: textTheme.titleMedium?.fontSize ?? 15,
        );
    }
  }
}

class _Variant {
  const _Variant({required this.background, required this.foreground});
  final Color background;
  final Color foreground;
}

class _Dims {
  const _Dims({required this.padding, required this.fontSize});
  final EdgeInsetsGeometry padding;
  final double fontSize;
}
