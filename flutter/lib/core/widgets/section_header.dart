import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

import 'ethno_button.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onActionPressed,
    this.actionLabel = 'Lihat Semua',
    this.padding,
  });

  final String title;
  final VoidCallback? onActionPressed;
  final String actionLabel;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? AppSpacing.pH8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onActionPressed != null)
            EthnoButton(
              onPressed: onActionPressed,
              label: actionLabel,
              style: EthnoButtonStyle.text,
              size: EthnoButtonSize.small,
            ),
        ],
      ),
    );
  }
}
