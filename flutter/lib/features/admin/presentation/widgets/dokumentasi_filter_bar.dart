import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/widgets/app_sort_dropdown_field.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/admin_activity_query.dart';
import '../controller/admin_dokumentasi_controller.dart';

class DokumentasiFilterBar extends ConsumerStatefulWidget {
  const DokumentasiFilterBar({super.key});

  @override
  ConsumerState<DokumentasiFilterBar> createState() =>
      _DokumentasiFilterBarState();
}

class _DokumentasiFilterBarState extends ConsumerState<DokumentasiFilterBar> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  void _applySearch(String value) {
    final trimmed = value.trim();
    final notifier = ref.read(adminDokumentasiControllerProvider.notifier);
    final currentQuery = ref.read(
      adminDokumentasiControllerProvider.select((state) => state.activeQuery),
    );

    if (trimmed == currentQuery.search) {
      return;
    }

    notifier.setSearch(trimmed);
    notifier.refresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final query = ref.read(adminDokumentasiControllerProvider).activeQuery;
    if (_searchController.text != query.search) {
      _searchController.text = query.search;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(
      adminDokumentasiControllerProvider.select((state) => state.activeQuery),
    );
    final searchField = ValueListenableBuilder<TextEditingValue>(
      valueListenable: _searchController,
      builder: (context, value, _) {
        return AppTextField(
          controller: _searchController,
          label: 'Cari dokumentasi...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _debounce?.cancel();
                    _searchController.clear();
                    _applySearch('');
                  },
                  icon: const Icon(Icons.clear),
                ),
          onChanged: (nextValue) {
            _debounce?.cancel();
            _debounce = Timer(
              const Duration(milliseconds: 400),
              () => _applySearch(nextValue),
            );
          },
          onSubmitted: _applySearch,
        );
      },
    );

    final sortField = AppSortDropdownField<AdminActivitySortField>(
      fieldKey: const Key('admin-documentation-sort-field'),
      label: 'Urutkan',
      value: query.sort,
      items: AdminActivitySortField.values
          .map(
            (value) => DropdownMenuItem<AdminActivitySortField>(
              value: value,
              child: Text(value.label, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        final notifier = ref.read(adminDokumentasiControllerProvider.notifier);
        notifier.setSort(value);
        notifier.refresh();
      },
    );

    final directionButton = Container(
      decoration: BoxDecoration(
        color: AppTheme.sogan,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sogan.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        key: const Key('admin-documentation-toggle-sort-direction'),
        icon: Icon(
          query.direction.apiValue == 'asc'
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded,
          color: AppTheme.gold,
        ),
        tooltip: query.direction.apiValue == 'asc'
            ? 'Urutan naik'
            : 'Urutan turun',
        onPressed: () {
          final notifier = ref.read(
            adminDokumentasiControllerProvider.notifier,
          );
          notifier.toggleSortDirection();
          notifier.refresh();
        },
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 760;

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchField,
              AppSpacing.gapH12,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: sortField),
                  AppSpacing.gapW12,
                  directionButton,
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 3, child: searchField),
            AppSpacing.gapW12,
            Expanded(flex: 2, child: sortField),
            AppSpacing.gapW12,
            directionButton,
          ],
        );
      },
    );
  }
}
