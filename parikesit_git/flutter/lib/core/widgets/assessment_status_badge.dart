import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';

class AssessmentStatusBadge extends StatelessWidget {
  const AssessmentStatusBadge({super.key, required this.status});

  final PenilaianStatus status;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _styleFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusStyle.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: statusStyle.color.withValues(alpha: 0.2)),
      ),
      child: Text(
        statusStyle.label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: statusStyle.color,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          fontSize: 10,
        ),
      ),
    );
  }

  _StatusStyle _styleFor(PenilaianStatus value) {
    switch (value) {
      case PenilaianStatus.sent:
        return const _StatusStyle('Terkirim', AppTheme.navy);
      case PenilaianStatus.approved:
        return const _StatusStyle('Disetujui', AppTheme.success);
      case PenilaianStatus.rejected:
        return const _StatusStyle('Perlu Perbaikan', AppTheme.error);
      case PenilaianStatus.returned:
        return const _StatusStyle('Dikembalikan', AppTheme.gold);
      case PenilaianStatus.draft:
        return const _StatusStyle('Belum Lengkap', AppTheme.neutral);
    }
  }
}

class _StatusStyle {
  const _StatusStyle(this.label, this.color);

  final String label;
  final Color color;
}
