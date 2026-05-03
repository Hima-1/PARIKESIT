import 'package:flutter/material.dart';
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
      icon: Icons.check_circle_outline,
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
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppTheme.sogaRed,
      icon: Icons.error_outline,
    );
  }

  static void showInfo(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    _showWithMessenger(
      messenger,
      message: message,
      backgroundColor: AppTheme.pusaka,
      icon: Icons.info_outline,
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
