import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../../../../core/theme/app_theme.dart';

class EvaluationNoteCard extends StatelessWidget {
  const EvaluationNoteCard({super.key, required this.role, required this.note});

  final String role;
  final String note;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color roleColor = _getRoleColor(role);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.shellSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sogan.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: AppSpacing.pH16V8,
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 14,
                  color: roleColor,
                ),
                AppSpacing.gapW8,
                Text(
                  'CATATAN ${role.toUpperCase()}',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: roleColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSpacing.pAll16,
            child: Text(
              note,
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.sogan.withValues(alpha: 0.85),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    final r = role.toLowerCase();
    if (r.contains('admin') || r.contains('bps')) return AppTheme.sogan;
    if (r.contains('wali')) return AppTheme.gold;
    return AppTheme.success;
  }
}
