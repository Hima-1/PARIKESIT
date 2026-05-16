import 'package:flutter/material.dart';
import '../theme/tokens/radii.dart';
import '../widgets/ethno_button.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String content,
    String confirmLabel = 'Ya, Lanjutkan',
    String cancelLabel = 'Batal',
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: isDanger ? scheme.error : scheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(content),
          actions: [
            EthnoButton(
              onPressed: () => Navigator.pop(context, false),
              label: cancelLabel,
              style: EthnoButtonStyle.text,
              size: EthnoButtonSize.small,
            ),
            EthnoButton(
              onPressed: () => Navigator.pop(context, true),
              label: confirmLabel,
              style: isDanger
                  ? EthnoButtonStyle.danger
                  : EthnoButtonStyle.primary,
              size: EthnoButtonSize.small,
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: AppRadii.rrMd),
          backgroundColor: scheme.surfaceContainerHighest,
        );
      },
    );
  }
}
