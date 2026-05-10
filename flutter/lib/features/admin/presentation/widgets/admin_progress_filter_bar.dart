import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/widgets/app_filter_bar.dart';

import '../../domain/admin_assessment_progress_query.dart';

class AdminProgressFilterBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AppFilterBar(
      search: AppFilterSearchField(
        initialValue: query.search,
        hintText: 'Cari progress penilaian',
        onChanged: onSearchChanged,
      ),
      filters: [
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Urutkan',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AdminAssessmentProgressSortBy>(
              isExpanded: true,
              value: query.sortBy,
              onChanged: (value) {
                if (value != null) onSortChanged(value);
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
        ),
      ],
      trailing: IconButton(
        tooltip: query.sortDirection == SortDirection.asc
            ? 'Urutan naik'
            : 'Urutan turun',
        onPressed: onToggleSortDirection,
        icon: Icon(
          query.sortDirection == SortDirection.asc
              ? LucideIcons.arrowUp
              : LucideIcons.arrowDown,
        ),
      ),
    );
  }
}
