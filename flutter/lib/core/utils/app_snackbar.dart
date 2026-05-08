import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../theme/app_theme.dart';

class AppSnackbar {
  AppSnackbar._();

  static void showSuccess(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppTheme.jatiGreen,
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
      backgroundColor: AppTheme.jatiGreen,
      icon: LucideIcons.checkCircle2,
    );
  }

  static void showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppTheme.sogaRed,
      icon: LucideIcons.alertCircle,
    );
  }

  static void showInfo(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppTheme.pusaka,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
