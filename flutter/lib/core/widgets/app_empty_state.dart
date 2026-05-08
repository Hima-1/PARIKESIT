import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../theme/app_theme.dart';
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
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Container(
        width: double.infinity,
        padding: AppSpacing.pAll24,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: AppTheme.hairlineBorder,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.gold.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: AppTheme.sogan),
            ),
            AppSpacing.gapH16,
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.sogan,
              ),
            ),
            AppSpacing.gapH8,
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: AppTheme.sogan.withValues(alpha: 0.6),
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
  }
}
