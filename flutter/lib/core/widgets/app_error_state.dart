import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../theme/app_theme.dart';
import 'ethno_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pAll24,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.alertCircle, color: AppTheme.error, size: 48),
            AppSpacing.gapH16,
            Text(
              'Terjadi Kesalahan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapH8,
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.sogan.withValues(alpha: 0.7),
              ),
            ),
            if (onRetry != null) ...[
              AppSpacing.gapH24,
              EthnoButton(
                onPressed: onRetry,
                icon: LucideIcons.refreshCw,
                label: 'Coba Lagi',
                style: EthnoButtonStyle.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
