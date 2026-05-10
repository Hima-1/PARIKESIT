import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/app_spacing.dart';
import '../theme/tokens/colors.dart';
import '../theme/tokens/motion.dart';
import 'ethno_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final body = Padding(
      padding: AppSpacing.pAll24,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.alertCircle, color: scheme.error, size: 48),
            AppSpacing.gapH16,
            Text(
              'Terjadi Kesalahan',
              style: textTheme.titleLarge?.copyWith(
                color: scheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapH8,
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.soganDeep.withValues(alpha: 0.7),
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

    return motionEntrance(context, body);
  }
}
