import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/app_error_mapper.dart';
import 'package:parikesit/core/widgets/app_empty_state.dart';
import 'package:parikesit/core/widgets/app_pagination_footer.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/ethno_patterns.dart';
import 'package:parikesit/core/widgets/skeleton_loader.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/presentation/controller/opd_selection_controller.dart';

class OpdSelectionScreen extends ConsumerWidget {
  const OpdSelectionScreen({
    super.key,
    required this.activityId,
    this.activity,
    this.isPublicReadOnly = false,
  });

  final String activityId;
  final AssessmentFormModel? activity;
  final bool isPublicReadOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opdsProvider = opdListProvider((
      activityId: activityId,
      isPublicReadOnly: isPublicReadOnly,
    ));
    final opdsState = ref.watch(opdsProvider);
    final opdsNotifier = ref.read(opdsProvider.notifier);
    final role = isPublicReadOnly ? null : ref.watch(userRoleProvider);
    final config = isPublicReadOnly
        ? _OpdSelectionRoleConfig.publicReadOnly
        : _OpdSelectionRoleConfig.fromRole(role);

    final body = opdsState.when(
      loading: _buildLoadingList,
      error: (error, stack) => _buildErrorList(context, error),
      data: (page) => _buildContent(
        context: context,
        page: page,
        config: config,
        role: role,
        onPreviousPage: opdsNotifier.previousPage,
        onNextPage: opdsNotifier.nextPage,
      ),
    );

    return Scaffold(
      backgroundColor: isPublicReadOnly ? AppTheme.merang : Colors.transparent,
      appBar: AppBar(title: Text(config.screenTitle)),
      body: RefreshIndicator(
        onRefresh: opdsNotifier.refreshOpds,
        child: isPublicReadOnly
            ? KawungBackground(opacity: 0.03, child: body)
            : body,
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      padding: AppSpacing.pAll16,
      itemCount: 5,
      separatorBuilder: (context, index) => AppSpacing.gapH12,
      itemBuilder: (context, index) => const ActivityCardSkeleton(),
    );
  }

  Widget _buildErrorList(BuildContext context, Object error) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.pAll16,
      children: [
        const SizedBox(height: 200),
        Center(
          child: Text(
            AppErrorMapper.toMessage(
              error,
              fallbackMessage: 'Gagal memuat daftar OPD. Silakan coba lagi.',
            ),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required PaginatedResponse<OpdModel> page,
    required _OpdSelectionRoleConfig config,
    required UserRole? role,
    required VoidCallback onPreviousPage,
    required VoidCallback onNextPage,
  }) {
    if (page.items.isEmpty) {
      return _buildEmptyList(config);
    }

    return Column(
      children: [
        Expanded(child: _buildOpdList(context, page, config, role)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: AppPaginationFooter(
            currentPage: page.meta.currentPage,
            lastPage: page.meta.lastPage,
            hasPreviousPage: page.hasPreviousPage,
            hasNextPage: page.hasNextPage,
            onPrevious: onPreviousPage,
            onNext: onNextPage,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyList(_OpdSelectionRoleConfig config) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.pAll16,
      children: [
        AppEmptyState(
          icon: LucideIcons.building2,
          title: config.emptyTitle,
          message: config.emptyMessage,
        ),
      ],
    );
  }

  Widget _buildOpdList(
    BuildContext context,
    PaginatedResponse<OpdModel> page,
    _OpdSelectionRoleConfig config,
    UserRole? role,
  ) {
    final opds = page.items;

    return ListView.separated(
      padding: AppSpacing.pAll16,
      itemCount: opds.length + 1,
      separatorBuilder: (context, index) => AppSpacing.gapH12,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _OpdSelectionHero(
            title: config.heroTitle,
            description: config.heroDescription,
            totalCount: page.meta.total,
            secondaryStatLabel: config.secondaryStatLabel,
            summaryActionLabel: config.summaryActionLabel,
            onSummaryTap: config.showSummaryAction
                ? () => _openSummary(context)
                : null,
          );
        }

        final opd = opds[index - 1];
        return _OpdItemCard(
          opd: opd,
          config: config,
          role: role,
          isPublicReadOnly: isPublicReadOnly,
          onTap: () => _openOpdReview(context, opd),
        );
      },
    );
  }

  void _openSummary(BuildContext context) {
    HapticFeedback.lightImpact();
    context.push(
      RouteConstants.assessmentSummary.replaceFirst(':activityId', activityId),
      extra: activity,
    );
  }

  void _openOpdReview(BuildContext context, OpdModel opd) {
    HapticFeedback.lightImpact();
    final route = isPublicReadOnly
        ? RouteConstants.publicAssessmentOpdReview
        : RouteConstants.assessmentOpdReview;

    context.push(
      route
          .replaceFirst(':activityId', activityId)
          .replaceFirst(':opdId', opd.id.toString()),
      extra: activity,
    );
  }
}

bool _hasScore(double? value) => value != null && value > 0;

String _identityValue(String? value) {
  final String? trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? '-' : trimmed;
}

enum _OpdWorkflowState { waiting, partial, complete }

class _OpdStatus {
  const _OpdStatus({
    required this.label,
    required this.color,
    required this.state,
  });

  final String label;
  final Color color;
  final _OpdWorkflowState state;
}

class _OpdSelectionRoleConfig {
  const _OpdSelectionRoleConfig({
    required this.screenTitle,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.heroTitle,
    required this.heroDescription,
    required this.primaryActionLabel,
    required this.secondaryStatLabel,
    required this.highlightColor,
    required this.showSummaryAction,
    this.summaryActionLabel,
  });

  final String screenTitle;
  final String emptyTitle;
  final String emptyMessage;
  final String heroTitle;
  final String heroDescription;
  final String primaryActionLabel;
  final String secondaryStatLabel;
  final Color highlightColor;
  final bool showSummaryAction;
  final String? summaryActionLabel;

  static _OpdSelectionRoleConfig fromRole(UserRole? role) {
    switch (role) {
      case UserRole.walidata:
        return const _OpdSelectionRoleConfig(
          screenTitle: 'Pilih OPD untuk Koreksi',
          emptyTitle: 'Belum ada OPD untuk koreksi.',
          emptyMessage:
              'OPD yang sudah mengirim penilaian akan muncul di halaman ini.',
          heroTitle: 'Daftar OPD siap koreksi',
          heroDescription:
              'Buka OPD yang sudah mengirim penilaian untuk mulai koreksi.',
          primaryActionLabel: 'Lanjutkan koreksi',
          secondaryStatLabel: 'Urutan standar',
          highlightColor: AppTheme.gold,
          showSummaryAction: true,
          summaryActionLabel: 'Lihat ringkasan perbandingan',
        );
      case UserRole.admin:
        return const _OpdSelectionRoleConfig(
          screenTitle: 'Pilih OPD untuk Evaluasi',
          emptyTitle: 'Belum ada OPD untuk evaluasi.',
          emptyMessage:
              'OPD yang sudah melalui koreksi walidata akan muncul di halaman ini.',
          heroTitle: 'Lihat daftar OPD untuk evaluasi',
          heroDescription:
              'Gunakan daftar ini untuk membuka OPD yang sudah melalui koreksi walidata.',
          primaryActionLabel: 'Mulai evaluasi',
          secondaryStatLabel: 'Urutan standar',
          highlightColor: AppTheme.success,
          showSummaryAction: true,
          summaryActionLabel: 'Buka ringkasan hasil akhir',
        );
      default:
        return const _OpdSelectionRoleConfig(
          screenTitle: 'Pilih OPD untuk Ditinjau',
          emptyTitle: 'Belum ada OPD untuk ditinjau.',
          emptyMessage:
              'OPD yang mengajukan penilaian akan muncul di halaman ini.',
          heroTitle: 'Lihat hasil penilaian per OPD',
          heroDescription:
              'Gunakan daftar ini untuk membuka detail hasil per OPD.',
          primaryActionLabel: 'Lihat detail',
          secondaryStatLabel: 'Urutan standar',
          highlightColor: AppTheme.sogan,
          showSummaryAction: false,
        );
    }
  }

  static const _OpdSelectionRoleConfig publicReadOnly = _OpdSelectionRoleConfig(
    screenTitle: 'Skor Akhir Per OPD',
    emptyTitle: 'Belum ada OPD untuk ditampilkan.',
    emptyMessage: 'Daftar OPD akan muncul setelah ada penilaian yang selesai.',
    heroTitle: 'Lihat skor akhir per OPD',
    heroDescription:
        'Halaman ini bersifat publik dan hanya menampilkan kontak serta skor akhir penilaian.',
    primaryActionLabel: 'Lihat rincian publik',
    secondaryStatLabel: 'Read-only',
    highlightColor: AppTheme.sogan,
    showSummaryAction: false,
  );
}

class _OpdSelectionHero extends StatelessWidget {
  const _OpdSelectionHero({
    required this.title,
    required this.description,
    required this.totalCount,
    required this.secondaryStatLabel,
    this.summaryActionLabel,
    this.onSummaryTap,
  });

  final String title;
  final String description;
  final int totalCount;
  final String secondaryStatLabel;
  final String? summaryActionLabel;
  final VoidCallback? onSummaryTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: AppSpacing.pAll20,
      decoration: BoxDecoration(
        color: AppTheme.sogan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroStatChip(label: '$totalCount OPD', color: Colors.white),
              _HeroStatChip(label: secondaryStatLabel, color: Colors.white70),
            ],
          ),
          AppSpacing.gapH16,
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
              height: 1.45,
            ),
          ),
          if (onSummaryTap != null && summaryActionLabel != null) ...[
            AppSpacing.gapH20,
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSummaryTap,
                icon: const Icon(LucideIcons.barChart3),
                label: Text(summaryActionLabel!),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.sogan,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroStatChip extends StatelessWidget {
  const _HeroStatChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OpdItemCard extends StatelessWidget {
  const _OpdItemCard({
    required this.opd,
    required this.config,
    required this.role,
    required this.isPublicReadOnly,
    required this.onTap,
  });

  final OpdModel opd;
  final _OpdSelectionRoleConfig config;
  final UserRole? role;
  final bool isPublicReadOnly;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final status = _buildStatus();
    final supportText = _buildSupportText(status);

    return EthnoCard(
      isFlat: true,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.sogan.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.building2,
                  color: AppTheme.sogan,
                  size: 22,
                ),
              ),
              AppSpacing.gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isPublicReadOnly) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [_buildStatusBadge(context, status)],
                      ),
                      AppSpacing.gapH8,
                    ],
                    if (isPublicReadOnly) ...[
                      Text(
                        opd.name,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppTheme.sogan,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      AppSpacing.gapH8,
                    ] else ...[
                      _IdentityRow(
                        icon: LucideIcons.building2,
                        label: 'Nama OPD',
                        value: opd.name,
                      ),
                      AppSpacing.gapH4,
                    ],
                    if (!isPublicReadOnly) ...[
                      _IdentityRow(
                        icon: LucideIcons.badge,
                        label: 'Jabatan',
                        value: _identityValue(opd.role),
                      ),
                      AppSpacing.gapH4,
                    ],
                    if (isPublicReadOnly)
                      _IconValueRow(
                        icon: LucideIcons.mail,
                        value: _identityValue(opd.email),
                      )
                    else
                      _IdentityRow(
                        icon: LucideIcons.phone,
                        label: 'Kontak',
                        value: _identityValue(opd.nomorTelepon),
                      ),
                    if (isPublicReadOnly && _hasScore(opd.opdScore)) ...[
                      AppSpacing.gapH12,
                      _ScoreRow(opd: opd),
                    ] else ...[
                      if (supportText.isNotEmpty) ...[
                        AppSpacing.gapH8,
                        Text(
                          supportText,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutral.withValues(alpha: 0.7),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: config.highlightColor),
            ],
          ),
          if (_hasScore(opd.opdScore) && !isPublicReadOnly) ...[
            AppSpacing.gapH16,
            const Divider(height: 1, thickness: 0.5),
            AppSpacing.gapH12,
            _ScoreRow(opd: opd),
            AppSpacing.gapH12,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.shellSurfaceSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      config.primaryActionLabel,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppTheme.sogan,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: config.highlightColor),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildSupportText(_OpdStatus status) {
    if (isPublicReadOnly) {
      if (_hasScore(opd.adminScore)) {
        return 'Skor akhir admin sudah tersedia untuk publik.';
      }
      if (_hasScore(opd.walidataScore)) {
        return 'Skor koreksi walidata sudah tersedia. Menunggu evaluasi final.';
      }
      return 'Skor mandiri OPD tersedia. Koreksi lanjutan belum ditampilkan penuh.';
    }

    if (role == UserRole.admin) {
      return switch (status.state) {
        _OpdWorkflowState.waiting =>
          'Belum ada evaluasi admin. Buka detail setelah koreksi walidata tersedia.',
        _OpdWorkflowState.partial =>
          'Evaluasi admin belum lengkap. Lanjutkan untuk menyelesaikan indikator tersisa.',
        _OpdWorkflowState.complete =>
          'Evaluasi admin lengkap. Buka detail untuk melihat ringkasan hasil indikator.',
      };
    }

    if (role == UserRole.walidata) {
      return switch (status.state) {
        _OpdWorkflowState.waiting => '',
        _OpdWorkflowState.partial =>
          'Koreksi walidata belum lengkap. Lanjutkan untuk menyelesaikan indikator tersisa.',
        _OpdWorkflowState.complete =>
          'Koreksi walidata lengkap. Buka detail untuk melihat ringkasan hasil indikator.',
      };
    }

    return 'Buka detail untuk melihat ringkasan hasil indikator.';
  }

  _OpdStatus _buildStatus() {
    if (isPublicReadOnly) {
      if (_hasScore(opd.adminScore)) {
        return const _OpdStatus(
          label: 'SKOR FINAL TERSEDIA',
          color: AppTheme.success,
          state: _OpdWorkflowState.complete,
        );
      }
      if (_hasScore(opd.walidataScore)) {
        return const _OpdStatus(
          label: 'SKOR WALIDATA TERSEDIA',
          color: AppTheme.gold,
          state: _OpdWorkflowState.partial,
        );
      }
      return const _OpdStatus(
        label: 'SKOR MANDIRI TERSEDIA',
        color: AppTheme.sogan,
        state: _OpdWorkflowState.waiting,
      );
    }

    final progress = switch (role) {
      UserRole.admin => opd.adminProgress,
      UserRole.walidata => opd.walidataProgress,
      _ => opd.opdProgress,
    };
    final total = opd.totalIndicators;
    final count = progress?.count ?? 0;

    if (total > 0 && count >= total) {
      return const _OpdStatus(
        label: 'SELESAI',
        color: AppTheme.success,
        state: _OpdWorkflowState.complete,
      );
    }

    if (count > 0 && total > 0) {
      return _OpdStatus(
        label: 'BELUM LENGKAP ($count/$total)',
        color: config.highlightColor,
        state: _OpdWorkflowState.partial,
      );
    }

    return const _OpdStatus(
      label: 'MENUNGGU TINJAUAN',
      color: AppTheme.neutral,
      state: _OpdWorkflowState.waiting,
    );
  }

  Widget _buildStatusBadge(BuildContext context, _OpdStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: status.color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: status.color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppTheme.neutral.withValues(alpha: 0.62)),
        AppSpacing.gapW8,
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '$label:',
                style: textTheme.bodySmall?.copyWith(
                  color: AppTheme.neutral,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              Text(
                value,
                style: textTheme.bodySmall?.copyWith(
                  color: label == 'Nama OPD'
                      ? AppTheme.sogan
                      : AppTheme.neutral.withValues(alpha: 0.78),
                  fontWeight: label == 'Nama OPD'
                      ? FontWeight.w800
                      : FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconValueRow extends StatelessWidget {
  const _IconValueRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppTheme.neutral.withValues(alpha: 0.62)),
        AppSpacing.gapW8,
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: AppTheme.neutral.withValues(alpha: 0.78),
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.opd});

  final OpdModel opd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ScoreInfo(
          label: 'MANDIRI',
          score: opd.opdScore ?? 0,
          color: AppTheme.sogan,
        ),
        AppSpacing.gapW24,
        _ScoreInfo(
          label: 'WALIDATA',
          score: opd.walidataScore ?? 0,
          color: AppTheme.gold,
        ),
        AppSpacing.gapW24,
        _ScoreInfo(
          label: 'FINAL',
          score: opd.adminScore ?? 0,
          color: AppTheme.success,
        ),
      ],
    );
  }
}

class _ScoreInfo extends StatelessWidget {
  const _ScoreInfo({
    required this.label,
    required this.score,
    required this.color,
  });
  final String label;
  final double score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            fontSize: 8,
            color: AppTheme.neutral,
            fontWeight: FontWeight.w800,
          ),
        ),
        AppSpacing.gapH4,
        Text(
          score.toStringAsFixed(2),
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: score > 0 ? color : AppTheme.neutral.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
