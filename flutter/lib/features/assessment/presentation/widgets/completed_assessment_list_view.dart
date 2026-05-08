import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_empty_state.dart';
import 'package:parikesit/core/widgets/app_pagination_footer.dart';
import 'package:parikesit/core/widgets/app_sort_dropdown_field.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';

class CompletedAssessmentListConfig {
  const CompletedAssessmentListConfig({
    required this.screenTitle,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.ctaLabel,
    required this.scoreLabel,
    required this.highlightColor,
    this.taskDescription,
  });

  final String screenTitle;
  final String emptyTitle;
  final String emptyMessage;
  final String? taskDescription;
  final String ctaLabel;
  final String scoreLabel;
  final Color highlightColor;

  static CompletedAssessmentListConfig fromRole(UserRole? role) {
    switch (role) {
      case UserRole.walidata:
        return const CompletedAssessmentListConfig(
          screenTitle: 'Antrian Koreksi',
          emptyTitle: 'Belum ada formulir untuk koreksi.',
          emptyMessage:
              'Formulir yang sudah selesai dinilai OPD akan tampil di sini untuk ditinjau walidata.',
          taskDescription: 'Tinjau skor OPD dan lanjutkan koreksi indikator.',
          ctaLabel: 'Lanjutkan koreksi',
          scoreLabel: 'Skor walidata',
          highlightColor: AppTheme.gold,
        );
      case UserRole.admin:
        return const CompletedAssessmentListConfig(
          screenTitle: 'Antrian Evaluasi Final',
          emptyTitle: 'Belum ada formulir untuk evaluasi final.',
          emptyMessage:
              'Formulir yang sudah dikoreksi walidata akan tampil di sini untuk dievaluasi admin.',
          taskDescription:
              'Validasi hasil koreksi dan tentukan evaluasi akhir per OPD.',
          ctaLabel: 'Mulai evaluasi',
          scoreLabel: 'Skor admin',
          highlightColor: AppTheme.success,
        );
      case UserRole.opd:
        return const CompletedAssessmentListConfig(
          screenTitle: 'Penilaian Selesai',
          emptyTitle: 'Belum ada penilaian selesai.',
          emptyMessage:
              'Penilaian yang telah Anda selesaikan akan tampil di halaman ini.',
          ctaLabel: 'Lihat hasil akhir',
          scoreLabel: 'Skor akhir',
          highlightColor: AppTheme.sogan,
        );
      default:
        return const CompletedAssessmentListConfig(
          screenTitle: 'Penilaian Selesai',
          emptyTitle: 'Belum ada penilaian selesai.',
          emptyMessage:
              'Penilaian yang telah selesai akan tampil di halaman ini.',
          taskDescription: 'Tinjau hasil penilaian yang tersedia.',
          ctaLabel: 'Lihat detail',
          scoreLabel: 'Skor',
          highlightColor: AppTheme.sogan,
        );
    }
  }

  static const CompletedAssessmentListConfig
  publicLanding = CompletedAssessmentListConfig(
    screenTitle: 'Penilaian Selesai',
    emptyTitle: 'Belum ada penilaian selesai.',
    emptyMessage:
        'Daftar penilaian yang sudah selesai akan tampil di halaman publik ini.',
    taskDescription: 'Lihat daftar formulir dan skor akhir per OPD.',
    ctaLabel: 'Lihat skor OPD',
    scoreLabel: 'Skor akhir',
    highlightColor: AppTheme.sogan,
  );
}

class CompletedAssessmentListView extends StatefulWidget {
  const CompletedAssessmentListView({
    super.key,
    required this.role,
    required this.state,
    required this.query,
    required this.config,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSortChanged,
    required this.onToggleSortDirection,
    required this.onRefresh,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onActivityTap,
    this.header,
  });

  final UserRole? role;
  final AsyncValue<PaginatedResponse<AssessmentFormModel>> state;
  final CompletedAssessmentQuery query;
  final CompletedAssessmentListConfig config;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<CompletedAssessmentSortField> onSortChanged;
  final VoidCallback onToggleSortDirection;
  final Future<void> Function() onRefresh;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final ValueChanged<AssessmentFormModel> onActivityTap;
  final Widget? header;

  @override
  State<CompletedAssessmentListView> createState() =>
      _CompletedAssessmentListViewState();
}

class _CompletedAssessmentListViewState
    extends State<CompletedAssessmentListView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void didUpdateWidget(covariant CompletedAssessmentListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSearchText();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _syncSearchText();

    return SafeArea(
      child: Padding(
        padding: AppSpacing.pPage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.header != null) ...[widget.header!, AppSpacing.gapH24],
            _buildSearchField(context),
            AppSpacing.gapH16,
            _buildSortControls(widget.query),
            AppSpacing.gapH16,
            Expanded(
              child: widget.state.when(
                loading: _buildLoadingState,
                error: (error, stackTrace) => _buildScrollableMessage(
                  child: AppEmptyState(
                    icon: LucideIcons.cloudOff,
                    title: 'Gagal memuat penilaian selesai.',
                    message:
                        'Periksa koneksi lalu coba lagi untuk mengambil daftar formulir.',
                    actionIcon: LucideIcons.refreshCw,
                    actionLabel: 'Coba Lagi',
                    onAction: widget.onRefresh,
                  ),
                ),
                data: (page) => _buildContent(page, widget.role, widget.config),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableMessage({required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pAll16,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(child: child),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _searchController,
      builder: (context, value, child) {
        return TextField(
          key: const Key('completed-assessment-search'),
          controller: _searchController,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Cari formulir selesai',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: AppTheme.sogan.withValues(alpha: 0.35),
            ),
            prefixIcon: const Icon(LucideIcons.search),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(LucideIcons.x),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSortControls(CompletedAssessmentQuery query) {
    return Row(
      children: [
        Expanded(
          child: AppSortDropdownField<CompletedAssessmentSortField>(
            fieldKey: const Key('completed-assessment-sort-field'),
            label: 'Urutkan',
            value: query.sort,
            items: CompletedAssessmentSortField.values
                .map(
                  (value) => DropdownMenuItem<CompletedAssessmentSortField>(
                    value: value,
                    child: Text(value.label),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                widget.onSortChanged(value);
              }
            },
          ),
        ),
        AppSpacing.gapW12,
        IconButton(
          key: const Key('completed-assessment-toggle-sort-direction'),
          onPressed: widget.onToggleSortDirection,
          tooltip: query.direction == CompletedAssessmentSortDirection.asc
              ? 'Urutan naik'
              : 'Urutan turun',
          icon: Icon(
            query.direction == CompletedAssessmentSortDirection.asc
                ? LucideIcons.arrowUp
                : LucideIcons.arrowDown,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppTheme.sogan),
      ),
    );
  }

  Widget _buildContent(
    PaginatedResponse<AssessmentFormModel> page,
    UserRole? role,
    CompletedAssessmentListConfig config,
  ) {
    if (page.isEmpty) {
      final isSearching = _searchController.text.trim().isNotEmpty;
      return _buildScrollableMessage(
        child: AppEmptyState(
          icon: isSearching ? LucideIcons.searchX : LucideIcons.history,
          title: isSearching ? 'Formulir tidak ditemukan.' : config.emptyTitle,
          message: isSearching
              ? 'Coba ubah kata kunci untuk menemukan formulir yang dicari.'
              : config.emptyMessage,
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.onRefresh,
            color: AppTheme.sogan,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: page.items.length,
              separatorBuilder: (_, _) => AppSpacing.gapH12,
              itemBuilder: (context, index) {
                final activity = page.items[index];
                return CompletedActivityCard(
                  activity: activity,
                  role: role,
                  config: config,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onActivityTap(activity);
                  },
                );
              },
            ),
          ),
        ),
        AppPaginationFooter(
          currentPage: page.meta.currentPage,
          lastPage: page.meta.lastPage,
          hasPreviousPage: page.hasPreviousPage,
          hasNextPage: page.hasNextPage,
          onPrevious: widget.onPreviousPage,
          onNext: widget.onNextPage,
        ),
      ],
    );
  }

  void _syncSearchText() {
    if (_searchController.text == widget.query.search) {
      return;
    }

    _searchController.value = TextEditingValue(
      text: widget.query.search,
      selection: TextSelection.collapsed(offset: widget.query.search.length),
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      widget.onSearchChanged(value);
    });
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onClearSearch();
    setState(() {});
  }
}

class CompletedActivityCard extends StatelessWidget {
  const CompletedActivityCard({
    super.key,
    required this.activity,
    required this.role,
    required this.config,
    required this.onTap,
  });

  final AssessmentFormModel activity;
  final UserRole? role;
  final CompletedAssessmentListConfig config;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = _formatAssessmentDate(activity.createdAt);
    final scoreLabel = _formatScore(activity.scores, role);
    final hasRoleAction = role == UserRole.walidata || role == UserRole.admin;
    final showSummaryText = role == UserRole.opd
        ? true
        : (config.taskDescription ?? '').isNotEmpty;
    final summaryText = role == UserRole.opd
        ? formattedDate
        : config.taskDescription ?? '';

    return EthnoCard(
      isFlat: true,
      margin: EdgeInsets.zero,
      onTap: onTap,
      padding: AppSpacing.pAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.sogan.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.checkCircle2,
                  color: AppTheme.sogan,
                  size: 22,
                ),
              ),
              AppSpacing.gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppTheme.sogan,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (showSummaryText) ...[
                      AppSpacing.gapH4,
                      Text(
                        summaryText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppTheme.neutral,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          fontSize: EthnoTextTheme.of(
                            context,
                          ).labelTiny.fontSize,
                        ),
                      ),
                    ],
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
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (role != UserRole.opd)
                      Text(
                        formattedDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppTheme.neutral,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (activity.domainsCount > 0)
                      _CardBadge(
                        label: '${activity.domainsCount} domain',
                        backgroundColor: AppTheme.shellSurfaceSoft,
                        foregroundColor: AppTheme.neutral,
                      ),
                    if (hasRoleAction)
                      _CardBadge(
                        label: 'Perlu tindak lanjut',
                        backgroundColor: config.highlightColor.withValues(
                          alpha: 0.08,
                        ),
                        foregroundColor: config.highlightColor,
                      ),
                    if (scoreLabel != null)
                      _CardBadge(
                        label: '${config.scoreLabel}: $scoreLabel',
                        backgroundColor: AppTheme.shellSurfaceSoft,
                        foregroundColor: AppTheme.sogan,
                      ),
                  ],
                ),
              ),
              AppSpacing.gapW8,
              _CardBadge(
                label: config.ctaLabel,
                backgroundColor: AppTheme.sogan.withValues(alpha: 0.08),
                foregroundColor: AppTheme.sogan,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _formatScore(RoleScore? scores, UserRole? role) {
    final double? value = switch (role) {
      UserRole.admin => scores?.admin ?? scores?.walidata ?? scores?.opd,
      UserRole.walidata => scores?.walidata ?? scores?.opd ?? scores?.admin,
      _ => scores?.admin ?? scores?.walidata ?? scores?.opd,
    };
    if (value == null) {
      return null;
    }
    return value.toStringAsFixed(2);
  }

  String _formatAssessmentDate(DateTime value) {
    try {
      return DateFormat('dd MMM yyyy', 'id_ID').format(value);
    } on Exception {
      return DateFormat('dd MMM yyyy').format(value);
    }
  }
}

class _CardBadge extends StatelessWidget {
  const _CardBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.fontWeight = FontWeight.w700,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: fontWeight,
          letterSpacing: 0.3,
          fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
        ),
      ),
    );
  }
}
