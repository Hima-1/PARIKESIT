import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PublicLandingBottomNavItem {
  const PublicLandingBottomNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// Flat bottom nav: hairline top divider, terracotta indicator, no shadow.
class PublicLandingBottomNav extends StatelessWidget {
  const PublicLandingBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<PublicLandingBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List<Widget>.generate(items.length, (index) {
            final PublicLandingBottomNavItem item = items[index];
            final bool isSelected = index == currentIndex;
            final Color tone = isSelected
                ? AppTheme.terracotta
                : AppTheme.textMuted;

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isSelected
                            ? AppTheme.terracotta
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, size: 20, color: tone),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: tone,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
