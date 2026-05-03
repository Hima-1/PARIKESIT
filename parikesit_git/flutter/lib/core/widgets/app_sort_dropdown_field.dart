import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_theme.dart';

class AppSortDropdownField<T> extends StatelessWidget {
  const AppSortDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.fieldKey,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      key: fieldKey,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppTheme.sogan.withValues(alpha: 0.5),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.sogan,
          ),
          items: items,
        ),
      ),
    );
  }
}
