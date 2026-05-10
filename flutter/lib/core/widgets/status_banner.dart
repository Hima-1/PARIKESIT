import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/theme/tokens/motion.dart';

enum StatusBannerType { success, error, warning, info }

class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.message,
    this.type = StatusBannerType.info,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });

  final String message;
  final StatusBannerType type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;

  Color _getPrimaryColor() {
    switch (type) {
      case StatusBannerType.success:
        return AppTheme.success;
      case StatusBannerType.error:
        return AppTheme.error;
      case StatusBannerType.warning:
        return AppTheme.warning;
      case StatusBannerType.info:
        return AppTheme.info;
    }
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case StatusBannerType.success:
        return LucideIcons.checkCircle2;
      case StatusBannerType.error:
        return LucideIcons.alertCircle;
      case StatusBannerType.warning:
        return LucideIcons.alertTriangle;
      case StatusBannerType.info:
        return LucideIcons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = foregroundColor ?? _getPrimaryColor();
    final bgColor = backgroundColor ?? primaryColor.withValues(alpha: 0.1);

    final body = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12).add(AppSpacing.pH16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon ?? _getDefaultIcon(), color: primaryColor, size: 20),
          AppSpacing.gapW12,
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return motionEntrance(
      context,
      body,
      slideY: -0.1,
      fadeDuration: AppMotion.fast,
      curve: AppMotion.emphasized,
    );
  }
}
