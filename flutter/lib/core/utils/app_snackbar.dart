import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../theme/tokens/colors.dart';
import '../theme/tokens/radii.dart';

class AppSnackbar {
  AppSnackbar._();

  static void showSuccess(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppColors.success,
      icon: LucideIcons.checkCircle2,
    );
  }

  static void showSuccessWithMessenger(
    ScaffoldMessengerState messenger,
    String message,
  ) {
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppColors.success,
      icon: LucideIcons.checkCircle2,
    );
  }

  static void showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppColors.error,
      icon: LucideIcons.alertCircle,
    );
  }

  static void showInfo(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppColors.soganDeep,
      icon: LucideIcons.info,
    );
  }

  static void _showWithMessenger(
    ScaffoldMessengerState messenger, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            AppSpacing.gapW12,
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.rrMd),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
