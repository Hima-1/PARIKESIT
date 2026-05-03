import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/file_upload_field.dart';
import 'package:parikesit/core/widgets/status_banner.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';

import '../../../core/widgets/maturity_selector.dart';
import '../domain/assessment_indikator.dart';
import '../domain/penilaian.dart';
import 'controller/assessment_controller.dart';
import 'models/evidence_attachment.dart';
import 'widgets/evidence_link_tile.dart';

class IndicatorDetailScreen extends ConsumerStatefulWidget {
  const IndicatorDetailScreen({
    super.key,
    required this.formulirId,
    required this.indicatorId,
    required this.indicatorName,
  });

  final int formulirId;
  final int indicatorId;
  final String indicatorName;

  @override
  ConsumerState<IndicatorDetailScreen> createState() =>
      _IndicatorDetailScreenState();
}

class _IndicatorDetailScreenState extends ConsumerState<IndicatorDetailScreen> {
  double _selectedScore = 1.0;
  final _catatanController = TextEditingController();
  List<String> _evidencePaths = const <String>[];
  bool _isInitialized = false;

  void _updateEvidencePaths(List<String> paths) {
    setState(() => _evidencePaths = List<String>.from(paths));
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  void _saveDraft() async {
    try {
      final controller = ref.read(
        assessmentFormControllerProvider(widget.formulirId).notifier,
      );

      await controller.saveDraftAssessment(
        indikatorId: widget.indicatorId,
        nilai: _selectedScore,
        catatan: _catatanController.text,
        filePaths: _evidencePaths,
      );

      if (!mounted) return;
      await HapticFeedback.heavyImpact();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil menyimpan draft')));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.formulirId <= 0 || widget.indicatorId <= 0) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Detail Indikator')),
        body: const Center(
          child: Text('Data formulir atau indikator tidak valid.'),
        ),
      );
    }

    final AssessmentIndikator? indikator = _findIndikatorFromState();
    final Penilaian? penilaian = _findPenilaianFromState();
    final List<EvidenceAttachment> existingEvidence = buildEvidenceAttachments(
      penilaian?.buktiDukung,
    );

    if (!_isInitialized && penilaian != null) {
      _selectedScore = penilaian.nilai;
      _catatanController.text = penilaian.catatan ?? '';
      _isInitialized = true;
    }

    // Lock once Walidata has corrected or Admin has finalized the evaluation.
    final bool isLocked =
        (penilaian?.nilaiDiupdate != null && penilaian!.nilaiDiupdate! > 0) ||
        (penilaian?.evaluasi != null && penilaian!.evaluasi!.isNotEmpty);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Detail Indikator')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: AppSpacing.pPage,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLocked) ...[
                  const StatusBanner(
                    message:
                        'Penilaian ini telah dikunci karena sudah dalam tahap koreksi atau evaluasi oleh BPS.',
                    type: StatusBannerType.info,
                  ),
                  AppSpacing.gapH16,
                ],
                _buildHeader(indikator),
                AppSpacing.gapH24,
                _buildScoreSelection(indikator, penilaian, isLocked),
                AppSpacing.gapH24,
                RepaintBoundary(child: _buildNotesField(isLocked)),
                AppSpacing.gapH24,
                RepaintBoundary(
                  child: AbsorbPointer(
                    absorbing: isLocked,
                    child: Opacity(
                      opacity: isLocked ? 0.6 : 1.0,
                      child: FileUploadField(
                        label: 'Unggah Bukti Dukung',
                        initialPaths: _evidencePaths,
                        allowedExtensions: const <String>[
                          'pdf',
                          'jpg',
                          'jpeg',
                          'png',
                          'doc',
                          'docx',
                        ],
                        allowMultiple: true,
                        maxFiles: 3,
                        onChanged: (_) {},
                        onFilesChanged: _updateEvidencePaths,
                      ),
                    ),
                  ),
                ),
                if (existingEvidence.isNotEmpty && !isLocked) ...[
                  AppSpacing.gapH12,
                  Text(
                    'Memilih berkas baru akan mengganti bukti dukung yang sudah tersimpan.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutral,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (existingEvidence.isNotEmpty) ...[
                  AppSpacing.gapH16,
                  _buildExistingEvidence(existingEvidence),
                ],
                AppSpacing.gapH32,
                EthnoButton(
                  onPressed: isLocked ? null : _saveDraft,
                  label: 'SIMPAN DRAFT PENILAIAN',
                  isFullWidth: true,
                ),
                AppSpacing.gapH24,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Penilaian? _findPenilaianFromState() {
    final AssessmentFormState? state = ref
        .watch(assessmentFormControllerProvider(widget.formulirId))
        .asData
        ?.value;

    return state?.draftsByIndikatorId[widget.indicatorId];
  }

  AssessmentIndikator? _findIndikatorFromState() {
    final AssessmentFormState? state = ref
        .watch(assessmentFormControllerProvider(widget.formulirId))
        .asData
        ?.value;

    if (state == null) {
      return null;
    }

    for (final domain in state.formulir?.domains ?? const <DomainModel>[]) {
      for (final aspect in domain.aspects) {
        for (final indicator in aspect.indicators) {
          if (int.tryParse(indicator.id) == widget.indicatorId) {
            return indicator.toAssessmentIndikator(
              aspectId: aspect.id,
              aspectName: aspect.name,
              domainName: domain.name,
            );
          }
        }
      }
    }

    for (final AssessmentIndikator indikator in state.indikators) {
      if (indikator.id == widget.indicatorId) {
        return indikator;
      }
    }

    return null;
  }

  Widget _buildHeader(AssessmentIndikator? indikator) {
    final textTheme = Theme.of(context).textTheme;
    final state = ref
        .watch(assessmentFormControllerProvider(widget.formulirId))
        .asData
        ?.value;

    String breadcrumb = 'Indikator';
    if (state?.formulir != null) {
      for (final domain in state!.formulir!.domains) {
        for (final aspect in domain.aspects) {
          if (aspect.indicators.any(
            (ind) => int.tryParse(ind.id) == widget.indicatorId,
          )) {
            breadcrumb = '${domain.name} > ${aspect.name}';
            break;
          }
        }
      }
    }

    return EthnoCard(
      isFlat: true,
      showBatikAccent: true,
      padding: AppSpacing.pAll20,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            breadcrumb.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppTheme.gold,
              letterSpacing: 1.2,
              fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
            ),
          ),
          AppSpacing.gapH12,
          Text(
            widget.indicatorName,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppTheme.sogan,
              height: 1.3,
            ),
          ),
          AppSpacing.gapH16,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildMetaPill(
                label: 'Kode Indikator',
                value: indikator?.kodeIndikator ?? '-',
              ),
              _buildMetaPill(
                label: 'Domain',
                value: indikator?.namaDomain ?? '-',
              ),
              _buildMetaPill(
                label: 'Aspek',
                value: indikator?.namaAspek ?? '-',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaPill({required String label, required String value}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.shellSurfaceSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: AppTheme.neutral,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          AppSpacing.gapH4,
          Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSelection(
    AssessmentIndikator? indikator,
    Penilaian? penilaian,
    bool isLocked,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final int currentLevel = _selectedScore.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Tingkat Penilaian',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.sogan,
            ),
          ),
        ),
        AppSpacing.gapH16,
        MaturitySelector(
          selectedScore: _selectedScore,
          onChanged: (value) {
            HapticFeedback.selectionClick();
            setState(() => _selectedScore = value);
          },
          enabled: !isLocked,
          walidataScore: penilaian?.nilaiDiupdate,
        ),
        AppSpacing.gapH16,
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Tingkat Kriteria',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.sogan,
            ),
          ),
        ),
        AppSpacing.gapH16,
        ...List<Widget>.generate(5, (int index) {
          final int level = index + 1;
          final bool isSelected = currentLevel == level;
          final String criteria = _getCriteriaForLevel(indikator, level);

          return EthnoCard(
            key: ValueKey('criteria_$level'),
            isFlat: true,
            elevation: 0,
            padding: AppSpacing.pAll16,
            margin: const EdgeInsets.only(left: 2, right: 2, bottom: 10),
            borderColor: isSelected
                ? AppTheme.gold
                : AppTheme.sogan.withValues(alpha: 0.12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.gold
                            : AppTheme.shellSurfaceSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'LEVEL $level',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppTheme.sogan,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (isSelected) ...[
                      AppSpacing.gapW8,
                      Text(
                        'Dipilih',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
                AppSpacing.gapH16,
                Text(
                  criteria,
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: AppTheme.sogan.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _getCriteriaForLevel(AssessmentIndikator? indikator, int level) {
    final String? criteria = indikator?.effectiveLevelKriteria(
      level,
      indicatorCode: indikator.kodeIndikator,
    );

    if (criteria != null && criteria.trim().isNotEmpty) {
      return criteria;
    }

    return 'Kriteria belum tersedia untuk level ini.';
  }

  Widget _buildNotesField(bool isLocked) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Catatan / Penjelasan',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.sogan,
            ),
          ),
        ),
        AppSpacing.gapH12,
        TextField(
          controller: _catatanController,
          maxLines: 4,
          enabled: !isLocked,
          decoration: InputDecoration(
            hintText: 'Masukkan penjelasan mengenai penilaian indikator ini...',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: AppTheme.sogan.withValues(alpha: 0.35),
            ),
          ),
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildExistingEvidence(List<EvidenceAttachment> files) {
    final textTheme = Theme.of(context).textTheme;

    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Bukti Dukung Tersimpan',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.success,
            ),
          ),
        ),
        AppSpacing.gapH12,
        ...files.map(
          (EvidenceAttachment file) => EvidenceLinkTile(
            fileName: file.fileName,
            fileUrl: file.fileUrl,
            fileSizeLabel: file.fileSizeLabel,
          ),
        ),
      ],
    );
  }
}
