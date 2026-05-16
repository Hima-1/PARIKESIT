import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/tokens/radii.dart';

class AppPaginationFooter extends StatelessWidget {
  const AppPaginationFooter({
    super.key,
    required this.currentPage,
    required this.lastPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int lastPage;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final status = Text(
      'Halaman $currentPage dari $lastPage',
      style: textTheme.bodySmall?.copyWith(
        color: scheme.onSurface.withValues(alpha: 0.72),
      ),
      textAlign: TextAlign.center,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _PaginationIconButton(
          tooltip: 'Halaman sebelumnya',
          icon: LucideIcons.chevronLeft,
          onPressed: hasPreviousPage ? onPrevious : null,
        ),
        const Gap(6),
        Flexible(child: status),
        const Gap(6),
        _PaginationIconButton(
          tooltip: 'Halaman berikutnya',
          icon: LucideIcons.chevronRight,
          onPressed: hasNextPage ? onNext : null,
        ),
      ],
    );
  }
}

class _PaginationIconButton extends StatelessWidget {
  const _PaginationIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return IconButton.outlined(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 18),
      color: scheme.onSurface,
      disabledColor: scheme.onSurface.withValues(alpha: 0.5),
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.rrSm),
        side: BorderSide(color: scheme.outline),
      ),
    );
  }
}
