import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class BreadcrumbItem {
  const BreadcrumbItem({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;
}

class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({super.key, required this.items});

  final List<BreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          final item = entry.value;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.onTap != null && !isLast)
                GestureDetector(
                  onTap: item.onTap,
                  child: Text(
                    item.label,
                    style: textTheme.labelMedium?.copyWith(
                      color: AppTheme.terracotta,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Text(
                  item.label,
                  style: textTheme.labelMedium?.copyWith(
                    color: isLast ? AppTheme.textStrong : AppTheme.textMuted,
                    fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    LucideIcons.chevronRight,
                    size: 14,
                    color: AppTheme.textSubtle,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
