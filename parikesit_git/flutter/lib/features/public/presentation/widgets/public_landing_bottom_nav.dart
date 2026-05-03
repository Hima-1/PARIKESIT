import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PublicLandingBottomNavItem {
  const PublicLandingBottomNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.sogan.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List<Widget>.generate(items.length, (index) {
            final PublicLandingBottomNavItem item = items[index];
            final bool isSelected = index == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isSelected ? AppTheme.gold : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    color: isSelected
                        ? AppTheme.gold.withValues(alpha: 0.08)
                        : Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected
                            ? AppTheme.sogan
                            : AppTheme.sogan.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: isSelected
                                  ? AppTheme.sogan
                                  : AppTheme.sogan.withValues(alpha: 0.5),
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.w700,
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
