import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/ethno_card.dart';

class DokumentasiListItem extends StatelessWidget {
  const DokumentasiListItem({
    super.key,
    required this.title,
    required this.date,
    required this.author,
    required this.onTap,
  });

  final String title;
  final DateTime date;
  final String author;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat('dd MMM yyyy', 'id_ID').format(date);

    return EthnoCard(
      isFlat: true,
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 16),
      padding: AppSpacing.pAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.sogan.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.fileText,
                  color: AppTheme.sogan,
                  size: 24,
                ),
              ),
              AppSpacing.gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppTheme.sogan,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AppSpacing.gapH4,
                    Text(
                      formattedDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppTheme.neutral,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: AppTheme.sogan),
            ],
          ),
          AppSpacing.gapH16,
          const Divider(height: 1, thickness: 0.5),
          AppSpacing.gapH12,
          Row(
            children: [
              Expanded(
                child: Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppTheme.neutral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AppSpacing.gapW8,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.sogan.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'LIHAT',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppTheme.sogan,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                    fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
