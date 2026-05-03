part of '../penilaian_mandiri_screen.dart';

class _BuatFormulirView extends ConsumerWidget {
  const _BuatFormulirView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _FormulirListView(
      emptyMessage: 'Formulir yang tersedia akan muncul di halaman ini.',
      itemBuilder: (activity) => _FormulirCard(
        activity: activity,
        actionLabel: 'KELOLA FORMULIR',
        onTap: (_) => _openFormulirDetail(context, activity),
        onEdit: () => _openFormulirEdit(context, activity),
        onDelete: () => _deleteFormulir(context, ref, activity),
      ),
    );
  }

  void _openFormulirDetail(BuildContext context, AssessmentFormModel activity) {
    HapticFeedback.lightImpact();
    context.push(
      RouteConstants.assessmentDetail.replaceFirst(':id', activity.id),
    );
  }

  void _openFormulirEdit(BuildContext context, AssessmentFormModel activity) {
    HapticFeedback.lightImpact();
    context.push(
      RouteConstants.assessmentEdit.replaceFirst(':id', activity.id),
      extra: activity,
    );
  }

  Future<void> _deleteFormulir(
    BuildContext context,
    WidgetRef ref,
    AssessmentFormModel activity,
  ) async {
    final bool? confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Hapus formulir?',
      content:
          'Formulir "${activity.title}" akan dihapus permanen dari daftar ini.',
      confirmLabel: 'Hapus',
      isDanger: true,
    );
    if (confirmed != true) {
      return;
    }

    try {
      await ref
          .read(assessmentListControllerProvider.notifier)
          .deleteActivity(activity.id);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulir berhasil dihapus')),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus formulir: $error'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }
}

class _IsiFormulirView extends StatelessWidget {
  const _IsiFormulirView({
    required this.formulir,
    required this.onSelectFormulir,
  });

  final AssessmentFormModel? formulir;
  final void Function(AssessmentFormModel) onSelectFormulir;

  @override
  Widget build(BuildContext context) {
    if (formulir == null) {
      return _FormulirList(onSelect: onSelectFormulir);
    }

    return _PenilaianView(formulir: formulir);
  }
}

class _FormulirList extends ConsumerWidget {
  const _FormulirList({required this.onSelect});

  final void Function(AssessmentFormModel) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _FormulirListView(
      emptyMessage: 'Hubungi admin untuk menambahkan formulir.',
      itemBuilder: (activity) => _FormulirCard(
        activity: activity,
        onTap: (formulir) {
          HapticFeedback.lightImpact();
          onSelect(formulir);
        },
        actionLabel: 'MULAI MENILAI',
      ),
    );
  }
}

class _FormulirListView extends ConsumerWidget {
  const _FormulirListView({
    required this.emptyMessage,
    required this.itemBuilder,
  });

  final String emptyMessage;
  final Widget Function(AssessmentFormModel activity) itemBuilder;

  Future<void> _handleRefresh(WidgetRef ref) async {
    await HapticFeedback.mediumImpact();
    await ref
        .read(assessmentListControllerProvider.notifier)
        .refreshActivities();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(assessmentListControllerProvider);

    return activitiesAsync.when(
      data: (page) {
        final activities = page.items;
        return RefreshIndicator(
          onRefresh: () => _handleRefresh(ref),
          child: activities.isEmpty
              ? _buildAlwaysScrollableState(
                  child: Padding(
                    padding: AppSpacing.pAll16,
                    child: AppEmptyState(
                      icon: Icons.assignment_outlined,
                      title: 'Belum ada formulir penilaian.',
                      message: emptyMessage,
                    ),
                  ),
                )
              : _FormulirPageList(
                  page: page,
                  itemBuilder: itemBuilder,
                  onPreviousPage: () => ref
                      .read(assessmentListControllerProvider.notifier)
                      .previousPage(),
                  onNextPage: () => ref
                      .read(assessmentListControllerProvider.notifier)
                      .nextPage(),
                ),
        );
      },
      loading: () => const AssessmentSkeleton(),
      error: (err, stack) => RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        child: _buildAlwaysScrollableState(
          child: AppErrorState(
            message: AppErrorMapper.toMessage(
              err,
              fallbackMessage: 'Gagal memuat formulir. Silakan coba lagi.',
            ),
            onRetry: () => ref.invalidate(assessmentListControllerProvider),
          ),
        ),
      ),
    );
  }
}

class _FormulirPageList extends StatelessWidget {
  const _FormulirPageList({
    required this.page,
    required this.itemBuilder,
    required this.onPreviousPage,
    required this.onNextPage,
  });

  final PaginatedResponse<AssessmentFormModel> page;
  final Widget Function(AssessmentFormModel activity) itemBuilder;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.pAll16,
            itemCount: page.items.length,
            separatorBuilder: (context, index) => AppSpacing.gapH12,
            itemBuilder: (context, index) => itemBuilder(page.items[index]),
          ),
        ),
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
}

class _FormulirCard extends StatelessWidget {
  const _FormulirCard({
    required this.activity,
    required this.onTap,
    required this.actionLabel,
    this.onEdit,
    this.onDelete,
  });

  final AssessmentFormModel activity;
  final void Function(AssessmentFormModel) onTap;
  final String actionLabel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return EthnoCard(
      isFlat: true,
      onTap: () => onTap(activity),
      padding: AppSpacing.pAll16,
      margin: EdgeInsets.zero,
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
                  Icons.assignment_outlined,
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
                      activity.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppTheme.sogan,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AppSpacing.gapH4,
                    Text(
                      'FORMULIR PENILAIAN MANDIRI',
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
              if (onEdit != null || onDelete != null)
                PopupMenuButton<_FormulirCardAction>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppTheme.sogan,
                  ),
                  onSelected: (action) {
                    switch (action) {
                      case _FormulirCardAction.edit:
                        onEdit?.call();
                        break;
                      case _FormulirCardAction.delete:
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) =>
                      <PopupMenuEntry<_FormulirCardAction>>[
                        const PopupMenuItem<_FormulirCardAction>(
                          value: _FormulirCardAction.edit,
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Edit nama'),
                          ),
                        ),
                        const PopupMenuItem<_FormulirCardAction>(
                          value: _FormulirCardAction.delete,
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.delete_outline,
                              color: AppTheme.error,
                            ),
                            title: Text('Hapus'),
                          ),
                        ),
                      ],
                )
              else
                const Icon(Icons.chevron_right_rounded, color: AppTheme.sogan),
            ],
          ),
          AppSpacing.gapH16,
          const Divider(height: 1, thickness: 0.5),
          AppSpacing.gapH12,
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: AppTheme.gold,
              ),
              AppSpacing.gapW6,
              Text(
                'Dibuat: ${_formatDate(activity.date)}',
                style: textTheme.labelSmall?.copyWith(
                  color: AppTheme.neutral,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
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
                  actionLabel,
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

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _PenilaianView extends ConsumerStatefulWidget {
  const _PenilaianView({required this.formulir});

  final AssessmentFormModel? formulir;

  @override
  ConsumerState<_PenilaianView> createState() => _PenilaianViewState();
}

class _PenilaianViewState extends ConsumerState<_PenilaianView> {
  int? _openDomainIndex;
  final Map<int, int?> _openAspectIndexByDomain = {};
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (widget.formulir == null) {
      return Center(
        child: Text(
          'Pilih formulir terlebih dahulu.',
          style: textTheme.bodyMedium,
        ),
      );
    }

    final int formulirId = int.tryParse(widget.formulir!.id) ?? 0;
    final controllerAsync = ref.watch(
      assessmentFormControllerProvider(formulirId),
    );

    return controllerAsync.when(
      loading: () => const DetailSkeleton(),
      error: (error, _) => RefreshIndicator(
        onRefresh: () => _handleRefresh(formulirId),
        child: _buildAlwaysScrollableState(
          child: AppErrorState(
            message: AppErrorMapper.toMessage(
              error,
              fallbackMessage: 'Gagal memuat penilaian. Silakan coba lagi.',
            ),
            onRetry: () =>
                ref.invalidate(assessmentFormControllerProvider(formulirId)),
          ),
        ),
      ),
      data: (state) {
        final domains = state.formulir?.domains ?? [];

        if (domains.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _handleRefresh(formulirId),
            child: _buildAlwaysScrollableState(
              child: const Padding(
                padding: AppSpacing.pAll16,
                child: AppEmptyState(
                  icon: Icons.assignment_late_outlined,
                  title: 'Belum ada domain tersedia.',
                  message:
                      'Domain penilaian akan muncul di halaman ini setelah formulir dilengkapi.',
                ),
              ),
            ),
          );
        }

        final int totalIndicators = domains.fold(
          0,
          (sum, d) => sum + d.indicatorCount,
        );
        final int filledIndicators = state.draftsByIndikatorId.length;
        final double progress = totalIndicators > 0
            ? filledIndicators / totalIndicators
            : 0.0;

        return RefreshIndicator(
          onRefresh: () => _handleRefresh(formulirId),
          child: Column(
            children: [
              _buildHeader(
                textTheme,
                filledIndicators,
                totalIndicators,
                progress,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    return TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari indikator...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: value.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppTheme.shellSurfaceSoft,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => setState(
                        () => _searchQuery = val.trim().toLowerCase(),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: _searchQuery.isEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          final bool isLargeScreen =
                              constraints.maxWidth >= 600;

                          if (isLargeScreen) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: _buildDomainList(
                                    domains,
                                    state,
                                    textTheme,
                                  ),
                                ),
                                const VerticalDivider(width: 1),
                                Expanded(
                                  child: ColoredBox(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    child: _openDomainIndex == null
                                        ? _buildAlwaysScrollableState(
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.touch_app_outlined,
                                                    size: 48,
                                                    color: AppTheme.neutral,
                                                  ),
                                                  AppSpacing.gapH16,
                                                  Text(
                                                    'Pilih domain untuk melihat indikator',
                                                    style: textTheme.bodyLarge
                                                        ?.copyWith(
                                                          color:
                                                              AppTheme.neutral,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : _buildIndicatorList(
                                            domains[_openDomainIndex!],
                                            state,
                                            textTheme,
                                            formulirId,
                                          ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return _buildDomainList(
                            domains,
                            state,
                            textTheme,
                            formulirId: formulirId,
                          );
                        },
                      )
                    : _buildSearchResults(
                        domains,
                        state,
                        textTheme,
                        formulirId,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleRefresh(int formulirId) async {
    await HapticFeedback.mediumImpact();
    ref.invalidate(assessmentFormControllerProvider(formulirId));
    await ref.read(assessmentFormControllerProvider(formulirId).future);
  }

  Widget _buildSearchResults(
    List<DomainModel> domains,
    AssessmentFormState state,
    TextTheme textTheme,
    int formulirId,
  ) {
    final List<AssessmentIndikator> allMatchingIndicators = [];

    for (final domain in domains) {
      for (final aspect in domain.aspects) {
        for (final indicator in aspect.indicators) {
          final indModel = indicator.toAssessmentIndikator(
            aspectId: aspect.id,
            aspectName: aspect.name,
            domainName: domain.name,
          );
          if (indModel.namaIndikator.toLowerCase().contains(_searchQuery)) {
            allMatchingIndicators.add(indModel);
          }
        }
      }
    }

    if (allMatchingIndicators.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: AppEmptyState(
          icon: Icons.search_off_rounded,
          title: 'Indikator tidak ditemukan.',
          message:
              'Coba gunakan kata kunci lain untuk menemukan indikator yang dicari.',
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: allMatchingIndicators.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _buildIndicatorTile(
          allMatchingIndicators[index],
          state,
          textTheme,
          formulirId,
        );
      },
    );
  }

  Widget _buildHeader(
    TextTheme textTheme,
    int filled,
    int total,
    double progress,
  ) {
    return Container(
      padding: AppSpacing.pAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.formulir!.title.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppTheme.sogan,
              letterSpacing: 1.1,
            ),
          ),
          AppSpacing.gapH12,
          EthnoProgressBar(
            label: 'Progres Pengisian',
            value: progress,
            color: progress == 1.0 ? AppTheme.success : AppTheme.navy,
          ),
        ],
      ),
    );
  }

  Widget _buildDomainList(
    List<DomainModel> domains,
    AssessmentFormState state,
    TextTheme textTheme, {
    int? formulirId,
  }) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: domains.length,
      separatorBuilder: (context, index) => AppSpacing.gapH12,
      itemBuilder: (context, index) {
        final domain = domains[index];
        final isSelected = _openDomainIndex == index;

        return Card(
          color: isSelected
              ? AppTheme.gold.withValues(alpha: 0.05)
              : AppTheme.shellSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            side: BorderSide(
              color: isSelected
                  ? AppTheme.gold
                  : AppTheme.sogan.withValues(alpha: 0.1),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: ExpansionTile(
            key: PageStorageKey('domain_${domain.name}'),
            initiallyExpanded: isSelected,
            onExpansionChanged: (expanded) {
              if (expanded) {
                setState(() => _openDomainIndex = index);
              }
            },
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            title: Text(
              domain.name,
              style: textTheme.titleSmall?.copyWith(
                color: isSelected ? AppTheme.sogan : AppTheme.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              '${domain.aspects.length} ASPEK • ${domain.indicatorCount} INDIKATOR',
              style: textTheme.labelSmall?.copyWith(
                color: AppTheme.neutral,
                fontWeight: FontWeight.w700,
                fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
                letterSpacing: 0.5,
              ),
            ),
            children: [
              if (domain.aspects.isEmpty)
                const Padding(
                  padding: AppSpacing.pAll16,
                  child: Text('Tidak ada aspek'),
                )
              else
                ...domain.aspects.asMap().entries.map((entry) {
                  final aspectIndex = entry.key;
                  final aspek = entry.value;
                  final int aspectFilled = aspek.indicators
                      .where(
                        (ind) => state.draftsByIndikatorId.containsKey(
                          int.tryParse(ind.id) ?? -1,
                        ),
                      )
                      .length;

                  return ExpansionTile(
                    key: PageStorageKey('aspek_${aspek.id}'),
                    initiallyExpanded:
                        _openAspectIndexByDomain[index] == aspectIndex,
                    onExpansionChanged: (expanded) {
                      if (expanded) {
                        setState(
                          () => _openAspectIndexByDomain[index] = aspectIndex,
                        );
                      }
                    },
                    title: Text(
                      aspek.name,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (aspectFilled == aspek.indicators.length
                                        ? AppTheme.success
                                        : AppTheme.neutral)
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$aspectFilled/${aspek.indicators.length}',
                            style: textTheme.labelSmall?.copyWith(
                              color: aspectFilled == aspek.indicators.length
                                  ? AppTheme.success
                                  : AppTheme.neutral,
                              fontWeight: FontWeight.w900,
                              fontSize:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.fontSize ??
                                  10,
                            ),
                          ),
                        ),
                        AppSpacing.gapW8,
                        const Icon(Icons.expand_more_rounded, size: 20),
                      ],
                    ),
                    children: formulirId != null
                        ? aspek.indicators.map((indicator) {
                            return _buildIndicatorTile(
                              indicator.toAssessmentIndikator(
                                aspectId: aspek.id,
                                aspectName: aspek.name,
                                domainName: domain.name,
                              ),
                              state,
                              textTheme,
                              formulirId,
                            );
                          }).toList()
                        : [const SizedBox.shrink()],
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIndicatorList(
    DomainModel domain,
    AssessmentFormState state,
    TextTheme textTheme,
    int formulirId,
  ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.pAll16,
      children: [
        Text(
          domain.name,
          style: textTheme.headlineSmall?.copyWith(
            color: AppTheme.sogan,
            fontWeight: FontWeight.w900,
          ),
        ),
        AppSpacing.gapH24,
        ...domain.aspects.expand(
          (aspek) => [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                aspek.name.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ...aspek.indicators.map((indicator) {
              return _buildIndicatorTile(
                indicator.toAssessmentIndikator(
                  aspectId: aspek.id,
                  aspectName: aspek.name,
                  domainName: domain.name,
                ),
                state,
                textTheme,
                formulirId,
              );
            }),
            const Divider(height: 32),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicatorTile(
    AssessmentIndikator indicator,
    AssessmentFormState state,
    TextTheme textTheme,
    int formulirId,
  ) {
    final bool isFilled = state.draftsByIndikatorId.containsKey(indicator.id);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: isFilled
              ? AppTheme.success
              : AppTheme.neutral.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        indicator.namaIndikator,
        style: textTheme.bodySmall?.copyWith(
          fontWeight: isFilled ? FontWeight.w600 : FontWeight.w500,
          color: AppTheme.sogan.withValues(alpha: isFilled ? 1.0 : 0.7),
        ),
      ),
      trailing: isFilled
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.success.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'TERISI',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
                  color: AppTheme.success,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.error.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                'BELUM',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
                  color: AppTheme.error,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
      onTap: () {
        HapticFeedback.lightImpact();
        context.push(
          Uri(
            path:
                '${RouteConstants.assessmentKegiatan}/indicator/${indicator.id}',
            queryParameters: {
              'formulirId': formulirId.toString(),
              'nama': indicator.namaIndikator,
            },
          ).toString(),
        );
      },
    );
  }
}

Widget _buildAlwaysScrollableState({required Widget child}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      );
    },
  );
}
