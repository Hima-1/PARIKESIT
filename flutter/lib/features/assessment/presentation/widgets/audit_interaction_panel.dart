import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/maturity_selector.dart';

class AuditInteractionPanel extends StatefulWidget {
  const AuditInteractionPanel({
    super.key,
    this.title = 'Koreksi Audit',
    this.buttonLabel = 'Simpan Koreksi',
    this.inputLabel = 'Penjelasan Koreksi',
    this.initialScore,
    this.initialExplanation,
    this.opdScore,
    this.onSave,
    this.enabled = true,
  });

  final String title;
  final String buttonLabel;
  final String inputLabel;
  final int? initialScore;
  final String? initialExplanation;
  final double? opdScore;
  final Future<void> Function(int score, String explanation)? onSave;
  final bool enabled;

  @override
  State<AuditInteractionPanel> createState() => _AuditInteractionPanelState();
}

class _AuditInteractionPanelState extends State<AuditInteractionPanel> {
  late final TextEditingController _controller;
  double _selectedScore = 1.0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedScore = (widget.initialScore ?? 1).toDouble().clamp(1.0, 5.0);
    _controller = TextEditingController(text: widget.initialExplanation ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isInteractive = widget.enabled && !_isSaving;
    final inputSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.inputLabel,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppTheme.sogan,
          ),
        ),
        AppSpacing.gapH12,
        TextField(
          controller: _controller,
          maxLines: 4,
          maxLength: 2000,
          enabled: isInteractive,
          decoration: InputDecoration(
            hintText: 'Tuliskan catatan evaluasi atau alasan koreksi...',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: AppTheme.sogan.withValues(alpha: 0.35),
            ),
          ),
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );

    return EthnoCard(
      isFlat: true,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.6,
        child: Padding(
          padding: AppSpacing.pAll24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: AppTheme.sogan.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              AppSpacing.gapH24,
              MaturitySelector(
                selectedScore: _selectedScore,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedScore = value);
                },
                enabled: isInteractive,
                opdScore: widget.opdScore,
              ),
              AppSpacing.gapH24,
              const Divider(height: 1, thickness: 0.5),
              AppSpacing.gapH24,
              RepaintBoundary(child: inputSection),
              AppSpacing.gapH24,
              EthnoButton(
                onPressed: isInteractive
                    ? () async {
                        unawaited(HapticFeedback.mediumImpact());
                        setState(() => _isSaving = true);
                        try {
                          await widget.onSave?.call(
                            _selectedScore.round(),
                            _controller.text.trim(),
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _isSaving = false);
                          }
                        }
                      }
                    : null,
                style: EthnoButtonStyle.primary,
                label: widget.buttonLabel,
                isFullWidth: true,
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
