import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_empty_state.dart';
import 'package:parikesit/core/widgets/app_pagination_footer.dart';
import 'package:parikesit/core/widgets/app_sort_dropdown_field.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';

class PublicCompletedAssessmentSection extends StatefulWidget {
  const PublicCompletedAssessmentSection({
    super.key,
    required this.state,
    required this.query,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSortChanged,
    required this.onToggleSortDirection,
    required this.onRefresh,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onActivityTap,
    this.padding = const EdgeInsets.all(24),
  });

  final AsyncValue<PaginatedResponse<AssessmentFormModel>> state;
  final CompletedAssessmentQuery query;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<CompletedAssessmentSortField> onSortChanged;
  final VoidCallback onToggleSortDirection;
  final Future<void> Function() onRefresh;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final ValueChanged<AssessmentFormModel> onActivityTap;
  final EdgeInsetsGeometry padding;

  @override
  State<PublicCompletedAssessmentSection> createState() =>
      _PublicCompletedAssessmentSectionState();
}

class _PublicCompletedAssessmentSectionState
    extends State<PublicCompletedAssessmentSection> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void didUpdateWidget(covariant PublicCompletedAssessmentSection oldWidget) {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 600;

        return Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar formulir selesai',
                style:
                    (isCompact
                            ? Theme.of(context).textTheme.titleLarge
                            : Theme.of(context).textTheme.headlineMedium)
                        ?.copyWith(
                          color: AppTheme.sogan,
                          fontWeight: FontWeight.w900,
                        ),
              ),
              AppSpacing.gapH8,
              Text(
                'Telusuri formulir selesai lalu buka daftar OPD dan skor akhirnya.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.pusaka.withValues(alpha: 0.78),
                  height: 1.5,
                ),
              ),
              SizedBox(height: isCompact ? 16 : 24),
              _buildToolbar(context),
              SizedBox(height: isCompact ? 16 : 24),
              widget.state.when(
                loading: _buildLoadingState,
                error: (error, stackTrace) => AppEmptyState(
                  icon: Icons.cloud_off_rounded,
                  title: 'Gagal memuat penilaian selesai.',
                  message:
                      'Periksa koneksi lalu muat ulang untuk mengambil daftar formulir publik.',
                  actionIcon: Icons.refresh_rounded,
                  actionLabel: 'Coba lagi',
                  onAction: () {
                    widget.onRefresh();
                  },
                ),
                data: _buildContent,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 720;
        final double spacing = constraints.maxWidth < 600 ? 12 : 16;

        final Widget searchField = _buildSearchField(context);
        final Widget sortControls = _buildSortControls(widget.query);

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: searchField),
              SizedBox(width: spacing),
              Expanded(flex: 2, child: sortControls),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchField,
            SizedBox(height: spacing),
            sortControls,
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
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            hintText: 'Cari formulir selesai',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: AppTheme.sogan.withValues(alpha: 0.35),
            ),
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSortControls(CompletedAssessmentQuery query) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 420;

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
            SizedBox(width: isCompact ? 8 : 12),
            IconButton.filledTonal(
              key: const Key('completed-assessment-toggle-sort-direction'),
              onPressed: widget.onToggleSortDirection,
              tooltip: query.direction == CompletedAssessmentSortDirection.asc
                  ? 'Urutan naik'
                  : 'Urutan turun',
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.sogan.withValues(alpha: 0.08),
                foregroundColor: AppTheme.sogan,
              ),
              icon: Icon(
                query.direction == CompletedAssessmentSortDirection.asc
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List<Widget>.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16),
          child: Container(
            height: 168,
            decoration: BoxDecoration(
              color: AppTheme.sogan.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(PaginatedResponse<AssessmentFormModel> page) {
    if (page.isEmpty) {
      final bool isSearching = _searchController.text.trim().isNotEmpty;
      return AppEmptyState(
        icon: isSearching ? Icons.search_off_rounded : Icons.history_rounded,
        title: isSearching
            ? 'Formulir tidak ditemukan.'
            : 'Belum ada data publik.',
        message: isSearching
            ? 'Coba gunakan kata kunci lain untuk menemukan formulir yang dicari.'
            : 'Daftar formulir penilaian akan muncul di sini setelah penilaian selesai tersedia untuk publik.',
      );
    }

    return Column(
      children: [
        ...page.items.map(
          (activity) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PublicCompletedAssessmentCard(
              activity: activity,
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onActivityTap(activity);
              },
            ),
          ),
        ),
        if (page.items.isNotEmpty) AppSpacing.gapH8,
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

class PublicCompletedAssessmentCard extends StatelessWidget {
  const PublicCompletedAssessmentCard({
    super.key,
    required this.activity,
    required this.onTap,
  });

  final AssessmentFormModel activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final String formattedDate = _formatAssessmentDate(activity.createdAt);
    final String? scoreLabel = _formatScore(activity.scores);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 600;

        return InkWell(
          borderRadius: BorderRadius.circular(isCompact ? 20 : 24),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: AppTheme.shellSurfaceSoft,
              borderRadius: BorderRadius.circular(isCompact ? 20 : 24),
              border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.08)),
            ),
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, innerConstraints) {
                      final bool isWide = innerConstraints.maxWidth >= 660;
                      final Widget headline = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                (isCompact
                                        ? textTheme.titleMedium
                                        : textTheme.titleLarge)
                                    ?.copyWith(
                                      color: AppTheme.sogan,
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                          AppSpacing.gapH6,
                          Text(
                            'Buka daftar OPD dan lihat skor akhir formulir ini.',
                            maxLines: isCompact ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppTheme.pusaka.withValues(alpha: 0.8),
                              height: 1.45,
                            ),
                          ),
                        ],
                      );

                      final Widget scorePanel = Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 14 : 18,
                          vertical: isCompact ? 12 : 16,
                        ),
                        decoration: BoxDecoration(
                          color: Color.alphaBlend(
                            AppTheme.gold.withValues(alpha: 0.08),
                            AppTheme.merang,
                          ),
                          borderRadius: BorderRadius.circular(
                            isCompact ? 16 : 20,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SKOR AKHIR',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppTheme.sogan,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),
                            AppSpacing.gapH4,
                            Text(
                              scoreLabel ?? 'Belum tersedia',
                              style:
                                  (isCompact
                                          ? textTheme.titleLarge
                                          : textTheme.headlineSmall)
                                      ?.copyWith(
                                        color: AppTheme.sogan,
                                        fontWeight: FontWeight.w900,
                                      ),
                            ),
                          ],
                        ),
                      );

                      if (!isWide) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [headline, AppSpacing.gapH12, scorePanel],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: headline),
                          AppSpacing.gapW16,
                          Expanded(flex: 2, child: scorePanel),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: isCompact ? 12 : 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PublicInfoBadge(
                        label: formattedDate,
                        icon: Icons.event_outlined,
                      ),
                      _PublicInfoBadge(
                        label: '${activity.domainsCount} domain',
                        icon: Icons.grid_view_rounded,
                      ),
                    ],
                  ),
                  SizedBox(height: isCompact ? 14 : 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 14 : 16,
                      vertical: isCompact ? 12 : 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.sogan,
                      borderRadius: BorderRadius.circular(isCompact ? 16 : 18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Lihat skor OPD',
                            style: textTheme.labelLarge?.copyWith(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppTheme.gold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _formatScore(RoleScore? scores) {
    final double? value = scores?.admin ?? scores?.walidata ?? scores?.opd;
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

class _PublicInfoBadge extends StatelessWidget {
  const _PublicInfoBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          AppTheme.gold.withValues(alpha: 0.06),
          AppTheme.merang,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.sogan),
          AppSpacing.gapW8,
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
