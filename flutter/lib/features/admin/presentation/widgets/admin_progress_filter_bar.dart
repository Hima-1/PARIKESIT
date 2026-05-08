import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';

import '../../domain/admin_assessment_progress_query.dart';

class AdminProgressFilterBar extends StatefulWidget {
  const AdminProgressFilterBar({
    super.key,
    required this.query,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onToggleSortDirection,
  });

  final AdminAssessmentProgressQuery query;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<AdminAssessmentProgressSortBy> onSortChanged;
  final VoidCallback onToggleSortDirection;

  @override
  State<AdminProgressFilterBar> createState() => _AdminProgressFilterBarState();
}

class _AdminProgressFilterBarState extends State<AdminProgressFilterBar> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query.search);
  }

  @override
  void didUpdateWidget(covariant AdminProgressFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query.search != widget.query.search &&
        _controller.text != widget.query.search) {
      _controller.text = widget.query.search;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 720;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(),
              AppSpacing.gapH12,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildSortField()),
                  AppSpacing.gapW12,
                  _buildSortDirectionButton(),
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildSearchField()),
            AppSpacing.gapW12,
            Expanded(flex: 2, child: _buildSortField()),
            AppSpacing.gapW12,
            _buildSortDirectionButton(),
          ],
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        hintText: 'Cari progress penilaian',
        prefixIcon: Icon(LucideIcons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 400), () {
          widget.onSearchChanged(value.trim());
        });
      },
    );
  }

  Widget _buildSortField() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Urutkan',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AdminAssessmentProgressSortBy>(
          isExpanded: true,
          value: widget.query.sortBy,
          onChanged: (value) {
            if (value != null) {
              widget.onSortChanged(value);
            }
          },
          items: AdminAssessmentProgressSortBy.values
              .map(
                (value) => DropdownMenuItem<AdminAssessmentProgressSortBy>(
                  value: value,
                  child: Text(value.label),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSortDirectionButton() {
    return IconButton(
      tooltip: widget.query.sortDirection == SortDirection.asc
          ? 'Urutan naik'
          : 'Urutan turun',
      onPressed: widget.onToggleSortDirection,
      icon: Icon(
        widget.query.sortDirection == SortDirection.asc
            ? LucideIcons.arrowUp
            : LucideIcons.arrowDown,
      ),
    );
  }
}
