import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_theme.dart';

class BpsDataTable extends StatefulWidget {
  const BpsDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
  });
  final List<String> columns;
  final List<List<dynamic>> rows;
  final void Function(int rowIndex)? onRowTap;

  @override
  State<BpsDataTable> createState() => _BpsDataTableState();
}

class _BpsDataTableState extends State<BpsDataTable> {
  late final ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: AppTheme.hairlineBorder,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  AppTheme.sogan.withValues(alpha: 0.05),
                ),
                headingTextStyle: textTheme.labelMedium?.copyWith(
                  color: AppTheme.sogan,
                  fontWeight: FontWeight.w800,
                ),
                dataTextStyle: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.sogan.withValues(alpha: 0.8),
                ),
                columnSpacing: 24,
                horizontalMargin: 20,
                columns: widget.columns.map((col) {
                  return DataColumn(label: Text(col));
                }).toList(),
                rows: widget.rows.asMap().entries.map((entry) {
                  final int rowIndex = entry.key;
                  final List<dynamic> row = entry.value;
                  return DataRow(
                    onSelectChanged: widget.onRowTap == null
                        ? null
                        : (_) => widget.onRowTap?.call(rowIndex),
                    cells: row.map((cell) {
                      return DataCell(Text(cell.toString()));
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
