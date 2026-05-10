import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/app_spacing.dart';
import '../theme/tokens/colors.dart';
import '../theme/tokens/motion.dart';
import '../theme/tokens/radii.dart';
import 'ethno_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = LucideIcons.inbox,
    this.onAction,
    this.actionLabel,
    this.actionIcon,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final body = Center(
      child: Container(
        width: double.infinity,
        padding: AppSpacing.pAll24,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadii.rrMd,
          border: Border.all(color: scheme.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.secondary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: AppColors.soganDeep),
            ),
            AppSpacing.gapH16,
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.soganDeep,
              ),
            ),
            AppSpacing.gapH8,
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: AppColors.soganDeep.withValues(alpha: 0.6),
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              AppSpacing.gapH24,
              EthnoButton(
                onPressed: onAction,
                label: actionLabel!,
                icon: actionIcon,
              ),
            ],
          ],
        ),
      ),
    );

    return motionEntrance(context, body);
  }
}
