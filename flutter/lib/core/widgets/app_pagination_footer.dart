import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final status = Text(
      'Halaman $currentPage dari $lastPage',
      style: textTheme.bodySmall?.copyWith(color: AppTheme.neutral),
      textAlign: TextAlign.center,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _PaginationIconButton(
          tooltip: 'Halaman sebelumnya',
          icon: Icons.chevron_left_rounded,
          onPressed: hasPreviousPage ? onPrevious : null,
        ),
        const SizedBox(width: 6),
        Flexible(child: status),
        const SizedBox(width: 6),
        _PaginationIconButton(
          tooltip: 'Halaman berikutnya',
          icon: Icons.chevron_right_rounded,
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
    return IconButton.outlined(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
      color: AppTheme.sogan,
      disabledColor: AppTheme.neutral.withValues(alpha: 0.38),
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        side: BorderSide(
          color: onPressed == null
              ? AppTheme.neutral.withValues(alpha: 0.38)
              : AppTheme.sogan,
        ),
      ),
    );
  }
}
