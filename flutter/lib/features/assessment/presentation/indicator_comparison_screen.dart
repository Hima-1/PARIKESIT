import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/auth/role_access.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/status_banner.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:parikesit/features/assessment/presentation/helpers/indicator_review_resolver.dart';
import 'package:parikesit/features/assessment/presentation/helpers/review_route_context.dart';
import 'package:parikesit/features/assessment/presentation/indicator_read_only_review_screen.dart';
import 'package:parikesit/features/assessment/presentation/models/indicator_review_models.dart';
import 'package:parikesit/features/assessment/presentation/widgets/audit_interaction_panel.dart';
import 'package:parikesit/features/assessment/presentation/widgets/indicator_review_widgets.dart';

class IndicatorComparisonScreen extends StatelessWidget {
  const IndicatorComparisonScreen({
    super.key,
    required this.activityId,
    required this.domainId,
    required this.indicatorId,
    required this.isSelfReview,
    this.opdId,
    this.data,
    this.indicatorComparisons = const <IndicatorComparisonData>[],
    this.currentIndex = 0,
  });

  final String activityId;
  final String domainId;
  final String indicatorId;
  final bool isSelfReview;
  final String? opdId;
  final IndicatorComparisonData? data;
  final List<IndicatorComparisonData> indicatorComparisons;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    if (isSelfReview) {
      return IndicatorReadOnlyReviewScreen(
        activityId: activityId,
        domainId: domainId,
        indicatorId: indicatorId,
        data: data,
        indicatorComparisons: indicatorComparisons,
        currentIndex: currentIndex,
      );
    }

    return IndicatorReviewerScreen(
      activityId: activityId,
      domainId: domainId,
      indicatorId: indicatorId,
      opdId: opdId,
      data: data,
      indicatorComparisons: indicatorComparisons,
      currentIndex: currentIndex,
    );
  }
}

class IndicatorReviewerScreen extends ConsumerWidget {
  const IndicatorReviewerScreen({
    super.key,
    required this.activityId,
    required this.domainId,
    required this.indicatorId,
    this.opdId,
    this.data,
    this.indicatorComparisons = const <IndicatorComparisonData>[],
    this.currentIndex = 0,
  });

  final String activityId;
  final String domainId;
  final String indicatorId;
  final String? opdId;
  final IndicatorComparisonData? data;
  final List<IndicatorComparisonData> indicatorComparisons;
  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? resolvedOpdId = resolveReviewOpdId(
      context,
      isSelfReview: false,
      opdId: opdId,
    );
    final bool hasMissingReviewContext = resolvedOpdId == null;
    final int? activityIdInt = int.tryParse(activityId);
    final int? indicatorIdInt = int.tryParse(indicatorId);
    final AssessmentFormState? formState = activityIdInt == null
        ? null
        : ref
              .watch(assessmentFormControllerProvider(activityIdInt))
              .asData
              ?.value;
    final List<IndicatorComparisonData> resolvedComparisons =
        resolveIndicatorComparisonList(
          snapshots: indicatorComparisons.isNotEmpty
              ? indicatorComparisons
              : (data != null
                    ? <IndicatorComparisonData>[data!]
                    : const <IndicatorComparisonData>[]),
          formState: formState,
        );
    final IndicatorComparisonData? currentData = resolveIndicatorComparisonData(
      indicatorId: indicatorId,
      routeData: data,
      snapshots: resolvedComparisons,
      formState: formState,
    );

    if (currentData == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Tinjau Indikator')),
        body: const Center(child: Text('Data indikator tidak tersedia.')),
      );
    }

    final UserRole userRole = ref.watch(userRoleProvider);
    final bool canWalidataCorrect =
        !hasMissingReviewContext &&
        RoleAccess.canPerform(userRole, RoleAction.walidataCorrection);
    final bool canAdminEvaluate =
        !hasMissingReviewContext &&
        RoleAccess.canPerform(userRole, RoleAction.adminFinalEvaluation);
    final bool isAdmin = userRole == UserRole.admin;
    final bool isLocked = currentData.adminScore > 0;
    final bool isWaitingForWalidata = isAdmin && currentData.walidataScore == 0;
    final bool showAction = canWalidataCorrect || canAdminEvaluate;
    final bool canOpenAuditModal =
        showAction &&
        !hasMissingReviewContext &&
        !isLocked &&
        !isWaitingForWalidata &&
        activityIdInt != null &&
        indicatorIdInt != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Tinjau Indikator'),
        actions: [
          IndicatorReviewCounter(
            currentIndex: currentIndex,
            totalCount: resolvedComparisons.length,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pPage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasMissingReviewContext) ...[
              const StatusBanner(
                message: missingReviewOpdContextMessage,
                type: StatusBannerType.warning,
                icon: Icons.link_off_rounded,
              ),
              AppSpacing.gapH16,
            ] else if (isLocked) ...[
              const StatusBanner(
                message:
                    'Penilaian ini telah dievaluasi oleh Admin BPS dan bersifat final.',
                type: StatusBannerType.success,
              ),
              AppSpacing.gapH16,
            ] else if (isWaitingForWalidata) ...[
              const StatusBanner(
                message:
                    'Silakan menunggu penilaian dari Walidata terlebih dahulu.',
                type: StatusBannerType.warning,
                icon: Icons.hourglass_empty_rounded,
              ),
              AppSpacing.gapH16,
            ],
            IndicatorReviewContent(currentData: currentData),
          ],
        ),
      ),
      bottomNavigationBar: IndicatorReviewNavigationFooter(
        activityId: activityId,
        domainId: domainId,
        currentIndex: currentIndex,
        indicatorComparisons: resolvedComparisons,
        isSelfReview: false,
        opdId: resolvedOpdId,
        hasMissingReviewContext: hasMissingReviewContext,
        actionChild: showAction
            ? EthnoButton(
                onPressed: canOpenAuditModal
                    ? () => _openAuditModal(
                        context,
                        ref,
                        isAdmin: isAdmin,
                        activityIdInt: activityIdInt,
                        indicatorIdInt: indicatorIdInt,
                        currentData: currentData,
                      )
                    : null,
                label: isAdmin ? 'EVALUASI FINAL' : 'BERI KOREKSI',
                isFullWidth: true,
              )
            : null,
      ),
    );
  }

  Future<void> _openAuditModal(
    BuildContext context,
    WidgetRef ref, {
    required bool isAdmin,
    required int activityIdInt,
    required int indicatorIdInt,
    required IndicatorComparisonData currentData,
  }) async {
    final bool? didSave = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (BuildContext modalContext) => _IndicatorAuditFormScreen(
          title: isAdmin ? 'Evaluasi Akhir BPS' : 'Koreksi Walidata',
          buttonLabel: isAdmin ? 'SIMPAN EVALUASI' : 'SIMPAN KOREKSI',
          inputLabel: isAdmin
              ? 'Catatan Evaluasi Final'
              : 'Catatan Koreksi Walidata',
          initialScore: isAdmin
              ? currentData.adminScore.toInt()
              : currentData.walidataScore.toInt(),
          initialExplanation: _resolveRoleNote(
            currentData,
            isAdmin ? 'Admin' : 'Walidata',
          ),
          opdScore: currentData.opdScore,
          onSave: (int score, String explanation) async {
            final dynamic assessmentController = ref.read(
              assessmentFormControllerProvider(activityIdInt).notifier,
            );
            if (isAdmin) {
              await assessmentController.saveAdminEvaluation(
                indicatorId: indicatorIdInt,
                score: score.toDouble(),
                note: explanation,
              );
              return;
            }

            await assessmentController.saveWalidataCorrection(
              indicatorId: indicatorIdInt,
              score: score.toDouble(),
              note: explanation,
            );
          },
        ),
      ),
    );

    if (didSave == true && context.mounted) {
      final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
        context,
      );
      if (messenger != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                isAdmin
                    ? 'Evaluasi final berhasil disimpan.'
                    : 'Koreksi walidata berhasil disimpan.',
              ),
            ),
          );
      }
    }
  }
}

String _resolveRoleNote(IndicatorComparisonData data, String role) {
  return data.evaluationNotes
      .firstWhere(
        (RoleEvaluationNote note) => note.role == role,
        orElse: () => const RoleEvaluationNote(role: '', note: ''),
      )
      .note;
}

class _IndicatorAuditFormScreen extends StatelessWidget {
  const _IndicatorAuditFormScreen({
    required this.title,
    required this.buttonLabel,
    required this.inputLabel,
    required this.initialScore,
    required this.initialExplanation,
    required this.opdScore,
    required this.onSave,
  });

  final String title;
  final String buttonLabel;
  final String inputLabel;
  final int initialScore;
  final String initialExplanation;
  final double opdScore;
  final Future<void> Function(int score, String explanation) onSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: AppSpacing.pPage,
        children: [
          AuditInteractionPanel(
            title: title.toUpperCase(),
            buttonLabel: buttonLabel,
            inputLabel: inputLabel,
            initialScore: initialScore,
            initialExplanation: initialExplanation,
            opdScore: opdScore,
            onSave: (int score, String explanation) async {
              try {
                await onSave(score, explanation);
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan: $error')),
                    );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
