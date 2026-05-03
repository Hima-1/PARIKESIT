import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

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

  Color _getForegroundColor(BuildContext context) {
    switch (style) {
      case EthnoButtonStyle.primary:
        return AppTheme.gold;
      case EthnoButtonStyle.secondary:
        return AppTheme.sogan;
      case EthnoButtonStyle.success:
        return AppTheme.onSuccess;
      case EthnoButtonStyle.outlined:
      case EthnoButtonStyle.text:
        return AppTheme.sogan;
      case EthnoButtonStyle.danger:
        return AppTheme.onError;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case EthnoButtonSize.small:
        return AppSpacing.pH16V8;
      case EthnoButtonSize.medium:
        return AppSpacing.pV16.add(AppSpacing.pH24);
    }
  }

  double _getFontSize(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    switch (size) {
      case EthnoButtonSize.small:
        return (textTheme.bodySmall?.fontSize ?? 12) + 1; // 13
      case EthnoButtonSize.medium:
        return (textTheme.bodyMedium?.fontSize ?? 14) + 1; // 15
    }
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = _getForegroundColor(context);
    final padding = _getPadding();
    final fontSize = _getFontSize(context);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: fontSize + 3,
            height: fontSize + 3,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: fontSize + 5),
            AppSpacing.gapW8,
          ],
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
        ],
      ],
    );

    if (isFullWidth) {
      content = SizedBox(width: double.infinity, child: content);
    }

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
    );

    switch (style) {
      case EthnoButtonStyle.primary:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.sogan,
            foregroundColor: foregroundColor,
            padding: padding,
            shape: shape,
          ),
          child: content,
        );
      case EthnoButtonStyle.secondary:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.gold,
            foregroundColor: foregroundColor,
            padding: padding,
            shape: shape,
          ),
          child: content,
        );
      case EthnoButtonStyle.success:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.success,
            foregroundColor: foregroundColor,
            padding: padding,
            shape: shape,
          ),
          child: content,
        );
      case EthnoButtonStyle.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            side: BorderSide(color: foregroundColor),
            padding: padding,
            shape: shape,
          ),
          child: content,
        );
      case EthnoButtonStyle.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor,
            padding: padding,
            shape: shape,
          ),
          child: content,
        );
      case EthnoButtonStyle.danger:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.error,
            foregroundColor: foregroundColor,
            padding: padding,
            shape: shape,
          ),
          child: content,
        );
    }
  }
}
