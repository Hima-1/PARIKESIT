import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/tokens/colors.dart';
import 'package:parikesit/core/theme/tokens/radii.dart';
import 'package:parikesit/core/widgets/app_filter_bar.dart';
import 'package:parikesit/core/widgets/app_sort_dropdown_field.dart';
import 'package:parikesit/core/widgets/app_text_field.dart';

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

    if (trimmed == currentQuery.search) return;

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
          prefixIcon: const Icon(LucideIcons.search),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _debounce?.cancel();
                    _searchController.clear();
                    _applySearch('');
                  },
                  tooltip: 'Hapus pencarian',
                  icon: const Icon(LucideIcons.x),
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

    final scheme = Theme.of(context).colorScheme;
    final directionButton = DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadii.rrSm,
        border: Border.all(color: scheme.outline),
      ),
      child: IconButton(
        key: const Key('admin-documentation-toggle-sort-direction'),
        icon: Icon(
          query.direction.apiValue == 'asc'
              ? LucideIcons.arrowUp
              : LucideIcons.arrowDown,
          color: AppColors.textStrong,
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

    return AppFilterBar(
      narrowWidth: 760,
      search: searchField,
      filters: [sortField],
      trailing: directionButton,
    );
  }
}
