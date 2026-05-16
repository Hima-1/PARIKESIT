import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/tokens/radii.dart';

class AppAddIconButton extends StatelessWidget {
  const AppAddIconButton({
    super.key,
    required this.onPressed,
    required this.tooltip,
  });

  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return IconButton.filled(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: const Icon(LucideIcons.plus),
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: scheme.secondary,
        foregroundColor: scheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.rrSm),
      ),
    );
  }
}
