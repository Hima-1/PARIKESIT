import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';

class ShortcutItem {
  const ShortcutItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

class AppShortcutGrid extends StatelessWidget {
  const AppShortcutGrid({
    super.key,
    required this.items,
    this.title = 'Pintasan',
  });
  final List<ShortcutItem> items;
  final String title;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.sogan,
            ),
          ),
        ),
        AppSpacing.gapH16,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: isMobile ? 1.15 : 0.85,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildShortcutItem(context, item);
          },
        ),
      ],
    );
  }

  Widget _buildShortcutItem(BuildContext context, ShortcutItem item) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: AppTheme.hairlineBorder,
              ),
              child: Icon(item.icon, color: item.color, size: 24),
            ),
          ),
        ),
        AppSpacing.gapH8,
        Text(
          item.label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.sogan,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
